<?php
/**
 * PaytrailNotify action for MyResearch module
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
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */

require_once 'services/MyResearch/MyResearch.php';
require_once 'sys/PaymentRegister/PaymentRegisterFactory.php';
require_once 'sys/Webpayment/WebpaymentFactory.php';
require_once 'sys/Webpayment/Paytrail.php';

/**
 * PaytrailNotify action for MyResearch module.
 *
 * This is used to handle Paytrail's notify requests (see Paytrail API
 * documentation for details).
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */
class PaytrailNotify extends MyResearch
{
    /**
     * Constructor
     *
     * @return void
     * @access public
     */
    public function __construct()
    {
        parent::__construct(true); // skip login
    }

    /**
     * Process incoming notify request (if any) and send HTTP header.
     * This should not be accessed by user.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $configArray;
        global $interface;
        global $user;

        if ( isset($_REQUEST['ORDER_NUMBER']) && isset($_REQUEST['TIMESTAMP'])
            && isset($_REQUEST['PAID']) && isset($_REQUEST['METHOD'])
            && isset($_REQUEST['RETURN_AUTHCODE'])
        ) {
            $transactionId = $_REQUEST['ORDER_NUMBER'];
            $transactionPatron
                = $this->getTransactionPatronCatUsername($transactionId);
            if (isset($transactionPatron)) {
                $webpaymentConfig
                    = $this->catalog->getConfig('Webpayment', $transactionId);
                if (isset($webpaymentConfig) && isset($webpaymentConfig['enabled'])
                    && $webpaymentConfig['enabled']
                    && isset($webpaymentConfig['handler'])
                    && $webpaymentConfig['handler'] == 'Paytrail'
                ) {
                    $paymentRegisterConfig = $this->catalog->getConfig(
                        'PaymentRegister', $transactionId
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
                        if ($configArray['System']['debug']) {
                            echo "Exception: " . $e->getMessage();
                        }
                        error_log(
                            "Webpayment handler exception: " . $e->getMessage()
                        );
                        $webpaymentHandler = null;
                    }
                    $requestParams = array(
                        'payment_status' => Paytrail::STATUS_NOTIFY,
                        'ORDER_NUMBER' => $_REQUEST['ORDER_NUMBER'],
                        'TIMESTAMP' => $_REQUEST['TIMESTAMP'],
                        'PAID' => $_REQUEST['PAID'],
                        'METHOD' => $_REQUEST['METHOD'],
                        'RETURN_AUTHCODE' => $_REQUEST['RETURN_AUTHCODE']
                    );
                    if (isset($webpaymentHandler)) {
                        // this should process notify request, send HTTP header
                        // and quit. Otherwise will redirect to
                        // the default account page
                        $webpaymentHandler->processResponse(
                            $transactionPatron, Paytrail::STATUS_NOTIFY,
                            $requestParams
                        );
                    }
                }
            }
        }

        $page = isset($configArray['Site']['defaultAccountPage']) ?
            $configArray['Site']['defaultAccountPage'] : 'Profile';
        $accountStart = $configArray['Site']['url'] . "/MyResearch/". $page;
        header("Location: " . $accountStart);
    }

    /**
     * Fetch the catalog username of the patron related to the given
     * transaction.
     *
     * @param string $transactionId Transaction identifier
     *
     * @return mixed string on success, null on failure
     * @access protected
     */
    protected function getTransactionPatronCatUsername($transactionId)
    {
        include_once "services/MyResearch/lib/Transaction.php";
        include_once "services/MyResearch/lib/User.php";

        $transaction = new Transaction();
        $transaction->transaction_Id = $transactionId;
        if (!$transaction->find()) {
            return null;
        }
        if (!$transaction->fetch()) {
            return null;
        }
        $user = new User();
        $user->id = $transaction->user_id;
        if (!$user->find()) {
            return null;
        }
        if (!$user->fetch()) {
            return null;
        }
        return $user->cat_username;
    }
}

?>
