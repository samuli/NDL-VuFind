<?php
/**
 * Home action for List module
 *
 * PHP version 5
 *
 * Copyright (C) Samuli Sillanpää, The National Library of Finland 2014.
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
 * @package  Controller_List
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once 'services/MyResearch/lib/FavoriteHandler.php';

/**
 * Home action for shared list view.
 *
 * @category VuFind
 * @package  Controller_List
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Home extends Action
{
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

        // Fetch List object
        $list = User_list::staticGet($_GET['id']);

        if (!$list->public && $list->user_id != $user->id) {
            PEAR::raiseError(new PEAR_Error(translate('list_access_denied')));
        }

        $interface->assign('list', $list);
        $interface->assign('publicList', true);
        $interface->assign('ownList', $list->user_id == $user->id);

        $date = new VuFindDate();
        if (strtotime($list->modified)  !== false && strtotime($list->modified) > 0) {
            $interface->assign('listModified', $date->convertToDisplayDate('Y-m-d H:i:s', $list->modified));
        }

        // Load the User object for the owner of the list (if necessary):
        if ($user && $user->id == $list->user_id) {
            $listUser = $user;
        } else {
            $listUser = User::staticGet($list->user_id);
        }

        $listOwner = null;
        if ($listUser->email && ($pos = strpos($listUser->email, '@')) !== false) {
            $listOwner = substr($listUser->email, 0, $pos);                   
        } else if ($listUser->firstname && $listUser->lastname) {
            $listOwner = "$listUser->firstname $listUser->lastname";
        }
        
        if ($listOwner) {
            $interface->assign('listUsername', $listOwner);
        }

        $searchObject = SearchObjectFactory::initSearchObject();
        $searchObject->init();
        $interface->assign('viewList', $searchObject->getViewList());
        
        // Build Favorites List
        $favorites = $list->getResources(isset($_GET['tag']) ? $_GET['tag'] : null);

        // Create a handler for displaying favorites and use it to assign
        // appropriate template variables:
        $favList = new FavoriteHandler($favorites, $listUser, $list->id, false);
        $favList->initPublicListView($searchObject->getView(), $listOwner);
        $favList->assign();

        $interface->assign('recordSet', $interface->get_template_vars('resourceList'));
        $interface->assign('openUrlAutoCheck', true);

        $currentView = $searchObject->getView();
        $interface->assign('subpage', 'Search/list-' . $currentView .'.tpl');        
        $interface->setTemplate('home.tpl');

        $interface->setPageTitle($list->title);
        $interface->display('layout.tpl');
    }

}

?>