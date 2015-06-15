<?php
/**
 * Load a list of organizations whose library services are activate 
 * in this view.
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2012
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
 * @package  Controller_Help
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once 'services/MyResearch/Login.php';

/**
 * aboutfinna action for Content module
 *
 * @category VuFind
 * @package  Controller_Help
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class aboutfinna extends Action
{
    /**
     * Load a list of organizations whose library services are activate 
     * in this view.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;

        Login::setupLoginFormVars();
        $file = 'aboutfinna.' . $interface->getLanguage() . '.tpl';
        $interface->setPageTitle(translate("content-aboutfinna"));
        $interface->setTemplate($file);
        $interface->display('layout.tpl');
    }
}

?>
