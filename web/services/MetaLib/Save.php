<?php
/**
 * Save action (user list management) for MetaLib module
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
 * Copyright (C) The National Library of Finland 2012.
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
require_once 'Action.php';

require_once 'services/MyResearch/lib/Resource.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'services/MyResearch/lib/User_list.php';
require_once 'services/MyResearch/Login.php';

/**
 * Save action (user list management) for MetaLib module
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Save extends Action
{
    private $_user;

    /**
     * Constructor
     *
     * @access public
     */
    public function __construct()
    {
        $this->_user = UserAccount::isLoggedIn();
    }

    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;
        
        // Check if the request is an ajax request
        $isAjax = false;
        if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) 
            AND strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest'
        ) {
            $isAjax = true;
        }

        // Check if user is logged in
        if (!$this->_user) {
            // Needed for "back to record" link in view-alt.tpl:
            $interface->assign('id', $_GET['id']);
            // Needed for login followup:
            $interface->assign('recordId', $_GET['id']);
            if (isset($_GET['lightbox'])) {
                $interface->assign('title', $_GET['message']);
                $interface->assign('message', 'You must be logged in first');
                $interface->assign('followup', true);
                $interface->assign('followupModule', 'MetaLib');
                $interface->assign('followupAction', 'Save');
                Login::setupLoginFormVars();
                return $interface->fetch('AJAX/login.tpl');
            } else {
                $interface->assign('followup', true);
                $interface->assign('followupModule', 'MetaLib');
                $interface->assign('followupAction', 'Save');
                $interface->setPageTitle('You must be logged in first');
                Login::setupLoginFormVars();
                $interface->assign('subTemplate', '../MyResearch/login.tpl');
                $interface->setTemplate('view-alt.tpl');
                $interface->display('layout.tpl', 'RecordSave' . $_GET['id']);
            }
            exit();
        }

        if (isset($configArray['Site']['quickAddToFavorites']) && $configArray['Site']['quickAddToFavorites'] && $isAjax) {
            $this->saveRecord($this->_user);
            exit();
        }
        
        if (isset($_GET['submit'])) {
            $this->saveRecord($this->_user);
            header(
                'Location: ' . $configArray['Site']['url'] . '/MetaLib/Record?id=' .
                urlencode($_GET['id'])
            );
            exit();
        }

        // Setup Search Engine Connection
        $db = ConnectionManager::connectToIndex('MetaLib');

        // Get Record Information
        $record = $db->getRecord($_GET['id']);
        $interface->assign('record', $record);
        
        // Find out if the item is already part of any lists; save list info/IDs
        $saved = $this->_user->getSavedData($_GET['id']);
        $containingLists = array();
        $containingListIds = array();
        foreach ($saved as $current) {
            $containingLists[] = array('id' => $current->list_id,
                'title' => $current->list_title);
            $containingListIds[] = $current->list_id;
        }
        $interface->assign('containingLists', $containingLists);

        // Create a list of all the lists that do NOT already contain the item:
        $lists = $this->_user->getLists();
        $nonContainingLists = array();
        foreach ($lists as $current) {
            if (!in_array($current->id, $containingListIds)) {
                $nonContainingLists[] = array('id' => $current->id,
                    'title' => $current->title);
            }
        }
        $interface->assign('nonContainingLists', $nonContainingLists);

        // Display Page
        $interface->assign('id', $_GET['id']);
        $interface->assign('lastListUsed', User_list::getLastUsed());
        if (isset($_GET['lightbox'])) {
            $interface->assign('title', $_GET['message']);
            return $interface->fetch('MetaLib/save.tpl');
        } else {
            $interface->setPageTitle('Add to favorites');
            $interface->assign('subTemplate', 'save.tpl');
            $interface->setTemplate('view-alt.tpl');
            $interface->display('layout.tpl', 'RecordSave' . $_GET['id']);
        }
    }

    /**
     * Save the record specified by GET parameters.
     *
     * @param object $user User who is saving the record.
     *
     * @return bool        True on success, false on failure.
     * @access public
     */
    public static function saveRecord($user)
    {
        // Fail if the user is not logged in:
        if (!$user) {
            return false;
        }

        $list = new User_list();
        if (isset($_GET['list']) && $_GET['list'] != '') {
            $list->id = $_GET['list'];
        } else if (isset($_POST['list']) && ($_POST['list'] != '')) {
            $list->id = $_POST['list'];
        } else {
            $list->user_id = $user->id;
            $list->title = "My Favorites";
            if (!$list->find(true)) {
                $list->insert();
            }
        }

        // Remember that the list was used so it can be the default in future
        // dialog boxes:
        $list->rememberLastUsed();

        // Setup Search Engine Connection
        $db = ConnectionManager::connectToIndex('MetaLib');
        
        // Get Record Information
        $record = $db->getRecord($_GET['id']);
        if (!$record) {
            return false;
        }
        
        $resource = new Resource();
        $resource->record_id = $_GET['id'];
        $resource->source = 'MetaLib';
        if (!$resource->find(true)) {
            $resource->data = serialize($record);
            $resource->insert();
        } else {
            $resource->data = serialize($record);
            $resource->update();
        }

        preg_match_all('/"[^"]*"|[^ ]+/', isset($_GET['mytags']) ? $_GET['mytags'] : '', $tagArray);
        return $user->addResource(
            $resource, $list, $tagArray[0], isset($_GET['notes']) ? $_GET['notes'] : ''
        );
    }
}
