<?php
/**
 * Paytrail webpayment handler
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
 * @package  Webpayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */

require_once 'sys/Webpayment/Interface.php';
require_once 'services/MyResearch/lib/Transaction.php';

/**
 * Paytrail webpayment handler module.
 *
 * @category VuFind
 * @package  Webpayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */
class Paytrail implements WebpaymentInterface
{
    const ACCRUED_FINE = 'accrued_fine';
    const REFUSED_FEE  = 'refused_fee';

    const STATUS_CANCELED  = 'canceled';
    const STATUS_NOTIFY    = 'notify';
    const STATUS_PROCESSED = 'processed';

    protected $config;
    protected $paymentRegister;

    /**
     * Constructor
     *
     * @param mixed $config          Hash array containing handler's
     * configuration as key-value pairs, or filename of the file containin
     * the configuration
     * @param mixed $paymentRegister Payment Register object or null
     * if none used
     *
     * @access public
     */
    public function __construct($config, $paymentRegister)
    {
        if (is_array($config)) {
            // Load Configuration passed in
            $this->config = $config;
        } else {
            // Load Configuration from the file passed in
            $this->config = parse_ini_file('conf/'.$config);
        }
        $this->paymentRegister = $paymentRegister;
    }

    /**
     * Generate the webpayment form (payment button and hidden fields containing
     * transaction parameters).
     *
     * @param string  $patron      Patron's catalog username (e.g. barcode)
     * @param integer $amount      Payment amount (without decimal point)
     * @param array   $fees        Array of fee objects
     * @param string  $followupUrl URL the Payment service is supposed to return
     * after the payment
     * @param string  $statusParam HTTP parameter name to contain the payment status
     *
     * @return string The template to use to display the webpayment form.
     * @access public
     */
    public function displayPaymentForm($patron, $amount, $fees, $followupUrl,
        $statusParam
    ) {
        global $configArray;
        global $interface;

        $amount = sprintf("%.2f", $amount/100.00);
        // replace decimal comma with decimal point if locale enforces
        // the use of comma (Paytrail requires decimal point)
        $amount = str_replace(",", ".", $amount);
        $transactionId = $this->generateTransactionId($patron);
        $returnUrl = $followupUrl . '?' . $statusParam . '='
            . self::STATUS_PROCESSED . '&payment_id_param=ORDER_NUMBER';
        $notifyUrl = $configArray['Site']['url'] . "/MyResearch/PaytrailNotify";
        $cancelUrl = $followupUrl . '?' . $statusParam . '='
            . self::STATUS_CANCELED . '&payment_id_param=ORDER_NUMBER';
        $transactionFines = array();
        for ($i = 0; $i < count($fees); $i++) {
            $row = $fees[$i];
            if (isset($row['payableOnline']) && $row['payableOnline']) {
                $transactionFines[] = $row;
            }
        }

        $interface->assign('action_url', $this->config['service_url']);
        $interface->assign('currency', 'EUR'); //TODO: parametrize currency
        $interface->assign('interface_type', 'S1');
        $interface->assign('merchant_id', $this->config['merchant_id']);
        $interface->assign('order_no', $transactionId);
        $interface->assign('paymentAmount', $amount);
        $interface->assign('return_url', $returnUrl);
        $interface->assign('cancel_url', $cancelUrl);
        $interface->assign('notify_url', $notifyUrl);
        $interface->assign('transaction_id', $transactionId);
	$interface->assign(
            'authcode', $this->generateAuthCode(
                $amount, $transactionId, $returnUrl, $cancelUrl, $notifyUrl
            )
        );
        $interface->assign(
            'transactionFee',
            isset($this->config['transactionFee']) ?
            $this->config['transactionFee'] : ''
        );
        $interface->assign('transactionFines', $transactionFines);
        return 'MyResearch/webpayment-paytrail.tpl';
    }

    /**
     * Fetch payment data from patron's fees.
     *
     * This Adds webpayment-related information to fees as well.
     *
     * @param string $patron Patron's catalog username (e.g. barcode)
     * @param array  &$fees  Array of fees
     *
     * @return array Array containing payment data: is payment permitted, payment
     * amount, sum of payable fees, details on why payment has not been permitted.
     * @access public
     */
    public function getPaymentData($patron, &$fees)
    {
        $accruedFines = isset($this->config['accruedFines'])
            ? $this->config['accruedFines'] : array();
        $refusedFees = isset($this->config['refusedFees'])
            ? $this->config['refusedFees'] : array();

        $amount = 0;
        $payableSum = 0;
        foreach ($fees as &$fee) {
            if (in_array($fee['fine'], $accruedFines)) {
                $fee['payableOnline'] = false;
                $fee['webpaymentRemark']
                    = translate('webpayment_nonpayable_accrued_fine');
                $fine['fee_class'] = self::ACCRUED_FINE;
                continue;
            }
            if (in_array($fee['fine'], $refusedFees)) {
                $fee['payableOnline'] = false;
                $fee['webpaymentRemark']
                    = translate('webpayment_nonpayable_refused_fee');
                $fee['fee_class'] = self::REFUSED_FEE;
                continue;
            }
            $fee['payableOnline'] = true;
            $payableSum += $fee['balance'];
        }
        $notPermittedInfo = '';
        $permitted = true;
        $paymentData = array();

        if ($this->hasUnregisteredPayments($patron)) {
            $permitted = false;
            $notPermittedInfo = translate('webpayment_nonregistered_payment');
	    $paymentData['blocked'] = true;
        } else if (!$this->paymentPermitted($fees)) {
            $permitted = false;
            $notPermittedInfo
                = translate('webpayment_fines_contain_nonpayable_fee');
        }
        $transactionFee = 0;
        if ($permitted) {
            if ($payableSum > 0) {
                $minimumFee = 0;
                if (isset($this->config['minimumFee'])
                    && $this->config['minimumFee'] > 0
                ) {
                    $minimumFee = $this->config['minimumFee'] * 100;
                }
                if ($payableSum >= $minimumFee) {
                    $amount = $payableSum;
                    if (isset($this->config['transactionFee'])
                        && $this->config['transactionFee'] > 0
                    ) {
                        $transactionFee = $this->config['transactionFee'] * 100;
                        $amount += $transactionFee;
                        $paymentData['transactionFee'] = $transactionFee;
                    }
                } else {
                    $permitted = false;
                    $notPermittedInfo = translate('webpayment_minimum_fee');
                    // it is a bit of a hack but at least that way the minimum fee
                    // amount could be properly formatted on the template side
                    $paymentData['minimumFee'] = $minimumFee;
                }
            } else {
                $permitted = false;
                $notPermittedInfo = translate('webpayment_no_payable_fees');
            }
        }
        $paymentData['permitted'] = $permitted;
        $paymentData['amount'] = $amount;
        $paymentData['payableSum'] = $payableSum;
        $paymentData['paymentNotPermittedInfo'] = $notPermittedInfo;
        return $paymentData;
    }

    /**
     * Check whether patron has any unregistered payments
     *
     * @param object $patron Patron object
     *
     * @return boolean
     * @access protected
        $transaction = new Transaction();
        $transaction->user_id = $user_id;
        $transaction->complete = 0;
        $transaction->whereAdd('paid > 0');     */
    protected function hasUnregisteredPayments($patron)
    {
        include_once "services/MyResearch/lib/User.php";

        $user = new User();
        $user->cat_username = $patron['cat_username'];
        if (!$user->find()) {
            return false;
        }
        if (!$user->fetch()) {
            return false;
        }
        $user_id = $user->id;

        $transaction = new Transaction();
        $transaction->user_id = $user_id;
	$transaction->whereAdd('complete = ' . Transaction::STATUS_RETRY);
	$transaction->whereAdd('complete = ' . Transaction::STATUS_FAILED, 'OR');

	$transaction->whereAdd('paid > 0');

        return $transaction->find();
    }

    /**
     * Process the response from Paytrail payment service.
     *
     * @param string $patron   Patron's Catalog Username (barcode)
     * @param string $status   Webpayment status
     * @param array  $response Array containing response fields
     * received from the payment service
     *
     * @return string Payment status text to be displayed to patron
     * @access public
     */
    public function processResponse($patron, $status, $response)
    {
        global $interface;

        $protocol
            = (isset($_SERVER['SERVER_PROTOCOL']) ? $_SERVER['SERVER_PROTOCOL']
            : 'HTTP/1.0');
        if (!$this->verifyPaytrailResponse($status, $response)) {
            if ($status == self::STATUS_NOTIFY) {
                //send non-2xx HTTP header and quit
                header($protocol . ' 403 Forbidden');
                exit();
            }
            return 'webpayment_status_checksum_not_valid';
        }
        if (!$this->transactionNotProcessed($response)) {
            if ($status == self::STATUS_NOTIFY) {
                //send non-2xx HTTP header and quit
                header($protocol . ' 403 Forbidden');
                exit();
            }
            return 'webpayment_transaction_already_processed_or_unknown';
        }
        if ($status == self::STATUS_CANCELED) {
            $this->setTransactionStatus($response, 'paytrail_canceled');
            return 'webpayment_canceled';
        }
        if ($status == self::STATUS_PROCESSED) {
            if (isset($response['METHOD'])
                && isset($response['PAID'])
            ) {
                $this->setTransactionPaidDate($response);
                $this->setTransactionStatus($response, 'paytrail_ok');
                $feesList = $this->getPaidFees($response);
                if (is_array($feesList)) {
                    $interface->assign('webpaymentPaidFines', $feesList);
                }
                $interface->assign('ajaxRegisterPayment', 1);
                return 'webpayment_successful';
            } else {
                $this->setTransactionStatus($response, 'paytrail_error');
                return 'webpayment_failed';
            }
        }
        if ($status == self::STATUS_NOTIFY) {
            if (isset($response['METHOD']) && isset($response['PAID'])) {
                $storeError = '';
                $this->setTransactionPaidDate($response);
                $this->setTransactionStatus($response, 'paytrail_ok');
                if (!$this->storePayment($response, $storeError)) {
                    header($protocol . ' 403 Forbidden');
                    exit();
                }
                //send 200 HTTP header and quit
                header($protocol . ' 200 OK');
                exit();
            }
            //send non-2xx HTTP header and quit
            header($protocol . ' 403 Forbidden');
            exit();
        }
        $this->setTransactionStatus($response, 'paytrail_unknown');
        return 'webpayment_unknown_status';
    }

    /**
     * Generate the webpayment transaction MD5 fingerprint used for validation.
     *
     * @param string $amount        String containing the payment amount
     * @param string $transactionId Internal transaction identifier
     * @param string $returnUrl     URL Paytrail should redirect once the payment
     * is done
     * @param string $cancelUrl     URL Paytrail should redirect when user
     * cancels payment
     * @param string $notifyUrl     URL Paytrail should send response when user
     * does not return to Paytrail from the payment provider
     * (e.g. from the bank's website).
     *
     * @return string Fingerprint of the specified webpayment.
     * @access protected
     */
    protected function generateAuthCode($amount, $transactionId, $returnUrl,
        $cancelUrl, $notifyUrl
    ) {
        $checksum = implode(
            '|', array(
                $this->config['secret_key'],
                $this->config['merchant_id'],
                $amount,
            $transactionId,
                '', // reference number
                '', // TODO: order description
                'EUR',
                $returnUrl,
                $cancelUrl,
                '', // pending address (not used)
                $notifyUrl,
                'S1',
                '', // locale. defaults to fi_FI. TODO: Do we want to change this?
                '', // preselected (payment) method
                '', // mode. 2 stands for 'skip payment method selection screen'.
                    // Defaults to 1 (show payment selection)
                '', // visible methods (not used)
                ''  // group (not used)
            )
        );
        return strtoupper(md5($checksum));
    }

    /**
     * Generate the internal webpayment transaction identifer.
     *
     * @param string $patron Patron's Catalog Username (barcode)
     *
     * @return string Transaction identifier
     * @access protected
     */
    protected function generateTransactionId($patron)
    {
        return $patron . '_' . date("YmdHis");
    }

    /**
     * Get details of fees paid in the current transaction.
     *
     * @param array $response Array containing response fields
     * received from Paytrail
     *
     * @return mixed Array of fee entries on success, boolean
     * false on failure
     * @access protected
     */
    protected function getPaidFees($response)
    {
        $order_no = isset($response['ORDER_NUMBER']) ? $response['ORDER_NUMBER']
            : null;
        if (!isset($order_no)) {
            return false;
        }

        $transaction = new Transaction();
        $transaction->transaction_id = $order_no;
        if (!$transaction->find()) {
            return false;
        }
        if (!$transaction->fetch()) {
            return false;
        }

        $fees = $transaction->getFees();
        foreach ($fees as $fee) {
            $feeList[] = array(
                'title' => $fee->title,
                'type' => $fee->type,
                'amount' => $fee->amount * 100
                );
        }
        return $feeList;
    }

    /**
     * Check whether payment of the given fees is permitted.
     *
     * @param array $fees Array of fees
     *
     * @return boolean
     * @access protected
     */
    protected function paymentPermitted($fees)
    {
        foreach ($fees as $fee) {
            if (isset($fee['fee_class'])) {
                if ($fee['fee_class'] == self::ACCRUED_FINE) {
                    if (isset($this->config['accruedFineBlocksPayment'])
                        && $this->config['accruedFineBlocksPayment']
                    ) {
                        return false;
                    }
                } elseif ($fee['fee_class'] == self::REFUSED_FEE) {
                    if (isset($this->config['refusedFeeBlocksPayment'])
                        && $this->config['refusedFeeBlocksPayment']
                    ) {
                        return false;
                    } else if (!isset($this->config['refusedFeeBlocksPayment'])) {
                        // blocks by default
                        return false;
                    }
                }
            }
        }
        return true;
    }

    /**
     * Sets the payment date of the transaction related to the received response.
     *
     * @param array $response Array containing response fields
     * received from Paytrail
     *
     * @return void
     * @access protected
     */
    protected function setTransactionPaidDate($response)
    {
        $order_no = isset($response['ORDER_NUMBER']) ? $response['ORDER_NUMBER']
            : null;
        $timestamp = isset($response['TIMESTAMP']) ? $response['TIMESTAMP']
            : null;
        if (!isset($order_no) || !isset($timestamp)) {
            return;
        }

        $orig_transaction = new Transaction();
        $orig_transaction->transaction_id = $order_no;
        if (!$orig_transaction->find()) {
            return;
        }
        $orig_transaction->fetch();

        $transaction = clone($orig_transaction);
        $transaction->paid = date("Y-m-d H:i:s", $timestamp);

        $transaction->update($orig_transaction);
        return;
    }

    /**
     * Changes the status of the transaction related to the received response.
     *
     * @param array  $response Array containing response fields
     * received from Paytrail
     * @param string $status   New transaction status
     *
     * @return void
     * @access protected
     */
    protected function setTransactionStatus($response, $status)
    {
        $order_no = isset($response['ORDER_NUMBER']) ? $response['ORDER_NUMBER']
            : null;
        if (!isset($order_no)) {
            return;
        }

        $orig_transaction = new Transaction();
        $orig_transaction->transaction_id = $order_no;
        if (!$orig_transaction->find()) {
            return;
        }
        $orig_transaction->fetch();

        $transaction = clone($orig_transaction);
        $transaction->status = $status;

        $transaction->update($orig_transaction);
        return;
    }

    /**
     * Store data of the transaction related to the received response.
     *
     * @param array  $response  Array containing response fields
     * received from Paytrail
     * @param string &$errorMsg String containing store error message
     *
     * @return boolean true on success, false if store fails
     * @access public
     */
    public function storePayment($response, &$errorMsg)
    {
        $status = isset($response['payment_status']) ? $response['payment_status']
            : null;
        $order_no = isset($response['ORDER_NUMBER']) ? $response['ORDER_NUMBER']
            : null;
        $timestamp = isset($response['TIMESTAMP']) ? $response['TIMESTAMP']
            : null;

        if (!isset($status) || !isset($order_no) || !isset($timestamp)) {
            return false;
        }

        if (!$this->verifyPaytrailResponse($status, $response)) {
            if ($status == self::STATUS_NOTIFY) {
                //send non-2xx HTTP header and quit
                header($protocol . ' 403 Forbidden');
                exit();
            }
            $errorMsg = 'webpayment_status_checksum_not_valid';
            return false;
        }
        $orig_transaction = new Transaction();
        $orig_transaction->transaction_id = $order_no;
        if (!$orig_transaction->find()) {
            return false;
        }
        $orig_transaction->fetch();
        $no_error = true;
        $patron = $orig_transaction->getPatronCatUsername();
        $fees_amount = $orig_transaction->amount -
            $orig_transaction->transaction_fee;
        if (isset($this->paymentRegister)) {
            $registered = $this->paymentRegister->register($patron, $fees_amount);
            if (PEAR::isError($registered) || !$registered) {
                if (PEAR::isError($registered)) {
                    $errorMsg = $registered->getMessage();
                }
                $no_error = false;
            }
        }
        $transaction = clone($orig_transaction);
        if ($no_error) {
	  $transaction->complete = Transaction::STATUS_COMPLETE;
            $transaction->status = 'payment_register_ok';
            $transaction->registered = date("Y-m-d H:i:s");
        } else {
	  $transaction->complete = Transaction::STATUS_RETRY;
            if ($errorMsg) {
                $transaction->status = $errorMsg;
            } else {
                $transaction->status = 'payment_register_failed';
            }
        }
        if (!$transaction->update($orig_transaction)) {
            return false;
        }

        return $no_error;
    }

     /**
      * Check whether the transaction related to the received response has not been
      * processed yet.
      *
      * This is used to avoid multiple registering the same payment, etc.
      * @param array $response Array containing response fields
      *
      * @return boolean
      * @access protected
      */
    protected function transactionNotProcessed($response)
    {
        $order_no = isset($response['ORDER_NUMBER']) ? $response['ORDER_NUMBER']
            : null;
        if (!isset($order_no)) {
            return false;
        }

        $transaction = new Transaction();
        $transaction->transaction_id = $order_no;
        if (!$transaction->find()) {
            return false;
        }
        if (!$transaction->fetch()) {
            return false;
        }
        if ($transaction->complete) {
            return false;
        }
        return true;
    }

    /**
     * Verify the authenticity of the response received from Paytrail.
     *
     * @param string $status   Payment status received from Paytrail
     * @param array  $response Array containing response fields
     * received from Paytrail
     *
     * @return boolean true if the response is valid, false otherwise
     * @access protected
     */
    protected function verifyPaytrailResponse($status, $response)
    {
        $order_no = isset($response['ORDER_NUMBER']) ? $response['ORDER_NUMBER']
            : null;
        $timestamp = isset($response['TIMESTAMP']) ? $response['TIMESTAMP']
            : null;
        $paymentCode = isset($response['PAID']) ? $response['PAID'] : null;
        $method = isset($response['METHOD']) ? $response['METHOD'] : null;
        $returnAuthCode = isset($response['RETURN_AUTHCODE'])
            ? $response['RETURN_AUTHCODE'] : null;

        if (!isset($order_no) || !isset($timestamp) || !isset($returnAuthCode)) {
            return false;
        }
        if ($status == self::STATUS_CANCELED
            && (isset($paymentCode) || isset($method))
        ) {
            return false;
        }

        $checksum = $order_no . '|' . $timestamp;
        if (isset($paymentCode)) {
            $checksum .= '|' . $paymentCode;
        }
        if (isset($method)) {
            $checksum .= '|' . $method;
        }
        $checksum .= '|' . $this->config['secret_key'];
        $authCode = strtoupper(md5($checksum));
        return $authCode == $returnAuthCode;
    }
}

?>
