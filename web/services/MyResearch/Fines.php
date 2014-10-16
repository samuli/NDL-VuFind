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
require_once 'sys/PaymentRegister/PaymentRegisterFactory.php';
require_once 'sys/Webpayment/WebpaymentFactory.php';

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
                
                if ($res = $this->getPaymentHandlerAndData($patron, $this->catalog)) {
                    $webpaymentHandler = $res['handler'];
                    $webpaymentData = $res['data'];
                    $fines = $res['fines'];

                    $interface->assign('webpaymentEnabled', true);

                    if (isset($_SESSION['payment_fines_changed'])
                        && (boolean)$_SESSION['payment_fines_changed']
                        ) {
                        $interface->assign('paymentFinesChanged', true);
                        unset($_SESSION['payment_fines_changed']);
                    } else if (isset($_REQUEST['payment_status'])
                               && $webpaymentHandler
                           ) {
                        $responseMsg = $webpaymentHandler->processResponse(
                                                                           $patron['cat_username'], $_REQUEST['payment_status'],
                                                                           $_REQUEST
                                                                           );
                        if ($responseMsg) {
                            $interface->assign('webpaymentStatusMsg', $responseMsg);
                        }
                    }

                }
                
                




                $loans = $this->catalog->getMyTransactions($patron);
                if (!PEAR::isError($fines)) {
                    if ($webpaymentData) {
                        
                        if (isset($webpaymentData['permitted'])
                            && $webpaymentData['permitted']
                        ) {
                            $followupUrl
                                = $configArray['Site']['url'] . '/MyResearch/Fines';
                            $statusParam = 'payment_status';
                            $webpaymentAmount = $webpaymentData['amount'];
                            $interface->assign(
                                'webpaymentForm', $webpaymentHandler->displayPaymentForm(
                                    $patron['cat_username'], $webpaymentAmount,
                                    $fines, $followupUrl, $statusParam
                                )
                            );
                        }
                        if (isset($webpaymentData['blocked'])) {
                            $interface->assign('paymentBlocked', true);
                        }
                        $interface->assign('webpaymentData', $webpaymentData);
                    }
                    // assign the "raw" fines data to the template
                    // NOTE: could use foreach($fines as &$row) here but it only works
                    // with PHP5
                    $sum = 0;
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

                    $sessionData = array();
                    $sessionData['amount'] 
                        = $interface->get_template_vars('paymentAmount');
                    $sessionData['transactionFee'] 
                        = $interface->get_template_vars('transactionFee');
                    $sessionData['currency']
                        = $interface->get_template_vars('currency');
                    $sessionData['transactionId'] 
                        = $interface->get_template_vars('transaction_id');
                    
                    $sessionData['fines'] = $fines;


                    for ($i = 0; $i < count($sessionData['fines']); $i++) {
                        $row = &$sessionData['fines'][$i];
                        $row['currency'] = $sessionData['currency'];
                        $row['type'] = $row['fine'];
                        if (!$row['title'] || $row['title'] === '') {
                            $row['title'] = translate('not_applicable');
                            $row['id'] = null;
                        }
                        
                    }
                    
                    $_SESSION['webpayment'] = $sessionData;
                    
                    $interface->assign('rawFinesData', $sessionData['fines']);
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


    public function getPaymentHandlerAndData($patron, $catalog)
    {
        $webpaymentHandler = null;
        $webpaymentConfig = $catalog->getConfig('Webpayment');
        if (!isset($webpaymentConfig) || !isset($webpaymentConfig['enabled'])
            || !$webpaymentConfig['enabled']
            ) {
            return false;
        }
        
        $paymentRegisterConfig = $catalog->getConfig('PaymentRegister');
        if (isset($webpaymentConfig['handler'])) {
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
                $webpaymentHandler = WebpaymentFactory::initWebpayment(
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
                return false;
            }
        }
        
        

        $fines = $catalog->getMyFines($patron);
        if (!PEAR::isError($fines)) {
            return array(
                      'handler' => $webpaymentHandler, 
                      'data' => $webpaymentHandler->getPaymentData($patron, $fines),
                      'fines' => $fines
                   );
        }

        return false;
    } 

}

?>