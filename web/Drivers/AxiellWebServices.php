<?php
/**
 * Axiell Web Services Driver.
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2011.
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
 * @package  ILS_Drivers
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_ils_driver Wiki
 */
require_once 'Interface.php';
require_once 'sys/VuFindDate.php';


/**
 * Axiell Web Services Driver.
 *
 * @category VuFind
 * @package  ILS_Drivers
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_ils_driver Wiki
 
 // TODO: language-dependent stuff
 
 */
class AxiellWebServices implements DriverInterface
{
    protected $arenaMember = '';
    protected $catalogue_wsdl = '';
    protected $patron_wsdl = '';
    protected $loans_wsdl = '';
    protected $payments_wsdl = '';
    protected $reservations_wsdl = '';
    protected $dateFormat;
    protected $logFile = '';
    
    protected $soapOptions = array(
        'soap_version' => SOAP_1_1,
        'exceptions' => true,
        'trace' => 1,
        'connection_timeout' => 60
    );
    
    /**
     * Constructor
     * 
     * @param string $configFile Configuration file
     *
     * @access public
     */
    public function __construct($configFile = 'AxiellWebServices.ini')
    {
        // Load Configuration for this Module
        $this->config = parse_ini_file('conf/'.$configFile, true);

        $this->arenaMember = $this->config['Catalog']['arena_member'];
        $this->catalogue_wsdl = 'conf/' . $this->config['Catalog']['catalogue_wsdl'];
        $this->patron_wsdl = 'conf/' . $this->config['Catalog']['patron_wsdl'];
        $this->loans_wsdl = 'conf/' . $this->config['Catalog']['loans_wsdl'];
        $this->payments_wsdl = 'conf/' . $this->config['Catalog']['payments_wsdl'];
        $this->reservations_wsdl = 'conf/' . $this->config['Catalog']['reservations_wsdl'];
        
        if (isset($this->config['Debug']['log'])) {
            $this->logFile = $this->config['Debug']['log'];
        }
        
        // Set up object for formatting dates and times:
        $this->dateFormat = new VuFindDate();
    }

    /**
     * Get Status
     *
     * This is responsible for retrieving the status information of a certain
     * record.
     *
     * @param string $id The record id to retrieve the holdings for
     *
     * @return mixed     On success, an associative array with the following keys:
     * id, availability (boolean), status, location, reserve, callnumber; on
     * failure, a PEAR_Error.
     * @access public
     */
    public function getStatus($id)
    {
        return $this->getHolding($id);
    }

    /**
     * Get Statuses
     *
     * This is responsible for retrieving the status information for a
     * collection of records.
     *
     * @param array $ids The array of record ids to retrieve the status for
     *
     * @return mixed     An array of getStatus() return values on success,
     * a PEAR_Error object otherwise.
     * @access public
     */
    public function getStatuses($ids)
    {
        $items = array();
        foreach ($ids as $id) {
            $items[] = $this->getHolding($id);
        }
        return $items;
    }
    
    
    /**
     * Get Holding
     *
     * This is responsible for retrieving the holding information of a certain
     * record.
     *
     * @param string $id     The record id to retrieve the holdings for
     * @param object $patron User, if logged in
     *
     * @return mixed     On success, an associative array with the following keys:
     * id, availability (boolean), status, location, reserve, callnumber, duedate,
     * number, barcode; on failure, a PEAR_Error.
     * @access public
     */    

    public function getHolding($id, $patron = false)
    {
        $localId = $id;

        $p = strpos($localId, '.');
        $year = '';
        $edition = '';

        if ($p > 0) {
            $localId = substr($localId, $p + 1);
        }
        $p = strpos($localId, '_');
        if ($p > 0) {
            $localId = substr($localId, $p + 1);
        }
        $client = new SoapClient($this->catalogue_wsdl, $this->soapOptions);
        try {
            global $interface;
            $language = $interface->getLanguage();
            if (!in_array($language, array('en', 'sv', 'fi'))) {
                $language = 'en';
            }
    
            $this->debugLog("Catalogue record detail request for '$id':");
    
            $result = $client->GetHoldings(array('GetHoldingsRequest' => array('arenaMember' => $this->arenaMember, 'id' => $localId, 'language' => $language)));
            
            if ($result->GetHoldingResult->status->type != 'ok') {
                $this->debugLog("GetHoldings request failed for '$id'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                return new PEAR_Error('catalog_error_technical');
            }
    
            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
    
            $vfHoldings = array();

            if (!isset($result->GetHoldingResult->catalogueRecord->compositeHolding)) {
                return $vfHoldings;
            }

            $holdings = is_object($result->GetHoldingResult->catalogueRecord->compositeHolding) ?
                array($result->GetHoldingResult->catalogueRecord->compositeHolding) :
                $result->GetHoldingResult->catalogueRecord->compositeHolding;
            
            $copy = 0;

            if ($holdings[0]->type == 'year') {

                foreach ($holdings as $holding) {

                    $year = $holding->value;
                    $holdingsEditions = is_object($holding->compositeHolding) ? 
                        array($holding->compositeHolding) : 
                        $holding->compositeHolding;

                    foreach ($holdingsEditions as $holdingsEdition) {
                        $edition = $holdingsEdition->value;
                        $holdingsOrganisations = is_object($holdingsEdition->compositeHolding) ? 
                            array($holdingsEdition->compositeHolding) : 
                            $holdingsEdition->compositeHolding;
                        foreach ($holdingsOrganisations as $holdingsOrganisation) {
                            $this->parseHoldings($holdingsOrganisations, $id, $copy, $vfHoldings, $year, $edition);
                        }
                    }	
                }
            } else {
                $this->parseHoldings($holdings, $id, $copy, $vfHoldings, '', '');
            }

            return empty($vfHoldings) ? false : $vfHoldings;
        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            return new PEAR_Error('catalog_error_technical');;
        }
    }
    
    /**
     * This is responsible for iterating the organisation holdings
     * 
     * @param array     $organisationHoldings Organisation holdings 
     * @param string    $id                   The record id to retrieve the holdings
     * @param reference &$copy                Counter
     * @param reference &$vfHoldings          Reference
     * @param string    $year                 Publication year of the magazine
     * @param string    $edition              Edition of the magazine
     *
     * @return null
     * @access protected
     */ 
    protected  function parseHoldings($organisationHoldings, $id, &$copy, &$vfHoldings, $year, $edition) 
    {
        foreach ($organisationHoldings as $organisation) {
            $organisationName = $organisation->value;
            $reservationStatus = ($organisation->reservationButtonStatus == 'reservationOk') ? 'Y' : 'N';
            $noOfReservations = isset($organisation->nofReservations) ? $organisation->nofReservations : '';
            $holdingsBranch = is_object($organisation->compositeHolding) ? array($organisation->compositeHolding) : $organisation->compositeHolding;

            foreach ($holdingsBranch as $branch) {

                // TODO: mfhd_id
                $vfHolding = array(   					
                        'id'                => $id,
                        'mfhd_id'           => '635670',
                        'item_id'           => $id,
                        'number'            => '',
                        'requests_placed'   => $noOfReservations,
                        'barcode'           => $id,
                        'availability'      => true,
                        'status'      		=> '',
                        'location'          => '',
                        'reserve'           => $reservationStatus,
                        'callnumber'        => '',
                        'duedate'           => '',
                        'returnDate'        => false,
                        'is_holdable'       => true,
                        'addLink'           => false,
                        'summary'           => $edition
                );
    
                $vfHolding['id'] = $id;
                $vfHolding['location'] = $organisationName;
                $vfHolding['location'] .= ', '. $branch->value . ' ' . $branch->holdings->holding->department . ' ' . $edition;
                $vfHolding['location'] .=  isset($branch->holdings->holding->location) ? ', ' . $branch->holdings->holding->location : ''; 
                $vfHolding['number'] = isset($branch->holdings->holding->nofTotal) ? $branch->holdings->holding->nofTotal : '';
                $vfHolding['callnumber'] = isset($branch->holdings->holding->shelfMark) ? $branch->holdings->holding->shelfMark : '';
                $vfHolding['status'] = isset($branch->holdings->holding->status) ? $branch->holdings->holding->status : '';

                $available = null;
                $status = $branch->status;
                switch ($branch->status) {
                case 'availableForLoan':
                    $available = true;
                    $status = 'Available';
                    break;
                case 'onLoan':
                    $available = false;
                    $status = 'Charged';
                    break;
                case 'nonAvailableForLoan':
                    if ($holding->nofReference == 0) {
                        $available = false;
                        $status = 'Not Available For Loan';
                    }
                    break;
                case 'overdueLoan':
                    $available = false;
                    break;
                case 'ordered':
                    $available = false;
                    break;
                case 'returnedToday':
                    $available = true;
                    break;
                default:
                    $this->debugLog('Unhandled status ' + $branch->status + " for $id");
                }
    
                $vfHolding['number'] = $copy++;
                $vfHolding['status'] = $status;
                $vfHolding['availability'] = $available;
                $vfHolding['reserve'] = 'N';
                $vfHolding['is_holdable'] = $reservationStatus;
                $vfHoldings[] = $vfHolding;
            } 
        }
    }

    /**
     * Get Purchase History
     *
     * This is responsible for retrieving the acquisitions history data for the
     * specific record (usually recently received issues of a serial).
     *
     * @param string $id The record id to retrieve the info for
     *
     * @return mixed     An array with the acquisitions data on success, PEAR_Error
     * on failure
     * @access public
     */
    public function getPurchaseHistory($id)
    {
        return array();
    }

    /**
     * Get New Items
     *
     * Retrieve the IDs of items recently added to the catalog.
     *
     * @param int $page    Page number of results to retrieve (counting starts at 1)
     * @param int $limit   The size of each page of results to retrieve
     * @param int $daysOld The maximum age of records to retrieve in days (max. 30)
     * @param int $fundId  optional fund ID to use for limiting results (use a value
     * returned by getFunds, or exclude for no limit); note that "fund" may be a
     * misnomer - if funds are not an appropriate way to limit your new item
     * results, you can return a different set of values from getFunds. The
     * important thing is that this parameter supports an ID returned by getFunds,
     * whatever that may mean.
     *
     * @return array       Associative array with 'count' and 'results' keys
     * @access public
     */
    public function getNewItems($page, $limit, $daysOld, $fundId = null)
    {
        return array('count' => 0, 'results' => array());
    }

    /**
     * Find Reserves
     *
     * Obtain information on course reserves.
     *
     * @param string $course ID from getCourses (empty string to match all)
     * @param string $inst   ID from getInstructors (empty string to match all)
     * @param string $dept   ID from getDepartments (empty string to match all)
     *
     * @return mixed An array of associative arrays representing reserve items
     * (or a PEAR_Error object if there is a problem)
     * @access public
     */
    public function findReserves($course, $inst, $dept)
    {
        return array();
    }

    /**
     * Get Patron Profile
     *
     * This is responsible for retrieving the profile for a specific patron.
     *
     * @param array $patron The patron array
     *
     * @return mixed        Array of the patron's profile data on success,
     * PEAR_Error otherwise.
     * @access public
     */
    public function getMyProfile($patron)
    {
        $this->debugLog("getMyProfile called");
        return $patron;
    }

    /**
     * Patron Login
     *
     * This is responsible for authenticating a patron against the catalog.
     *
     * @param string $username The patron username
     * @param string $password The patron password
     *
     * @return mixed           Associative array of patron info on successful login,
     * null on unsuccessful login, PEAR_Error on error.
     * @access public
     */
    public function patronLogin($username, $password)
    {
        $client = new SoapClient($this->patron_wsdl, $this->soapOptions);
        try {
            $patronId = $this->getPatronId($username, $password);
            if (!$patronId) {
                return new PEAR_Error('authentication_error_technical');
            }
            
            $this->debugLog("Patron login for '$username':");
            
            $result = $client->getPatronInformation(array('patronInformationParam' => array('arenaMember' => $this->arenaMember, 'language' => 'en', 'patronId' => $patronId)));
            if ($result->patronInformationResult->status->type != 'ok') {
                $this->debugLog("Patron information request failed for '$username'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                return new PEAR_Error('authentication_error_technical');;
            }

            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            
            $info = $result->patronInformationResult->patronInformation;
            
            $user = array();
            $user['id'] = $username;
            $user['cat_username'] = $username;
            $user['cat_password'] = $password;
            // TODO: do we always get full name?
            $names = explode(' ', $info->patronName);
            $user['lastname'] = array_pop($names);
            $user['firstname'] = implode(' ', $names);
            // TODO: find first active address
            $user['email'] = isset($info->emailAddresses) && isset($info->emailAddresses->emailAddress) ? $info->emailAddresses->emailAddress->address : ' ';
            if (isset($info->addresses) && isset($info->addresses->address)) {
                $user['address1'] = isset($info->addresses->address->streetAddress) ? $info->addresses->address->streetAddress : '';
                $user['zip'] = isset($info->addresses->address->zipCode) ? $info->addresses->address->zipCode : '';
                if (isset($info->addresses->address->city)) {
                    if ($user['zip']) {
                        $user['zip'] .= ' ';
                    }
                    $user['zip'] .= $info->addresses->address->city;
                }
                
                if (isset($info->addresses->address->country)) {
                    if ($user['zip']) {
                        $user['zip'] .= ', ';
                    }
                    $user['zip'] = $info->addresses->address->country;
                }
            }
            if (isset($info->phoneNumbers) && isset($info->phoneNumbers->phoneNumber)) {
                $user['phone'] = isset($info->phoneNumbers->phoneNumber->areaCode) ? $info->phoneNumbers->phoneNumber->areaCode : '';
                if (isset($info->phoneNumbers->phoneNumber->localCode)) {
                    $user['phone'] .= $info->phoneNumbers->phoneNumber->localCode;
                }
            }
            return $user;

        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            return new PEAR_Error('authentication_error_technical');;
        }
    }

    /**
     * Get Patron Transactions
     *
     * This is responsible for retrieving all transactions (i.e. checked out items)
     * by a specific patron.
     *
     * @param array $user The patron array from patronLogin
     *
     * @return mixed      Array of the patron's transactions on success,
     * PEAR_Error otherwise.
     * @access public
     */
    public function getMyTransactions($user)
    {
        $client = new SoapClient($this->loans_wsdl, $this->soapOptions);
        try {
            $patronId = $this->getPatronId($user['cat_username'], $user['cat_password']);
            if (!$patronId) {
                return new PEAR_Error('authentication_error_technical');
            }
            
            $this->debugLog("Loans request for '{$user['cat_username']}':");
            
            $result = $client->GetLoans(array('loansRequest' => array('arenaMember' => $this->arenaMember, 'patronId' => $patronId, 'language' => 'en')));
            
            if ($result->loansResponse->status->type != 'ok') {
                $this->debugLog("Loans request failed for '" . $user['cat_username'] . "'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                if (isset($result->loansResponse->loans->loan)) {
                    // Workaround for AWS problem when it cannot find a record
                    $this->debugLog('AxiellWebServices: It seems we got the loans anyway...');
                } else {
                    return new PEAR_Error('catalog_error_technical');
                }
            }
            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            
            $transList = array();
            if (!isset($result->loansResponse->loans->loan)) {
                return $transList;
            }
            $loans = is_object($result->loansResponse->loans->loan) ? array($result->loansResponse->loans->loan) : $result->loansResponse->loans->loan;
            
            foreach ($loans as $loan) {
                $trans = array();
                $trans['id'] = $loan->catalogueRecord->id;                
                $trans['title'] = $loan->catalogueRecord->title;
                $trans['duedate'] = $loan->loanDueDate;
                $trans['renewable'] = ($loan->loanStatus->isRenewable == 'yes') ? true : false;
                $trans['message'] = $loan->loanStatus->status;
                $trans['barcode'] = $loan->id;
                $trans['renew'] = $loan->remainingRenewals;
                $transList[] = $trans;
            }
            
            // Sort the Loans
            $date = array();
            foreach ($transList as $key => $row) {
                $date[$key] = $row['duedate'];
            }
            array_multisort($date, SORT_ASC, $transList);

            // Convert Axiell format to display date format
            foreach ($transList as &$row) {
                $row['duedate'] = $this->formatDate($row['duedate']);
            }

            return $transList;

        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            return new PEAR_Error('catalog_error_technical');
        }
    }

    /**
     * Renew Details
     *
     * This is responsible for getting the details required for renewing loans.
     *
     * @param string $checkoutDetails The request details
     *
     * @return string           Required details passed to renewMyItems
     *
     * @access public
     */
    public function getRenewDetails($checkoutDetails)
    {
        return $checkoutDetails['barcode'];
    }

    /**
     * Renew Items
     *
     * This is responsible for renewing items.
     *
     * @param string $renewDetails The request details
     *
     * @return array           Associative array of the results
     *
     * @access public
     */
    public function renewMyItems($renewDetails)
    {
        $client = new SoapClient($this->loans_wsdl, $this->soapOptions);
        try {
            $succeeded = 0;
            $results = array();
            foreach ($renewDetails['details'] as $id) {
                $patronId = $this->getPatronId($renewDetails['patron']['cat_username'], $renewDetails['patron']['cat_password']);
                if (!$patronId) {
                    return new PEAR_Error('authentication_error_technical');
                }
                
                $this->debugLog("Renew loan request for '{$renewDetails['patron']['cat_username']}':");
                
                $result = $client->renewLoans(array('renewLoansRequest' => array('arenaMember' => $this->arenaMember, 'patronId' => $patronId, 'language' => 'en', 'loans' => array($id))));

                if ($result->renewLoansResponse->status->type != 'ok') {
                    $this->debugLog("Renew loans request failed for '" . $renewDetails['patron']['cat_username'] . "'");
                    $this->debugLog("Request: " . $client->__getLastRequest());
                    $this->debugLog("Response: " . $client->__getLastResponse());
                    $results[$id] = array(
                        'success' => false,
                        'status' => 'Renewal failed', // TODO
                        'sys_message' => $result->renewLoansResponse->status->message
                    );
                } else {
                    $this->debugLog("Renew loans Request: " . $client->__getLastRequest());
                    $this->debugLog("Renew loans Response: " . $client->__getLastResponse());
                    $results[$details] = array(
                        'success' => true,
                        'status' => 'Loan renewed', // TODO
                        'sys_message' => '',
                        'item_id' => $details,
                        'new_date' => $this->formatDate($result->renewLoansResponse->loans->loan->loanDueDate),
                        'new_time' => ''
                    );
                }
            }
            return $results;
        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            return array(
                'block' => 'Renewal failed',
                'details' => array()
            );
        }
    }
        
    /**
     * Get Patron Fines
     *
     * This is responsible for retrieving all fines by a specific patron.
     *
     * @param array $user The patron array from patronLogin
     *
     * @return mixed      Array of the patron's fines on success, PEAR_Error
     * otherwise.
     * @access public
     */
    public function getMyFines($user)
    {
        $client = new SoapClient($this->payments_wsdl, $this->soapOptions);
        try {
            $patronId = $this->getPatronId($user['cat_username'], $user['cat_password']);
            if (!$patronId) {
                return new PEAR_Error('authentication_error_technical');
            }
            
            $this->debugLog("Debts request for '{$renewDetails['patron']['cat_username']}':");
            
            $result = $client->getDebts(array('debtsRequest' => array('arenaMember' => $this->arenaMember, 'patronId' => $patronId, 'language' => 'en', 'fromDate' => '1699-12-31', 'toDate' => time())));
            if ($result->debtsResponse->status->type != 'ok') {
                $this->debugLog("Debts request failed for '" . $user['cat_username'] . "'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                return new PEAR_Error('catalog_error_technical');
            }
            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            
            $finesList = array();
            if (!isset($result->debtsResponse->debts->debt))
                return $finesList;
            $debts = is_object($result->debtsResponse->debts->debt) ? array($result->debtsResponse->debts->debt) : $result->debtsResponse->debts->debt;
            
            foreach ($debts as $debt) {
                $fine = array();
                $fine['amount'] = str_replace(',', '.', $debt->debtAmountFormatted) * 100;
                $fine['checkout'] = '';
                $fine['fine'] = $debt->debtType . ' - ' . $debt->debtNote;
                $fine['balance'] = str_replace(',', '.', $debt->debtAmountFormatted) * 100;
                // Convert Axiell format to display date format
                $fine['createdate'] = $this->formatDate($debt->debtDate);
                $fine['duedate'] = $this->formatDate($debt->debtDate); 
                $fine['id'] = ''; 
                $finesList[] = $fine;
            }
            return $finesList;
           

        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            return new PEAR_Error('catalog_error_technical');
        }
    }

    /**
     * Get Patron Holds
     *
     * This is responsible for retrieving all holds by a specific patron.
     *
     * @param array $user The patron array from patronLogin
     *
     * @return mixed      Array of the patron's holds on success, PEAR_Error
     * otherwise.
     * @access public
     */
    public function getMyHolds($user)
    {
        $client = new SoapClient($this->reservations_wsdl, $this->soapOptions);
        try {
            $patronId = $this->getPatronId($user['cat_username'], $user['cat_password']);
            if (!$patronId) {
                return new PEAR_Error('authentication_error_technical');
            }
            
            $this->debugLog("Holds request for '{$user['cat_username']}':");
            
            $result = $client->getReservations(array('getReservationsParam' => array('arenaMember' => $this->arenaMember, 'patronId' => $patronId, 'language' => 'en')));
            if ($result->getReservationsResult->status->type != 'ok') {
                $this->debugLog("Reservations request failed for '" . $user['cat_username'] . "'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                return new PEAR_Error('catalog_error_technical');
            }

            $this->debugLog("Reservations Request: " . $client->__getLastRequest());
            $this->debugLog("Reservations Response: " . $client->__getLastResponse());
                        
            $holdsList = array();
            if (!isset($result->getReservationsResult->reservations->reservation))
                return $holdsList;
            $reservations = is_object($result->getReservationsResult->reservations->reservation) ? array($result->getReservationsResult->reservations->reservation) : $result->getReservationsResult->reservations->reservation;

            foreach ($reservations as $reservation) {
                $hold = array();
                $hold['type'] = $reservation->reservationStatus; // TODO
                $hold['id'] = $reservation->catalogueRecord->id;
                $hold['location'] = $reservation->organisation;
                if ($reservation->pickUpBranch) {
                    if ($reservation->organisation)
                        $hold['location'] .= ', ';  
                    $hold['location'] .= $reservation->pickUpBranch;
                }
                $hold['reqnum'] = $reservation->id;
                $expireDate = $reservation->reservationStatus == 'fetchable' ? $reservation->pickUpExpireDate : $reservation->validToDate;
                $hold['expire'] = $this->formatDate($expireDate);
                $hold['create'] = $this->formatDate($reservation->validFromDate);
                $hold['position'] = isset($reservation->queueNo) ? $reservation->queueNo : '-';
                $hold['available'] = $reservation->reservationStatus == 'fetchable';
                $hold['item_id'] = '';
                $hold['volume'] = isset($reservation->catalogueRecord->volume) ? $reservation->catalogueRecord->volume : '';
                $hold['publication_year'] = isset($reservation->catalogueRecord->publicationYear) ? $reservation->catalogueRecord->publicationYear : '';
                $hold['title'] = isset($reservation->catalogueRecord->titles) ? $reservation->catalogueRecord->titles : '';
                $holdsList[] = $hold;
            }
            return $holdsList;

        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            $this->debugLog("Reservations Request: " . $client->__getLastRequest());
            $this->debugLog("Reservations Response: " . $client->__getLastResponse());
            return new PEAR_Error('catalog_error_technical');
        }
    }

    /**
     * Get Pickup Locations
     *
     * This is responsible for retrieving pickup locations.
     *
     * @param array $user The patron array from patronLogin
     *
     * @return mixed      Array of the patron's fines on success, PEAR_Error
     * otherwise.
     * @access public
     */
    public function getPickUpLocations($user)
    {
        $client = new SoapClient($this->reservations_wsdl, $this->soapOptions);
        try {
            $patronId = $this->getPatronId($user['cat_username'], $user['cat_password']);
            if (!$patronId) {
                return new PEAR_Error('authentication_error_technical');
            }
            
            $this->debugLog("Holds request for '{$user['cat_username']}':");
            
            $result = $client->getReservationBranches(array('reservationBranchesRequest' => array('arenaMember' => $this->arenaMember, 'patronId' => $patronId, 'language' => 'en', 'country' => 'FI', 'reservationEntities' => '', 'reservationType' => 'normal')));
            if ($result->reservationBranchesResponse->status->type != 'ok') {
                $this->debugLog("Reservation branches request failed for '" . $user['cat_username'] . "'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                return new PEAR_Error('catalog_error_technical');
            }

            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
                        
            $locationsList = array();
            if (!isset($result->reservationBranchesResponse->organisations->organisation))
                return $locationsList;
            $organisations = is_object($result->reservationBranchesResponse->organisations->organisation) ? array($result->reservationBranchesResponse->organisations->organisation) : $result->reservationBranchesResponse->organisations->organisation;
            
            foreach ($organisations as $organisation) {
                if (!isset($organisation->branches->branch))
                    continue;
                // TODO: Make it configurable whether organisation names should be included in the location name
                $branches = is_object($organisation->branches->branch) ? array($organisation->branches->branch) : $organisation->branches->branch;
                if (is_object($organisation->branches->branch)) {
                    $locationsList[] = array(
                        'locationID' => $organisation->branches->branch->id,
                        'locationDisplay' => $organisation->branches->branch->name
                    );
                }
                else foreach ($organisation->branches->branch as $branch) {
                    $locationsList[] = array(
                        'locationID' => $branch->id,
                        'locationDisplay' => $branch->name
                    );
                }
            }
            return $locationsList;

        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            return new PEAR_Error('catalog_error_technical');
        }
    }
    
    /**
     * Get Default Pick Up Location
     *
     * Returns the default pick up location set in VoyagerRestful.ini
     *
     * @param array $patron      Patron information returned by the patronLogin
     * method.
     * @param array $holdDetails Optional array, only passed in when getting a list
     * in the context of placing a hold; contains most of the same values passed to
     * placeHold, minus the patron data.  May be used to limit the pickup options
     * or may be ignored.
     *
     * @return string       The default pickup location for the patron.
     */
    public function getDefaultPickUpLocation($patron = false, $holdDetails = null)
    {
        return ''; // TODO: can we get this somewhere?
    }
    
    /**
     * Place Hold
     *
     * This is responsible for both placing holds as well as placing recalls.
     *
     * @param string $holdDetails The request details
     *
     * @return mixed           True if successful, false if unsuccessful, PEAR_Error
     * on error
     * @access public
     */
    public function placeHold($holdDetails)
    {
        global $configArray;
        $client = new SoapClient($this->reservations_wsdl, $this->soapOptions);
        try {
            $patronId = $this->getPatronId($holdDetails['patron']['cat_username'], $holdDetails['patron']['cat_password']);
            if (!$patronId) {
                return new PEAR_Error('authentication_error_technical');
            }
            
            $this->debugLog("Add reservation request for '" . $holdDetails['patron']['cat_username'] . "':");
                        
            $expirationDate = $this->dateFormat->convertToDisplayDate('U', $holdDetails['requiredBy'])->getTimeStamp();
            $id = $holdDetails['id'];
            if (strncmp($id, $this->arenaMember . '.', strlen($this->arenaMember) + 1) == 0)
                $id = substr($id, strlen($this->arenaMember) + 1);
            $branch = $holdDetails['pickUpLocation'];
            $organisation = substr($branch, 0, -3);
            $result = $client->addReservation(array('addReservationRequest' => array('arenaMember' => $this->arenaMember, 'patronId' => $patronId, 'language' => 'en', 'reservationEntities' => $id, 'reservationSource' => 'holdings', 'reservationType' => 'normal', 'organisation' => $organisation, 'pickUpBranch' => $branch, 'validFromDate' => time(), 'validToDate' => $expirationDate )));
                          
            if ($result->addReservationResponse->status->type != 'ok') {
                $this->debugLog("Add reservation request failed for '" . $holdDetails['patron']['cat_username'] . "'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                return array(
                    'success' => false,
                    'sysMessage' => $result->addReservationResponse->status->message
                );
            }

            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            
            return array(
                'success' => true
            );
        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            return new PEAR_Error('catalog_error_technical');
        }
    }

    /**
     * Cancel Holds
     *
     * This is responsible for canceling holds.
     *
     * @param string $cancelDetails The request details
     *
     * @return array           Associative array of the results
     *
     * @access public
     */
    public function cancelHolds($cancelDetails)
    {
        $client = new SoapClient($this->reservations_wsdl, $this->soapOptions);
        try {
            $patronId = $this->getPatronId($cancelDetails['patron']['cat_username'], $cancelDetails['patron']['cat_password']);
            if (!$patronId) {
                return new PEAR_Error('authentication_error_technical');
            }
            $succeeded = 0;
            $results = array();
            foreach ($cancelDetails['details'] as $details) {
                $result = $client->removeReservation(array('removeReservationRequest' => array('arenaMember' => $this->arenaMember, 'patronId' => $patronId, 'language' => 'en', 'id' => $details)));

                if ($result->removeReservationResponse->status->type != 'ok') {
                    $this->debugLog("Remove reservation request failed for '" . $cancelDetails['patron']['cat_username'] . "'");
                    $this->debugLog("Request: " . $client->__getLastRequest());
                    $this->debugLog("Response: " . $client->__getLastResponse());
                    $results[] = array(
                        'success' => false,
                        'status' => 'Failed to cancel hold', // TODO
                        'sysMessage' => $result->removeReservationResponse->status->message
                    );
                } else {
                    $this->debugLog("Cancel hold Request: " . $client->__getLastRequest());
                    $this->debugLog("Cancel hold Response: " . $client->__getLastResponse());
                    $results[$details] = array(
                        'success' => true,
                        'status' => 'Hold canceled', // TODO
                        'sysMessage' => ''
                    );
                    ++$succeeded;
                }
            }
            $results['count'] = $succeeded;
            return $results;
        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            return new PEAR_Error('catalog_error_technical');
        }
    }

    /**
     * Cancel Hold Details
     *
     * This is responsible for getting the details required for canceling holds.
     *
     * @param string $holdDetails The request details
     *
     * @return string           Required details passed to cancelHold
     *
     * @access public
     */
    public function getCancelHoldDetails($holdDetails)
    {
        return $holdDetails['reqnum'];
    }
        
    /**
     * Get configuration 
     * 
     * @param string $function Function
     * 
     * @return array Configuration
     */
    public function getConfig($function)
    {
        $this->debugLog("getConfig $function");
        switch ($function) {
        case 'Holds':
            return array(
                'function' => 'placeHold',
                'HMACKeys' => 'id',
                'extraHoldFields' => 'requiredByDate:pickUpLocation',
                'defaultRequiredDate' => '1:0:0'
            );
        case 'cancelHolds':
            return array(
                'function' => 'cancelHolds',
                'HMACKeys' => 'id'
            );
        case 'Renewals':
            return array();
        default:
            $this->debugLog("unhandled getConfig function: '$function'");
        }
        return array();
    }

    /**
     * Get patron id from user name and password
     * 
     * @param string $username User name
     * @param string $password Password
     * 
     * @return string|null ID
     */
    protected function getPatronId($username, $password)
    {
        $client = new SoapClient($this->patron_wsdl, $this->soapOptions);
        try {
            $this->debugLog("Get patron id: Authenticate patron request for '$username':");
            
            $result = $client->authenticatePatron(array('authenticatePatronParam' => array('arenaMember' => $this->arenaMember, 'language' => 'en', 'user' => $username, 'password' => $password)));
            
            if ($result->authenticatePatronResult->status->type != 'ok') {
                $this->debugLog("Authenticate patron request failed for '$username'");
                $this->debugLog("Request: " . $client->__getLastRequest());
                $this->debugLog("Response: " . $client->__getLastResponse());
                return null;
            }
            $this->debugLog("Request: " . $client->__getLastRequest());
            $this->debugLog("Response: " . $client->__getLastResponse());
            

            return $result->authenticatePatronResult->patronId;
        
        } catch (Exception $e) {
            $this->debugLog($e->getMessage());
            return null;
        }
    }

    /**
     * Format date 
     * 
     * @param string $dateString Date as a string
     * 
     * @return string Formatted date
     */
    protected function formatDate($dateString)
    {
        // remove timezone from Axiell obscure dateformat
        $date =  substr($dateString, 0, strpos("$dateString*", "+"));
        if (PEAR::isError($date)) {
            return $dateString;
        }
        return $this->dateFormat->convertToDisplayDate("Y-m-d", $date);
    }
    
    /**
     * Write to debug log, if defined
     * 
     * @param string $msg Message to write
     * 
     * @return void
     */
    protected function debugLog($msg)
    {
        if (!$this->logFile) {
            return;
        }
        $msg = date('Y-m-d H:i:s') . ' [' . getmypid() . "] $msg\n";        
        file_put_contents($this->logFile, $msg, FILE_APPEND);
    }
}

