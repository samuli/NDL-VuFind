<?php
/**
 * Fines action for MyResearch module
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
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
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'CatalogConnection.php';
require_once 'services/MyResearch/MyResearch.php';
require_once 'services/MyResearch/lib/Transaction.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'sys/OnlinePayment/OnlinePaymentFactory.php';
require_once 'sys/OnlinePayment/Paytrail_Module_Rest.php';

/**
 * Fines action for MyResearch module
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Fines extends MyResearch
{
    /**
     * Process parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $configArray;
        global $interface;

        // Assign the ID of the last search so the user can return to it.
        if (isset($_SESSION['lastSearchURL'])) {
            $interface->assign('lastsearch', $_SESSION['lastSearchURL']);
        }

        // Get My Fines
        if ($patron = UserAccount::catalogLogin()) {
            if (PEAR::isError($patron)) {
                $this->handleCatalogError($patron);
            } else {
                $fines = $this->catalog->getMyFines($patron);
                $loans = $this->catalog->getMyTransactions($patron);
                $sum = 0;
                $fines = $this->processFines($fines, $loans, $sum);

                $this->handleOnlinePayment($patron, $fines);

                if (!PEAR::isError($fines)) {
                    $interface->assign('rawFinesData', $fines);
                    $interface->assign('sum', $sum);
                }
                
                $profile = $this->catalog->getMyProfile($patron);
                if (!PEAR::isError($profile)) {
                    $interface->assign('profile', $profile);
                }
                $driver = isset($patron['driver']) ? $patron['driver'] : '';
                $interface->assign('driver', $driver);
            }
        }

        $interface->setTemplate('fines.tpl');
        $interface->setPageTitle('My Fines');
        $interface->display('layout.tpl');
    }

    /**
     * Support for handling online payments.
     *
     * @return void
     * @access public
     */
    protected function handleOnlinePayment($patron, $fines)
    {
        global $interface;
        global $configArray;

        $config = $this->catalog->getConfig('OnlinePayment');

        if ($config && $config['enabled']) {
            $finesAmount = $this->catalog->getOnlinePayableAmount($patron);
            $transactionFee = $config['transactionFee'];
            $minimumFee = $config['minimumFee'];

            $interface->assign('transactionFee', $transactionFee);
            $interface->assign('minimumFee', $minimumFee);
            if (is_numeric($finesAmount)) {
                $interface->assign('payableSum', $finesAmount);
            }

            $paymentHandler = CatalogConnection::getOnlinePaymentHandler($patron['cat_username']); 
            $paymentPermitted = false;

            if ($paymentHandler) {
                $interface->assign('onlinePaymentEnabled', true);

                $t = new Transaction();                    
                $transactionMaxDuration 
                    = isset($config['transactionMaxDuration'])
                    ? $config['transactionMaxDuration']
                    : 30
                ;
                        
                // Check if there is a payment in progress or if the user has unregistered payments
                $paymentPermittedForUser = $t->isPaymentPermitted($patron['cat_username'], $transactionMaxDuration);
                $paymentParam = 'payment';

                $filterFun = function($fine) {
                    return $fine['payableOnline'];
                };
                $payableFines = array_filter($fines, $filterFun);

                if (isset($_REQUEST['pay']) && $_REQUEST['pay'] 
                    && is_numeric($finesAmount)
                    && isset($_SESSION['onlinePayment'])
                ) {
                    // Payment started, check that fee list has not been updated
                    if ($this->checkIfFinesUpdated($patron, $fines)) {
                        // Fines updated, redirect and show updated list.
                        $_SESSION['payment_fines_changed'] = true;
                        header("Location: {$configArray['Site']['url']}/MyResearch/Fines");
                    } else {
                        // Start payment
                        $currency = $config['currency'];
                         
                        $paymentHandler->startPayment(
                            $patron['cat_username'],
                            $finesAmount, 
                            $transactionFee,
                            $payableFines,
                            $currency,
                            $paymentParam, 
                            'transaction'
                        );
                    }
                } else if (isset($_REQUEST[$paymentParam])) {
                    // Payment response received. Display page and process via AJAX.
                    $interface->assign('registerPayment', true);
                } else {
                    $allowPayment = $finesAmount > 0 && $paymentPermittedForUser === true && is_numeric($finesAmount);

                    // Display possible warning and store fines to session.
                    $interface->assign('paymentBlocked', !$allowPayment);
                    if (count($fines) && !$allowPayment) {
                        $info = null;
                        if ($paymentPermittedForUser !== true) {
                            $info = $paymentPermittedForUser;
                        }

                        if (count($payableFines) && !is_numeric($finesAmount)) {
                            if ($finesAmount === 'online_payment_minimum_fee') {
                                $interface->assign('paymentNotPermittedMinimumFee', true);
                            }
                            $info = $finesAmount;
                        }
                        if ($info) {
                            $interface->assign('paymentNotPermittedInfo', $info);
                        }                          
                    }

                    if (isset($_SESSION['payment_fines_changed'])
                        && $_SESSION['payment_fines_changed']
                    ) {
                        $interface->assign('paymentFinesChanged', true);
                        unset($_SESSION['payment_fines_changed']);
                    }

                    if (isset($_SESSION['payment_ok'])
                        && $_SESSION['payment_ok']
                    ) {
                        unset($_SESSION['payment_ok']);
                        $interface->assign('paymentOk', true);
                    }

                    // Store current fines to session 
                    $this->storeFines($patron, $fines);

                    $interface->assign('transactionSessionId', $_SESSION['onlinePayment']['sessionId']); 
                    $interface->assign('onlinePaymentEnabled', true);                            
                    $interface->assign('onlinePaymentForm', "MyResearch/online-payment-" . $paymentHandler->getName() . '.tpl');
                }
            }
        }
    }

    /**
     * Register payment provided in the request.
     * This is called by JSON_Transaction.
     *
     * @param array   $params       Key-value list of request variables.
     * @param boolean $userLoggedIn Is user logged in at the time of method call.
     *
     * @return array array with keys 
     *   - 'success' (boolean)
     *   - 'msg' (string) error message if payment could not be processed.
     * @access public
     */
    public function processPayment($params, $userLoggedIn = true)
    {
        global $interface;
        global $user;

        $error = false;
        $msg = null;

        $transactionId = $params['transaction'];

        $tr = new Transaction();
        if (!$t = $tr->getTransaction($transactionId)) {
            error_log("Error processing payment: transaction $transactionId not found");
            $error = true;
        }

        if (!$error) {
            $patron = null;
            $patronId = $t->cat_username;

            if (!$userLoggedIn) {
                // MultiBackend::getConfig expects global user object and user->cat_username to be defined.
                $user = new User();
                $user->cat_username = $patronId;

                $account = new User_account();
                $account->user_id = $t->user_id;
                $account->cat_username = $t->cat_username;
                if ($account->find(true)) {
                    $patron = $this->catalog->patronLogin($t->cat_username, $account->cat_password);
                }
                if (!$patron) {
                    error_log("Error processing payment: could not perform patron login (transaction $transactionId)");
                    $error = true;                
                }
            } else {
                $patron = UserAccount::catalogLogin();
            }

            $config = $this->catalog->getConfig('OnlinePayment');

            if ($config && $config['enabled']) {
                $paymentHandler = CatalogConnection::getOnlinePaymentHandler($patronId);
                $res = $paymentHandler->processResponse($params);

                if (isset($res['markFeesAsPaid']) && $res['markFeesAsPaid']) {       
                    $finesAmount = $this->catalog->getOnlinePayableAmount($patron);

                    // Check that payable sum has not been updated
                    if ($finesAmount == $res['amount']) {
                        $paidRes = $this->catalog->markFeesAsPaid($patronId, $res['amount']);
                        if ($paidRes === true) {
                            $t = new Transaction();
                            if (!$t->setTransactionRegistered($res['transactionId'])) {
                                error_log("Error updating transaction $transactionId status: registered");
                            }
                            $_SESSION['payment_ok'] = true;
                        } else {
                            $t = new Transaction();
                            if (!$t->setTransactionRegistrationFailed($res['transactionId'], $paidRes)) {
                                error_log("Error updating transaction $transactionId status: registering failed");
                            }
                            $error = true;
                            $msg = translate($paidRes);
                        }           
                    } else {
                        // Payable sum updated. Skip registration and inform user that payment processing has been delayed..
                        $t = new Transaction();
                        if (!$t->setTransactionFinesUpdated($res['transactionId'])) {
                            error_log("Error updating transaction $transactionId status: payable sum updated");
                        }
                        $error = true;
                        $msg = translate('online_payment_registration_failed');
                    }
                } else {
                    $error = true;
                    $msg = translate($res);
                }
            }
        }

        $res = array('success' => !$error);
        if ($msg) {
            $res['msg'] = $msg;
        }

        return $res;
    }

    /**
     * Checks if the given list of fines is identical to the listing 
     * preserved in the session variable.
     *
     * @param object $patron Patron.
     * @param array  $fines  Listing of fines.
     *
     * @return boolean updated
     * @access public
     */
    protected function checkIfFinesUpdated($patron, $fines)
    {
        return !isset($_SESSION['onlinePayment'])
            || $_REQUEST['sessionId'] !== $this->generateFingerprint($patron)
            || $_SESSION['onlinePayment']['sessionId'] !== $this->generateFingerprint($patron)
            || $_SESSION['onlinePayment']['fines'] !== $this->generateFingerprint($fines)
        ;
    }

    /**
     * Store fines to session.
     *
     * @param object $patron Patron.
     * @param array  $fines  Listing of fines.
     *
     * @return void
     * @access public
     */
    protected function storeFines($patron, $fines)
    {
        $_SESSION['onlinePayment'] = array(
            'sessionId' => $this->generateFingerprint($patron),
            'fines' => $this->generateFingerprint($fines)
        );
    } 

    /**
     * Utility function for calculating a fingerprint for a object.
     *
     * @param object $data Object
     *
     * @return string fingerprint
     * @access public
     */
    protected function generateFingerprint($data) 
    {
        return md5(json_encode($data));
    }

    /**
     * Utility function for augmenting fines with additional information.
     *
     * @param array $fines Fines
     * @param array $loans Loans
     *
     * @return array Augmented fines.
     * @access public
     */
    protected function processFines($fines, $loans, &$sum = 0)
    {        
        for ($i = 0; $i < count($fines); $i++) {
            $row = &$fines[$i];
            $sum += $row['balance'];            
            $record = $this->db->getRecord($row['id']);
            $row['title'] = $record ? $record['title_short'] : null;
            $row['checkedOut'] = false;
            if (is_array($loans)) {
                foreach ($loans as $loan) {
                    if ($loan['id'] == $row['id']) {
                        $row['checkedOut'] = true;
                        break;
                    }
                }
            }
            $formats = array();
            foreach (isset($record['format']) 
                     ? $record['format'] 
                     : array() as $format) {
                $formats[] = preg_replace('/^\d\//', '', $format);
            }
            $row['format'] = $formats;        
        }
        return $fines;
    }
}

?>