<?php
/**
 * JSON handler for UB requests 
 *
 * PHP version 5
 *
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
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'JSON.php';

// TODO: This should probably be a recommendation subclass, but those are geared
// towards search results, so we'll keep this separate for now

/**
 * JSON Call Slips action
 * 
 * @category VuFind
 * @package  Controller_Record
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_UBRequest extends JSON
{
    /**
     * Check whether the request is valid
     *
     * @return void
     * @access public
     */
    public function checkRequestIsValid()
    {
        if (isset($_REQUEST['id']) && isset($_REQUEST['data'])) {
            // check if user is logged in
            $user = UserAccount::isLoggedIn();
            if (!$user) {
                return $this->output(
                    array(
                        'options' => false,
                        'msg' => translate('You must be logged in first')
                    ), JSON::STATUS_NEED_AUTH
                );
            }

            $catalog = ConnectionManager::connectToCatalog();
            if ($catalog && $catalog->status) {
                if ($patron = UserAccount::catalogLogin()) {
                    if (!PEAR::isError($patron)) {
                        $results = $catalog->checkUBRequestIsValid(
                            $_REQUEST['id'], $_REQUEST['data'], $patron
                        );

                        if (!PEAR::isError($results)) {
                            $msg = $results
                                ? translate('ub_request_place_text')
                                : translate('ub_request_error_blocked');
                            return $this->output(
                                array(
                                    'options' => $results, 'msg' => $msg
                               ), JSON::STATUS_OK
                            );
                        }
                    }
                }
            }
        }
        return $this->output(translate('An error has occurred'), JSON::STATUS_ERROR);
    }

    /**
     * Get a list of pickup locations for the given library
     *
     * @return void
     * @access public
     */
    public function getPickUpLocations()
    {
        if (isset($_REQUEST['id']) && isset($_REQUEST['pickupLib'])) {
            // check if user is logged in
            $user = UserAccount::isLoggedIn();
            if (!$user) {
                return $this->output(
                    array(
                        'msg' => translate('You must be logged in first')
                    ), JSON::STATUS_NEED_AUTH
                );
            }

            $catalog = ConnectionManager::connectToCatalog();
            if ($catalog && $catalog->status) {
                if ($patron = UserAccount::catalogLogin()) {
                    if (!PEAR::isError($patron)) {
                        $results = $catalog->getUBPickupLocations(
                            array(
                                'id' => $_REQUEST['id'],
                                'patron' => $patron,
                                'pickupLibrary' => $_REQUEST['pickupLib']
                            )
                        );

                        if (!PEAR::isError($results)) {
                            foreach ($results as &$result) {
                                $result['name'] = translate(array('prefix' => 'location_', 'text' => $result['name']));
                            }
                        
                            return $this->output(
                                array(
                                    'locations' => $results
                               ), JSON::STATUS_OK
                            );
                        }
                    }
                }
            }
        }
        return $this->output(translate('An error has occurred'), JSON::STATUS_ERROR);
    }
}

