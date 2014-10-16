<?php
/**
 * JSON handler for webpayment transactions
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
 * @package  Controller_MyResearch
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'services/MyResearch/Fines.php';
require_once 'services/MyResearch/lib/Transaction.php';
require_once 'JSON.php';

/**
 * JSON webpayment transaction handler
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_Transaction extends JSON
{
    /**
     * Create transaction entry into database.
     *
     * @return void
     * @access public
     */
    public function startTransaction()
    {
        global $user;
        global $configArray;

        if (!isset($_SESSION['webpayment'])) {
            $this->output('Transaction parameters missing', JSON::STATUS_ERROR);	  
        }

        $required = array(
            'fines', 'amount', 'transactionFee', 'currency', 'transactionId'
        );
        foreach ($required as $field) {
            if (!isset($_SESSION['webpayment'][$field])) {
                $this->output(
                    "Transaction parameter '$field' missing", 
                    JSON::STATUS_ERROR
                );
            }
        }
        
        $fines = $_SESSION['webpayment']['fines']; 

        foreach ($fines as $fine) {
            if (!isset($fine['title']) || !$fine['title']
                || !isset($fine['type']) || !$fine['type']
                || !isset($fine['amount']) || !$fine['amount']
                || !isset($fine['currency']) || !$fine['currency']
            ) {
                $this->output(
                    translate('json_transaction_fee_parameters_missing'),
                    JSON::STATUS_ERROR
                );
            }
        }

        $amount = $_SESSION['webpayment']['amount']; 
        $transactionFee = $_SESSION['webpayment']['transactionFee']; 
        $transactionId = $_SESSION['webpayment']['transactionId']; 
        $currency = $_SESSION['webpayment']['currency']; 


        // Retrieve current list of fines, and make sure that fine count and 
        // total amount to be payed matches the information that was shown to the user.
        $finesChanged = false;
        if ($patron = UserAccount::catalogLogin()) {
            $catalog = ConnectionManager::connectToCatalog();


            $action = new Fines();
            if (!$res = $action->getPaymentHandlerAndData($patron, $catalog)) {
                $this->output(
                    translate('json_transaction_fee_parameters_missing'),
                    JSON::STATUS_ERROR
                );
            }                 
            $webpaymentHandler = $res['handler'];
            $webpaymentData = $res['data'];
            $currentFines = $res['fines'];
            
            // All fines still payable?
            if ((isset($webpaymentData['permitted']) && !$webpaymentData['permitted'])
                || (isset($webpaymentData['blocked']) && $webpaymentData['blocked'])
            ) {
                $finesChanged = true;
            }
            
            // Amount of fines same?
            if (!$finesChanged && count($fines) != count($currentFines)) {
                $finesChanged = true;
            }
            
            // Total amount to be payed same?
            if (!$finesChanged) {
                $currentFinesAmount = $transactionFee;
                foreach ($currentFines as $f) {
                    if (isset($f['payableOnline']) && $f['payableOnline']) {
                        $currentFinesAmount += $f['amount']/100;
                    }
                }

                if ((float)$amount != (float)$currentFinesAmount) {
                    $finesChanged = true;
                }
            }
            
            // Finally, compare fines by selected fields
            if (!$finesChanged) {
                $fields = array('amount', 'createdate', 'fine');

                $cnt = 0;
                while ($cnt < count($fines)) {
                    $f = $fines[$cnt];
                    $f2 = $currentFines[$cnt];
                    $cnt++;

                    foreach ($fields as $field) {
                        if (!isset($f[$field]) 
                            || !isset($f2[$field])
                            || $f[$field] !== $f2[$field]
                        ) {
                            $finesChanged = true;
                            break;
                        }                    
                    }
                }
            }

            if ($finesChanged) {
                // Fines changed: redirect and display error.
                unset($_SESSION['no_store']);
                $_SESSION['payment_fines_changed'] = true;
                $finesPage = $configArray['Site']['url'] . "/MyResearch/Fines";
                $this->output(
                    array('redirect' => $finesPage),
                    JSON::STATUS_ERROR
                );
            }


            // replace decimal point with comma in order to comply
            // with number formatter's locale
            $amount = str_replace(".", ",", $amount);
            // replace decimal point with comma in order to comply
            // with number formatter's locale
            $transactionFee = str_replace(".", ",", $transactionFee);
            $fmt = numfmt_create(
                'fi_FI', NumberFormatter::DECIMAL // TODO: customize locale
            );
            
            $transaction = new Transaction();
            $transaction->transaction_id = $transactionId;
            $transaction->driver = reset(explode('.', $transactionId, 2)); 
            $transaction->user_id = isset($user) && is_object($user) ? $user->id : null;
            $transaction->amount = $fmt->parse($amount);
            $transaction->transaction_fee = $fmt->parse($transactionFee);
            $transaction->currency = $currency;
            $transaction->created = date("Y-m-d H:i:s");
            $transaction->complete = 0;
            $transaction->status = 'started';
            if (!$transaction->amount) {
                $this->output(
                    translate('json_transaction_amount_not_defined'), JSON::STATUS_ERROR
                );
            }


            if ($transaction->insert()) {
                foreach ($fines as $fine) {
                    // replace decimal point with comma in order to comply
                    // with number formatter's locale
                    $fine['amount'] = $fine['amount']/100;
                    $fine['amount'] = str_replace(".", ",", $fine['amount']);
                    $fine['amount'] = $fmt->parse($fine['amount']);
                    if (!$transaction->addFee($fine, $user)) {
                        $this->output(
                            translate('json_transaction_fee_insert_failed'),
                            JSON::STATUS_ERROR
                        );
                    }
                }
                $this->output('', JSON::STATUS_OK);
            } else {
                $this->output(
                    translate('json_transaction_insert_failed'), JSON::STATUS_ERROR
                );
            }
        }
    }

    /**
     * Register payment provided in the request.
     *
     * @return void
     * @access public
     */
    public function registerPayment()
    {
        include_once 'sys/PaymentRegister/PaymentRegisterFactory.php';
        include_once 'sys/Webpayment/WebpaymentFactory.php';

        if (!isset($_REQUEST['params']) || !is_array($_REQUEST['params'])
            || !isset($_REQUEST['payment_id_param'])
            || !$_REQUEST['payment_id_param']
        ) {
            $this->output(
                translate('json_transaction_payment_parameters_missing'),
                JSON::STATUS_ERROR
            );
        }
        $responseParams = $_REQUEST['params'];
        $paymentIdParam = $_REQUEST['payment_id_param'];
        if (!isset($responseParams[$paymentIdParam])
            || !$responseParams[$paymentIdParam]
        ) {
            $this->output(
                translate('json_transaction_payment_id_undefind'), JSON::STATUS_ERROR
            );
        }
        $paymentId = $responseParams[$paymentIdParam];
        $webpaymenyHandler = null;
        $catalog = ConnectionManager::connectToCatalog();
        if ($catalog && $catalog->status) {
            $webpaymentConfig = $catalog->getConfig('Webpayment', $paymentId);
            if (isset($webpaymentConfig) && isset($webpaymentConfig['enabled'])
                && $webpaymentConfig['enabled']
                && isset($webpaymentConfig['handler'])
            ) {
                $paymentRegisterConfig = $catalog->getConfig(
                    'PaymentRegister', $paymentId
                );
                try {
                    $paymentRegister = null;
                    if (isset($paymentRegisterConfig)
                        && isset($paymentRegisterConfig['handler'])
                    ) {
                        $paymentRegister
                            = PaymentRegisterFactory::initPaymentRegister(
                                $paymentRegisterConfig['handler'],
                                $paymentRegisterConfig
                            );
                    }
                    $webpaymentHandler
                        = WebpaymentFactory::initWebpayment(
                            $webpaymentConfig['handler'], $webpaymentConfig,
                            $paymentRegister
                        );
                } catch (Exception $e) {
                    $this->output(
                        "Webpayment handler exception: " . $e->getMessage(),
                        JSON::STATUS_ERROR
                    );
                }
                $registerError = '';
                if ($webpaymentHandler->storePayment(
                    $responseParams, $registerError
                )) {
                    $this->output('', JSON::STATUS_OK);
                } else {
                    $msg = '<p>' . translate($registerError) . '</p>';
                    $msg .= '<p>' . translate('webpayment_payment_blocked') . '</p>';
                    $this->output($msg, JSON::STATUS_ERROR);
                }
            }
        } else {
            $this->output('An error has occured', JSON::STATUS_ERROR);
        }
        $this->output(
            translate('json_transaction_no_webpayment_handler'), JSON::STATUS_ERROR
        );
    }

}

?>
