<?php
/**
 * AJAX action for Resource module
 * 
 * PHP version 5
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
 * @package  Controller_AJAX
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi> 
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'Action.php';

/**
 * Home Action for Resource
 *  
 * @category VuFind
 * @package  Controller_AJAX
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi> 
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class AJAX_PCI extends Action
{
    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    function launch()
    {
        if ($_GET['method'] == 'pci') {
            echo $this->doPCI();
        }
    }

    /**
     * Process PCI search
     * 
     * @return void
     */
    function doPCI()
    {
        global $interface;
        global $configArray;

        if (!$interface->get_template_vars('pciEnabled')) {
             PEAR::raiseError(new PEAR_Error("PCI is not enabled."));
        }
        
        // If we're loading PCI results via AJAX, we can't take advantage
        // of the counter used in the main page for ensuring uniqueness of HTML
        // elements.  To minimize the chance of a clash, let's reset the counter
        // to a very large number:
        if (isset($configArray['OpenURL']['embed'])
            && !empty($configArray['OpenURL']['embed'])
        ) {
            include_once 'sys/Counter.php';
            $interface->assign('openUrlCounter', new Counter(100000));
        }

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
        
        // Initialise SearchObject.
        $searchObject = SearchObjectFactory::initSearchObject('PCI');
        $searchObject->init();
        $searchObject->setLimit(10);

        // Search 
        $result = $searchObject->processSearch(true, true);

        // We'll need recommendations no matter how many results we found:
        $interface->assign('qtime', round($searchObject->getQuerySpeed(), 2));
        $interface->assign('spellingSuggestions', $searchObject->getSpellingSuggestions());
        $interface->assign('lookfor', $searchObject->displayQuery());

        $interface->assign('more', $searchObject->renderSearchUrl());


        if ($showGlobalFiltersNote = $interface->getGlobalFiltersNotification('Primo Central')) {
            $interface->assign('showGlobalFiltersNote', $showGlobalFiltersNote);
        }
        
        $searchWithoutLocalFilters = $searchObject->renderSearchUrl(false);        
        $searchWithoutLocalFilters = str_replace('/PCI/Search', '/Search/DualResults', $searchWithoutLocalFilters);
        $interface->assign('searchWithoutLocalFilters', $searchWithoutLocalFilters);

        if ($result['recordCount'] > 0) {
            // Display Listing of Results
            $summary = $searchObject->getResultSummary();
            $page = $summary['page'];
            $interface->assign('recordCount', $summary['resultTotal']);
            $interface->assign('recordStart', $summary['startRecord']);
            $interface->assign('recordEnd',   $summary['endRecord']);
            $interface->assign('recordSet', $result['response']['docs']);

            // If our result set is larger than the number of records that
            // PCI will let us page through, we should cut off the number
            // before passing it to our paging mechanism:
            $config = getExtraConfigArray('PCI');
            $pageLimit = isset($config['General']['result_limit']) ?
                $config['General']['result_limit'] : 2000;
            $totalPagerItems = $summary['resultTotal'] < $pageLimit ?
                $summary['resultTotal'] : $pageLimit;

        } else if ($searchObject->isEmptySearch()) {
            $interface->assign('noQuery', true);
        }


        // 'Finish' the search... complete timers and log search history.
        $searchObject->close();
        $interface->assign('time', round($searchObject->getTotalSpeed(), 2));

        return $interface->fetch('Search/list-dual-pci.tpl');
    }
}
