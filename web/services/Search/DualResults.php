<?php
/**
 * Two Column Results action for Search module
 *
 * PHP Version 5
 *
 * Copyright (C) Andrew Nagy 2009
 * Copyright (C) The National Library of Finland 2013
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
 * @package  Controller_Search
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi> 
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'Action.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'services/MyResearch/lib/Search.php';
require_once 'sys/ResultScroller.php';

/**
 * Two Column Results Action for Search
 *  
 * @category VuFind
 * @package  Controller_Search
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi> 
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class DualResults extends Action
{
    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    function launch()
    {
        global $interface;
        global $configArray;

        if (!$interface->get_template_vars('dualResultsEnabled')) {
            PEAR::raiseError(new PEAR_Error("Dual result view is not enabled."));
        }
        
        // Initialise from the current search globals
        $searchObject = SearchObjectFactory::initSearchObject();
        $searchObject->init();

        // Set Interface Variables
        //   Those we can construct BEFORE the search is executed
        $interface->setPageTitle('Search Results');

        // Whether embedded openurl autocheck is enabled
        if (isset($configArray['OpenURL']['autocheck']) && $configArray['OpenURL']['autocheck']) {
            $interface->assign('openUrlAutoCheck', true);
        }
        
        // Set Proxy URL
        if (isset($configArray['EZproxy']['host'])) {
            $interface->assign('proxy', $configArray['EZproxy']['host']);
        }

        // Determine whether to display book previews
        if (isset($configArray['Content']['previews'])) {
            $interface->assignPreviews();
        }

        $interface->assign(
        	"showContext",
            isset($configArray['Content']['showHierarchyTree'])
            ? $configArray['Content']['showHierarchyTree']
            : false
        );
        
        // Process Search
        $result = $searchObject->processSearch(true, true);
        if (PEAR::isError($result)) {
            PEAR::raiseError($result->getMessage());
        }

        // Some more variables
        //   Those we can construct AFTER the search is executed, but we need
        //   no matter whether there were any results
        $interface->assign('qtime',               round($searchObject->getQuerySpeed(), 2));
        $interface->assign('spellingSuggestions', $searchObject->getSpellingSuggestions());
        $interface->assign('lookfor',             $searchObject->displayQuery());
        $interface->assign('searchType',          $searchObject->getSearchType());
        // Will assign null for an advanced search
        $interface->assign('searchIndex',         $searchObject->getSearchIndex());
        
        // Setup Display
        $interface->assign('sitepath', $configArray['Site']['path']);
        $interface->assign('more', $searchObject->renderSearchUrl());
        $interface->assign('pci_more', str_replace('/Search/Results', '/PCI/Search', $searchObject->renderSearchUrl()));
        
        if ($searchObject->getResultTotal() > 0) {
            // Assign interface variables
            $summary = $searchObject->getResultSummary();
            $interface->assign('recordCount', $summary['resultTotal']);
            $interface->assign('recordStart', $summary['startRecord']);
            
            // We can't use the provided endRecord value (see note below about
            // setting limit), so we need to calculate it manually:
            $endRecord = $summary['startRecord'] + 9;
            if ($endRecord > $summary['resultTotal']) {
                $endRecord = $summary['resultTotal'];
            }
            $interface->assign('recordEnd',   $endRecord);

            // Big one - our results; chop down to only the first ten for short
            // results, but note that we can't simply shorten the list by setting
            // the $searchObject's limit to 10, since this causes goofy behavior
            // in the ResultScroller below.
            $results = $searchObject->getResultRecordHTML();
            if (count($results) > 10) {
                $results = array_slice($results, 0, 10);
            }
            $interface->assign('recordSet', $results);
        }

        // 'Finish' the search... complete timers and log search history.
        $searchObject->close();
        $interface->assign('time', round($searchObject->getTotalSpeed(), 2));
        // Show the save/unsave code on screen
        // The ID won't exist until after the search has been put in the search history
        //    so this needs to occur after the close() on the searchObject
        $interface->assign('showSaved',   true);
        $interface->assign('savedSearch', $searchObject->isSavedSearch());
        $interface->assign('searchId',    $searchObject->getSearchId());

        // initialize the search result scroller for this search
        $scroller = new ResultScroller();
        $scroller->init($searchObject, $result);

        // Done, display the page
        $interface->setTemplate('list-dual.tpl');
        $interface->display('layout.tpl');

        // Save the URL of this search to the session so we can return to it easily:
        $_SESSION['lastSearchURL'] = $configArray['Site']['url'] . 
            '/Search/DualResults?lookfor=' . urlencode($_GET['lookfor']);
        // Save the display query too, so we can use it e.g. in the breadcrumbs
        $_SESSION['lastSearchDisplayQuery'] = $searchObject->displayQuery();
    }
}
