<?php
/**
 * Paytrail payment handler
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2014.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * @category VuFind
 * @package  OnlinePayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */

require_once 'sys/OnlinePayment/Interface.php';
require_once 'sys/OnlinePayment/Paytrail_Module_Rest.php';
require_once 'services/MyResearch/lib/Transaction.php';

/**
 * Paytrail payment handler module.
 *
 * @category VuFind
 * @package  OnlinePayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */
class Paytrail implements OnlinePaymentInterface
{
    const PAYMENT_SUCCESS = 'success';
    const PAYMENT_FAILURE = 'failure';
    const PAYMENT_NOTIFY = 'notify';

    protected $config;


    /**
     * Constructor
     *
     * @param mixed $config Configuration as key-value pairs.
     *
     * @access public
     */
    public function __construct($config)
    {
        $this->config = $config;
    }

    /**
     * Return name of handler.
     *
     * @return string name
     * @access public
     */
    public function getName()
    {
        return 'Paytrail';
    }

    /**
     * Start Paytrail transaction.
     *
     * @param string $patronId       Patron's catalog username (e.g. barcode)
     * @param float  $amount         Payment amount (without transaction fee)
     * @param float  $transactionFee Transaction fee
     * @param array  $fines          Fines that belong to the transaction
     * @param string $currency       Currency
     * @param string $param          URL parameter that is used for payment 
     * statuses in Paytrail responses.
     *
     * @return false on error, otherwise redirects to Paytrail.
     * @access public
     */
    public function startPayment($patronId, $amount, $transactionFee, $fines, $currency, $param)
    {
        global $configArray;
        global $user;

        $base = $configArray['Site']['url'];
        $urlset = new Paytrail_Module_Rest_Urlset(
            "$base/MyResearch/Fines?$param=" . self::PAYMENT_SUCCESS, 
            "$base/MyResearch/Fines?$param=" . self::PAYMENT_FAILURE,
            "$base/AJAX/PaytrailNotify?$param=" . self::PAYMENT_NOTIFY,
            ""  // pending-url not in use
        );


        $orderNumber = $this->generateTransactionId($patronId);
        $totAmount = ($amount+$transactionFee)/100.00;
        $payment = new Paytrail_Module_Rest_Payment_S1($orderNumber, $urlset, $totAmount);
        
        $module = $this->initPaytrail();
        
        try {
            $result = $module->processPayment($payment);
        } catch (Paytrail_Exception $e) {
            error_log("Paytrail: error starting payment processing.");
            error_log("   " . $e->getMessage());
            header("Location: {$configArray['Site']['url']}/MyResearch/Fines");
        }

        $t = new Transaction();
        $t->transaction_id = $orderNumber;
        $t->driver = reset(explode('.', $orderNumber, 2)); 
        $t->user_id = isset($user) && is_object($user) ? $user->id : null;
        $t->amount = $amount;
        $t->transaction_fee = $transactionFee;
        $t->currency = $currency;
        $t->created = date("Y-m-d H:i:s");
        $t->complete = 0;
        $t->status = 'started';
        $t->cat_username = $patronId;

        if (!$t->insert()) {
            error_log('Paytrail: error creating transaction');
            return false;
        }
        
        foreach ($fines as $fine) {
            if (!$t->addFee($fine, $user, $currency)) {
                error_log('Paytrail: error adding fee to transaction.');
                return false;
            }
        }
        
        header("Location: {$result->getUrl()}");        
    }

    /**
     * Process the response from Paytrail payment service.
     *
     * @param array $params Response variables
     *
     * @return string error message (not translated) 
     *   or associative array with keys:
     *     'markFeesAsPaid' (boolean) true if payment was successful and fees 
     *     should be registered as paid.
     *     'transactionId' (string) Transaction ID.
     *     'amount' (int) Amount to be registered (does not include transaction fee).
     * @access public
     */
    public function processResponse($params)
    {
        $status = $params['payment'];        
        $orderNum = $params['ORDER_NUMBER'];
        $timestamp = $params['TIMESTAMP'];

        $tr = new Transaction();

        if (!$tr->isTransactionInProgress($orderNum)) {            
            return 'online_payment_transaction_already_processed_or_unknown';
        }

        if (($t = $tr->getTransaction($orderNum)) === false) {
            error_log("Paytrail: error processing transaction $orderNum: transaction not found");
            return 'online_payment_failed';
        }

        $amount = $t->amount;
        $paid = false;
        if ($status == self::PAYMENT_SUCCESS || $status == self::PAYMENT_NOTIFY) {
            $module = $this->initPaytrail();
            if (!$module->confirmPayment(
                $params["ORDER_NUMBER"], 
                $params["TIMESTAMP"], 
                $params["PAID"], 
                $params["METHOD"], 
                $params["RETURN_AUTHCODE"]
            )) {
                error_log("Paytrail: error processing response: invalid checksum");
                error_log("   " . var_export($params, true));
                return 'online_payment_failed';
            }

            if (!$t->setTransactionPaid($orderNum, $timestamp)) {
                error_log("Paytrail: error updating transaction $orderNum to paid");
            }
            $paid = true;
        } else if ($status == self::PAYMENT_FAILURE) {
            if (!$t->setTransactionCancelled($orderNum)) {
                error_log("Paytrail: error updating transaction $orderNum to cancelled");
            }
            return 'online_payment_canceled';
        } else {
            $t->setTransactionUnknownPaymentResponse($orderNum, $status);
        }

        return array('markFeesAsPaid' => $paid, 'transactionId' => $orderNum, 'amount' => $amount);
    }

    /**
     * Init Paytrail module with configured merchantId, secret and URL.
     *
     * @return Paytrail_Module_Rest module.
     */    
    protected function initPaytrail()
    {
        return new Paytrail_Module_Rest($this->config['merchantId'], $this->config['secret'], $this->config['url']);        
    }

    /**
     * Generate the internal payment transaction identifer.
     *
     * @param string $patronId Patron's Catalog Username (barcode)
     *
     * @return string Transaction identifier
     * @access protected
     */
    protected function generateTransactionId($patronId)
    {
        return $patronId . '_' . date("YmdHis");
    }
}