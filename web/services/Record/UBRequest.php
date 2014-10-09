<?php
/**
 * UB Request action for Record module
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
 * Copyright (C) The National Library of Finland 2013.
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
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'Record.php';
require_once 'Crypt/generateHMAC.php';
require_once 'services/MyResearch/Login.php';

/**
 * UB Request action for Record module
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class UBRequest extends Record
{
    protected $gatheredDetails;
    protected $logonURL;

    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $configArray;
        global $interface;
        global $user;

        // Are UB Requests Allowed?
        $this->checkUBRequests = $this->catalog->checkFunction("UBRequests", $this->recordDriver->getUniqueID());
        if ($this->checkUBRequests != false) {

            // Do we have valid information?
            // Sets $this->logonURL and $this->gatheredDetails
            $validate = $this->_validateUBRequestData($this->checkUBRequests['HMACKeys']);
            if (!$validate) {
                if (isset($_REQUEST['lightbox'])) {
                    $interface->assign('lightbox', true);
                    $interface->assign('results', array('status' => 'ub_request_error_blocked'));
                    $interface->display('Record/ub-request-submit.tpl');
                } else {
                    header(
                        'Location: ../../Record/' .
                        urlencode($this->recordDriver->getUniqueID())
                    );
                }
                return false;
            }

            // Assign FollowUp Details required for login and catalog login
            $interface->assign('followup', true);
            $interface->assign('recordId', $this->recordDriver->getUniqueID());
            $interface->assign('followupModule', 'Record');
            $interface->assign('followupAction', 'UBRequest'.$this->logonURL);

            // User Must be logged In to Place Holds
            if (UserAccount::isLoggedIn()) {
                if ($patron = UserAccount::catalogLogin()) {
                    // Block invalid requests:
                    $result = !PEAR::isError($patron)
                        && $this->catalog->checkUBRequestIsValid(
                            $this->recordDriver->getUniqueID(),
                            $this->gatheredDetails, $patron
                        );
                    if (!$result) {
                        $errorMsg = PEAR::isError($patron) ? $patron->getMessage() : 'ub_request_error_blocked';
                        if (isset($_REQUEST['lightbox'])) {
                            $interface->assign('lightbox', true);
                            $interface->assign('results', array('status' => $errorMsg));
                            $interface->display('Record/ub-request-submit.tpl');
                        } else {
                            header(
                                'Location: ../../Record/' .
                                urlencode($this->recordDriver->getUniqueID()) .
                                "?errorMsg=$errorMsg#top"
                            );
                        }
                        return false;
                    }

                    $interface->assign('items', $result['items']);
                    $interface->assign('libraries', $result['libraries']);
                    $interface->assign('locations', $result['locations']);
                    $interface->assign('requiredBy', $result['requiredBy']);

                    $interface->assign('formURL', $this->logonURL);

                    $interface->assign('gatheredDetails', $this->gatheredDetails);

                    $extraFields = isset($this->checkUBRequests['extraFields'])
                        ? explode(":", $this->checkUBRequests['extraFields'])
                            : array();
                    $interface->assign('extraFields', $extraFields);

                    $language = $interface->getLanguage();
                    if (isset($this->checkUBRequests['helpText'][$language])) {
                        $interface->assign('helpText', $this->checkUBRequests['helpText'][$language]);
                    } elseif (isset($this->checkUBRequests['helpText'])) {
                        $interface->assign('helpText', $this->checkUBRequests['helpText']);
                    }

                    if (isset($_POST['placeRequest'])) {
                        if ($this->_placeRequest($patron)) {
                            // If we made it this far, we're ready to place the request;
                            // if successful, we will redirect and can stop here.
                            return;
                        }
                    }
                }
                $interface->setPageTitle(
                    translate('ub_request_place_text') . ': ' .
                    $this->recordDriver->getBreadcrumb()
                );
                // Display Form
                if (isset($_REQUEST['lightbox'])) {
                    $interface->assign('lightbox', true);
                    $interface->display('Record/ub-request-submit.tpl');
                } else {
                    $interface->assign('subTemplate', 'ub-request-submit.tpl');

                    // Main Details
                    $interface->setTemplate('view.tpl');
                    // Display Page
                    $interface->display('layout.tpl');
                }
            } else {
                // User is not logged in
                // Display Login Form
                Login::setupLoginFormVars();
                if (isset($_REQUEST['lightbox'])) {
                    $interface->assign('title', $_GET['message']);
                    $interface->assign('message', 'You must be logged in first');
                    $interface->assign('followup', true);
                    $interface->assign('followupModule', 'Record');
                    $interface->assign('followupAction', 'UBRequest');
                    $interface->display('AJAX/login.tpl');
                } else {
                    $interface->setTemplate('../MyResearch/login.tpl');
                    // Display Page
                    $interface->display('layout.tpl');
                }
            }

        } else {
            // Shouldn't Be Here
            if (isset($_REQUEST['lightbox'])) {
                $interface->assign('lightbox', true);
                $interface->assign('results', array('status' => 'ub_request_error_blocked'));
                $interface->display('Record/ub-request-submit.tpl');
            } else {
                header(
                    'Location: ../../Record/' .
                    urlencode($this->recordDriver->getUniqueID())
                );
            }
            return false;
        }
    }

    /**
     * Send an error response to the view.
     *
     * @param array $results Place request response containing an error.
     *
     * @return void
     * @access protected
     */
    protected function assignError($results)
    {
        global $interface;

        $interface->assign('results', $results);

        // Fail: Display Form for Try Again
        // Get as much data back as possible
        $interface->assign('subTemplate', 'ub-request-submit.tpl');
    }

    /**
     * Private method for validating request data
     *
     * @param array $linkData An array of keys to check
     *
     * @return boolean True on success
     * @access private
     */
    private function _validateUBRequestData($linkData)
    {
        foreach ($linkData as $details) {
            $keyValueArray[$details] = $_GET[$details];
        }
        $hashKey = generateHMAC($linkData, $keyValueArray);

        if ($_REQUEST['hashKey'] != $hashKey) {
            return false;
        } else {
            // Initialize gatheredDetails with any POST values we find; this will
            // allow us to repopulate the hold form with user-entered values if there
            // is an error.  However, it is important that we load the POST data
            // FIRST and then override it with GET values in order to ensure that
            // the user doesn't bypass the hashkey verification by manipulating POST
            // values.
            $this->gatheredDetails = isset($_POST['gatheredDetails'])
                ? $_POST['gatheredDetails'] : array();

            // Make sure the bib ID is included, even if it's not loaded as part of
            // the validation loop below.
            $this->gatheredDetails['id'] = $_GET['id'];

            // Get Values Passed from holdings.php
            $i=0;
            foreach ($linkData as $details) {
                $this->gatheredDetails[$details] = $_GET[$details];
                // Build Logon URL
                if ($i == 0) {
                    $this->logonURL = "?".$details."=".urlencode($_GET[$details]);
                } else {
                    $this->logonURL .= "&".$details."=".urlencode($_GET[$details]);
                }
                $i++;
            }
            $this->logonURL .= ($i == 0 ? '?' : '&') .
                "hashKey=".urlencode($hashKey);
        }
        return true;
    }

    /**
     * Private method for making the request
     *
     * @param array $patron An array of patron information
     *
     * @return boolean true on success, false on failure
     * @access private
     */
    private function _placeRequest($patron)
    {
        // Add Patron Data to Submitted Data
        $details = $this->gatheredDetails + array('patron' => $patron);

        // Attempt to place the hold:
        $results = $this->catalog->placeUBRequest($details);
        if (PEAR::isError($results)) {
            PEAR::raiseError($results);
        }
        // Success: Go to Display Holds
        if ($results['success'] == true) {
            if ($_REQUEST['lightbox']) {
                echo 'OK - ' . '<h5 class="success">' . translate('ub_request_success') . '</h5>';
            } else {
                header('Location: ../../MyResearch/Holds?ub_request_success=true');
            }
            return true;
        } else {
            $this->assignError($results);
        }
        return false;
    }
}
