<?php
/**
 * JSON handler for MyResearch Ajax requests
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
 * @package  Controller_Record
 * @author   Erik Henriksson <erik.henriksson@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'JSON.php';

// TODO: This should probably be a recommendation subclass, but those are geared
// towards search results, so we'll keep this separate for now

/**
 * JSON MyResearch action
 * 
 * @category VuFind
 * @package  Controller_Record
 * @author   Erik Henriksson <erik.henriksson@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_MyResearch extends JSON
{
    /**
     * Get data and output in JSON
     *
     * @return void
     * @access public
     */
    public function saveListData()
    {
        global $user;

        if (!($user = UserAccount::isLoggedIn())) {
            $this->output("", JSON::STATUS_NEED_AUTH);
            return;
        }

        // Fetch List object
        $list = User_list::staticGet($_REQUEST['listId']);

        // Ensure user has permissions to edit the list
        if ($list->user_id != $user->id) {
            $this->output("", JSON::STATUS_NEED_AUTH);
            return;
        }
        
        // Save data and return status to AJAX script

        // Title
        if (isset($_REQUEST['title_change'])) {
            if (!$list->updateListTitle($_REQUEST['title_change'])) {
                $error = true;
            } 
        // List Description
        } else if (isset($_REQUEST['description_change'])) {
            if (!$list->updateListDescription($_REQUEST['description_change'])) {
                $error = true;
            } 

        // Visibility
        } else if (isset($_REQUEST['publicity_change'])) {
            if (!$list->updateListPublicity($_REQUEST['publicity_change'])) {
                $error = true;
            }

        // Add list
        } else if (isset($_REQUEST['list_add'])) {
            $value = $_REQUEST['list_add'];
            $list = new User_list();
            $list->title = $value;
            $list->user_id = $user->id;
            if ($list->insert() && $list->find()) {
                $this->output("{$list->id}", JSON::STATUS_OK);
                return;
            } else {
                $error = true;
            }

        // Entry description
        } else if (isset($_REQUEST['entry_description_change'])) {
            $resource = new Resource();
            unset($resource->source);
            $resource->record_id = $_REQUEST['recordId'];
            $resource->find(true);

            // Save resource
            if (!$user->addResource(
                $resource, $list, '', $_REQUEST['entry_description_change']
            )) {
                $error = true;
            }
        }

        if ($error) {
            $this->output("An error has occurred", JSON::STATUS_ERROR);
        } else {
            $this->output("", JSON::STATUS_OK);
        }
    }
}

