<?php
/**
 * Base action for extended browsing.
 *
 * PHP version 5
 *
 * Copyright (C) Andrew Nagy 2009.
 * Copyright (C) Ere Maijala, The National Library of Finland 2012.
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
 * @package  Controller_MetaLib
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Silanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';



require_once 'services/MetaLib/Base.php';
require_once 'sys/Pager.php';
require_once 'services/MyResearch/Login.php';
require_once 'services/MyResearch/lib/User.php';

/**
 * Extended browse action.
 *
 * @category VuFind
 * @package  Controller_MetaLib
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Silanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class BrowseExtended extends Action
{
    /**
     * Process parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;
        global $action;

        $this->disallowBots();

        $enabledActions = array();
        
        // Check if requested action is enabled and configured
        $searchSettings = getExtraConfigArray('searches');
        if (isset($searchSettings['BrowseExtended'])) {
            foreach ($searchSettings['BrowseExtended'] as $key => $val) {
                if ((boolean)$val) {
                    $enabledActions[] = $key;
                }
            }
        }
        if (!in_array($action, $enabledActions)) {
            PEAR::raiseError("Browse action $action not enabled"); 
        }
        if (!isset($searchSettings["BrowseExtended:$action"])) {
            PEAR::raiseError("Browse action $action not configured"); 
        }


        $settings = $searchSettings["BrowseExtended:$action"];

        $searchObject = SearchObjectFactory::initSearchObject('SolrBrowseExtended');
        $searchObject->init($action);
        $result = $searchObject->processSearch(true, true);

        if (PEAR::isError($result)) {
            PEAR::raiseError($result->getMessage());
        }

        $interface->assign(
            'sideRecommendations',
            $searchObject->getRecommendationsTemplates('side')
        );

        $displayQuery = $searchObject->displayQuery();

        $interface->assign('lookfor', $displayQuery);
        $interface->assign('paginateTitle', translate("browse_extended_$action"));
        $interface->assign(
            'snippet', 
            'RecordDrivers/Index/result-browse-snippet-' . strtolower($action) . '.tpl'
        );
        $interface->assign(
            'more', 
            'RecordDrivers/Index/result-browse-more-' . strtolower($action) . '.tpl'
        );
        $interface->assign('disableBreadcrumbs', true);
        
        // If no record found
        if ($searchObject->getResultTotal() < 1) {
            $interface->setTemplate('../BrowseExtended/list-none.tpl');
        } else {
            $summary = $searchObject->getResultSummary();
            $interface->assign('recordCount', $summary['resultTotal']);
            $interface->assign('recordStart', $summary['startRecord']);
            $interface->assign('recordEnd',   $summary['endRecord']);

            $interface->assign('recordSet', $searchObject->getResultRecordHTML());

            $interface->setTemplate('../BrowseExtended/browse.tpl');

            // Process Paging
            $link = $searchObject->renderLinkPageTemplate();
            $options = array('totalItems' => $summary['resultTotal'],
                             'fileName'   => $link,
                             'perPage'    => $summary['perPage']);
            $pager = new VuFindPager($options);
            $interface->assign('pageLinks', $pager->getLinks());
        }

        $_SESSION['lastSearchURL'] = $searchObject->renderSearchUrl();

        $searchObject->close();

        $scroller = new ResultScroller();
        $scroller->init($searchObject, $result);

        // Done, display the page
        $interface->display('layout.tpl');
    }
    
}

?>
