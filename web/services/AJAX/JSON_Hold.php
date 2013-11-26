<?php
/**
 * JSON handler for hold requests 
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
 * JSON hold action
 * 
 * @category VuFind
 * @package  Controller_Record
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_Hold extends JSON
{
    /**
     * Get a list of pickup locations for the given request group
     *
     * @return void
     * @access public
     */
    public function getPickUpLocations()
    {
        if (isset($_REQUEST['id'])) {
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
                        $results = $catalog->getPickupLocations(
                            $patron,
                            array(
                                'id' => $_REQUEST['id'],
                                'requestGroupId' => isset($_REQUEST['requestGroupId']) ? $_REQUEST['requestGroupId'] : null
                            )
                        );

                        if (!PEAR::isError($results)) {
                            foreach ($results as &$result) {
                                $result['locationDisplay'] = translate(array('prefix' => 'location_', 'text' => $result['locationDisplay']));
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

