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
require_once 'services/MyResearch/MyResearch.php';
require_once 'services/MyResearch/lib/Transaction.php';
require_once 'sys/PaymentRegister/PaymentRegisterFactory.php';
require_once 'sys/Webpayment/WebpaymentFactory.php';
require_once 'sys/Webpayment/Paytrail_Module_Rest.php';

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
    // 
    const PAYMENT_PARAM = 'payment';

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
        global $finesIndexEngine;

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
                $config = $this->catalog->getConfig('Webpayment');                

                if ($config && $this->catalog->isWebpaymentEnabled($patron)) {
                    $finesAmount = $this->catalog->driver->getWebpaymentPayableAmount($patron);
                    $interface->assign('payableSum', $finesAmount);

                    $config = $this->catalog->getConfig('Webpayment');                

                    $transactionFee = $config['transactionFee'];
                    $minimumFee = $config['minimumFee'];

                    $interface->assign('transactionFee', $transactionFee);
                    $interface->assign('minimumFee', $minimumFee);

                    $paymentHandler = $this->catalog->getWebpaymentHandler($patron);
                    $paymentPermitted = false;

                    if ($paymentHandler) {
                        $t = new Transaction();                    
                        $transactionMaxDuration = 
                            isset($config['transactionMaxDuration'])
                            ? $config['transactionMaxDuration']
                            : 30
                        ;
                        
                        // Check if there is a payment in progress or if the user has unregistered payments
                        $paymentPermittedForUser = $t->isPaymentPermitted($patron, $transactionMaxDuration);

                        // Check if payment of current fees is allowed
                        $finesPayable = $this->catalog->permitWebpayment($patron);

                        if (isset($_REQUEST['pay']) && $_REQUEST['pay'] 
                            && $finesPayable === true
                            && isset($_SESSION['webpayment'])
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
                                    $patron, 
                                    $finesAmount, 
                                    $transactionFee, 
                                    $currency, 
                                    self::PAYMENT_PARAM,
                                    $configArray['Site']['locale']
                                );
                            }
                        } else if (isset($_REQUEST[self::PAYMENT_PARAM])) {                        
                            // Payment response received. Display page and process via AJAX.
                            $interface->assign('registerPayment', true);
                        } else {
                            $allowPayment = ($paymentPermittedForUser === true) && ($finesPayable === true);

                            // Display possible warning and store fines to session.
                            $interface->assign('paymentBlocked', !$allowPayment);
                            if (count($fines) && !$allowPayment) {
                                $info = array();
                                if ($paymentPermittedForUser !== true) {
                                    $info = translate($paymentPermittedForUser);
                                }

                                if ($finesPayable !== true) {
                                    if ($finesPayable === 'webpayment_minimum_fee') {
                                        $interface->assign('paymentNotPermittedMinimumFee', true);
                                    }
                                    $info = translate($finesPayable);
                                }
                                $interface->assign('paymentNotPermittedInfo', $info);                                
                            }

                            if (isset($_SESSION['payment_fines_changed'])
                                && (boolean)$_SESSION['payment_fines_changed']
                            ) {
                                $interface->assign('paymentFinesChanged', true);
                                unset($_SESSION['payment_fines_changed']);
                            }
                            
                            // Store current fines to session 
                            $this->storeFines($patron, $fines);

                            $interface->assign('transactionSessionId', $_SESSION['webpayment']['sessionId']); 
                            $interface->assign('webpaymentEnabled', true);                            
                            $interface->assign('webpaymentForm', "MyResearch/webpayment-" . $paymentHandler->getName() . '.tpl');
                        }
                    }
                }

                $loans = $this->catalog->getMyTransactions($patron);

                if (!PEAR::isError($fines)) {
                    $sum = 0;
                    $fines = $this->processFines($fines, $loans, $sum);
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
     * Register payment provided in the request.
     * This is called by JSON_Transaction.
     *
     * @param string $request Request with parameters.
     *
     * @return void
     * @access public
     */
    public function processPayment($request)
    {
        global $interface;

        $parts = parse_url($request);

        $params = array();
        foreach (($parts = explode('&', $parts['query'])) as $param) {
            list($key, $val) = explode('=', $param);
            $params[$key] = $val;            
        }


        $error = false;
        $msg = null;
        
        if ($patron = UserAccount::catalogLogin()) {
            if (PEAR::isError($patron)) {
                $error = true;
                $this->handleCatalogError($patron);
            } else {
                if ($this->catalog->isWebpaymentEnabled($patron)) {
                    $paymentHandler = $this->catalog->getWebpaymentHandler($patron);
                    $res = $paymentHandler->processResponse(
                        $patron['cat_username'], 
                        $params
                    );
                    if (isset($res['markFeesAsPaid']) && $res['markFeesAsPaid']) {                    
                        $loans = $this->catalog->getMyTransactions($patron);                        
                        $fines = $this->catalog->getMyFines($patron);                            
                        $fines = $this->processFines($fines, $loans);
                        $paidFines = array();
                        foreach ($fines as $fine) {
                            if (isset($fine['payableOnline']) && $fine['payableOnline']) {
                                $paidFines[] = $fine;
                            }
                        }
                        
                        $interface->assign('fines', $fines);

                        $paidRes = $this->catalog->markFeesAsPaid($patron, $res['amount']);
                        if ($paidRes === true) {
                            $t = new Transaction();
                            
                            if (!$t->setTransactionRegistered($res['transactionId'])) {
                                error_log("error updating transaction");
                            }

                            $interface->assign('paidFines', $paidFines);
                            $msg = '<p>' . translate('webpayment_successful') . '</p>';
                            $msg .= $interface->fetch('MyResearch/webpayment-fines-paid.tpl');
                        } else {
                            $t = new Transaction();
                            if (!$t->setTransactionRegistrationFailed($res['transactionId'], $paidRes)) {
                                error_log("error updating transaction");
                            }

                            $error = true;
                            $msg = '<ul>';
                            $msg .= translate($paidRes);
                            $msg .= '<li>' . translate('webpayment_registration_failed') . '</li>';
                            $msg .= '</ul>';
                        }
                    } else {
                        $error = true;
                        $msg = translate($res);
                    }
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
        return !isset($_SESSION['webpayment'])
            || $_REQUEST['sessionId'] !== $this->generateFingerprint($patron)
            || $_SESSION['webpayment']['sessionId'] !== $this->generateFingerprint($patron)
            || $_SESSION['webpayment']['fines'] !== $this->generateFingerprint($fines)
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
        $_SESSION['webpayment'] = array('sessionId' => $this->generateFingerprint($patron),
                                        'fines' => $this->generateFingerprint($fines));
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
            $sum += $row['balance']/100.0;
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