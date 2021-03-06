<?php
/**
 * Holdings action for Record module
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
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Record.php';

/**
 * Holdings action for Record module
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Holdings extends Record
{
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

        // Don't let bots crawl holdings
        $this->disallowBots();

        if (!$this->hasHoldings
            && !(isset($configArray['Site']['ajaxRecordTabs']) && $configArray['Site']['ajaxRecordTabs'])
        ) {
            $url = $configArray['Site']['url'] . "/Record/" . $_REQUEST['id'] . "/Description";
            header('Location: '. $url);
        }

        // Do not cache holdings page
        $interface->caching = 0;

        // See if patron is logged in to pass details onto get holdings for
        // holds / recalls
        $patron = UserAccount::isLoggedIn() ? UserAccount::catalogLogin() : false;
        if (PEAR::isError($patron)) {
            $patron = false;
        }

        $interface->setPageTitle(
            $this->recordDriver->getBreadcrumb()
        );
        // Only fetch holdings if we actually need them (not needed for the basic page part of holdings when using ajax record tabs)
        if (!isset($configArray['Site']['ajaxRecordTabs']) || !$configArray['Site']['ajaxRecordTabs'] || isset($_REQUEST['subPage'])) {
            $interface->assign(
                'holdingsMetadata', $this->recordDriver->getHoldings($patron)
            );
        }
        $interface->assign('subTemplate', 'view-holdings.tpl');
        $interface->setTemplate('view.tpl');

        // Set Messages
        $interface->assign('infoMsg', $this->infoMsg);
        $interface->assign('errorMsg', $this->errorMsg);

        // Display Page
        $interface->display('layout.tpl');
    }
}

?>
