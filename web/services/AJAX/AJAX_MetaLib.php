<?php
/**
 * AJAX action for performing a MetaLib search.
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
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'Action.php';
require_once 'sys/Pager.php';
require_once 'services/MyResearch/Login.php';
require_once 'services/MyResearch/lib/User.php';

/**
 * AJAX action for performing a MetaLib search.
 *  
 * @category VuFind
 * @package  Controller_AJAX
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class AJAX_MetaLib extends Action
{
    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    function launch()
    {        
        if ($_GET['method'] == 'metalib') {
            echo $this->doMetaLib();
        }        
    }

    /**
     * Process MetaLib search
     * 
     * @return void
     */
    function doMetaLib()
    {
        global $interface;
        global $configArray;

        // Initialise SearchObject.
        $searchObject = SearchObjectFactory::initSearchObject('MetaLib');
        $searchObject->init();
        if (isset($_GET['page'])) {            
            $searchObject->setPage($_GET['page']);
        }

        $displayQuery = $searchObject->displayQuery();
        $interface->assign('lookfor', $displayQuery);
        $interface->assign('searchType', $searchObject->getSearchType());

        // Search MetaLib
        $template = null;
        if (!empty($displayQuery)) {
            $result = $searchObject->processSearch(true, true);

            // Whether RSI is enabled
            if (isset($configArray['OpenURL']['use_rsi']) && $configArray['OpenURL']['use_rsi']) {
                $interface->assign('rsi', true);
            }
            // Whether embedded openurl autocheck is enabled
            if (isset($configArray['OpenURL']['autocheck']) && $configArray['OpenURL']['autocheck']) {
                $interface->assign('openUrlAutoCheck', true);
            }
        
            // We'll need recommendations no matter how many results we found:
            $interface->assign('qtime', round($searchObject->getQuerySpeed(), 2));
            $interface->assign(
                'spellingSuggestions', $searchObject->getSpellingSuggestions()
            );
            $interface->assign(
                'topRecommendations',
                $searchObject->getRecommendationsTemplates('top')
            );
            $interface->assign(
                'sideRecommendations',
                $searchObject->getRecommendationsTemplates('side')
            );
            $interface->assign('disallowedDatabases', $result['disallowedDatabases']);
            $interface->assign('failedDatabases', $result['failedDatabases']);
            $interface->assign('successDatabases', $result['successDatabases']);
            
            // We want to guide the user to login for access to licensed material
            $interface->assign('methodsAvailable', Login::getActiveAuthorizationMethods());
            $interface->assign('userAuthorized', UserAccount::isAuthorized());

            // Show notification if all databases were disallowed.
            if (count($result['successDatabases']) === 0 
                && count($result['failedDatabases']) === 0 
                && count($result['disallowedDatabases']) > 0
            ) {
                $interface->assign('showDisallowedNotification', true);
            }

            if ($result['recordCount'] > 0) {
                $summary = $searchObject->getResultSummary();
                $page = $summary['page'];
                $interface->assign('recordCount', $summary['resultTotal']);
                $interface->assign('recordStart', $summary['startRecord']);
                $interface->assign('recordEnd',   $summary['endRecord']);
                $interface->assign('recordSet', $result['documents']);
                $interface->assign('sortList',   $searchObject->getSortList());

                // If our result set is larger than the number of records that
                // MetaLib will let us page through (10000 records per database), 
                // we should cut off the number before passing it to our paging 
                // mechanism:
                $config = getExtraConfigArray('MetaLib');
                $pageLimit = isset($config['General']['result_limit']) ?
                    $config['General']['result_limit'] : 2000;
                $totalPagerItems = $summary['resultTotal'] < $pageLimit ?
                    $summary['resultTotal'] : $pageLimit;
                                                
                // Process Paging
                $link = $searchObject->renderLinkPageTemplate();
                $options = array('totalItems' => $totalPagerItems,
                                 'fileName'   => $link,
                                 'perPage'    => $summary['perPage']);
                $pager = new VuFindPager($options);
                $interface->assign('pageLinks', $pager->getLinks());
                $interface->assign('pagesTotal', $totalPagerItems);

                // Display Listing of Results
                $template = 'list-list.tpl';
            } else {
                $interface->assign('recordCount', 0);
                // Was the empty result set due to an error?
                $error = $searchObject->getIndexError();
                if ($error !== false) {
                    // If it's a parse error or the user specified an invalid field, we
                    // should display an appropriate message:
                    if (stristr($error, 'user.entered.query.is.malformed')
                        || stristr($error, 'unknown.field')
                    ) {
                        $interface->assign('parseError', true);
                    } else {
                        // Unexpected error -- let's treat this as a fatal condition.
                        
                        PEAR::raiseError(
                            new PEAR_Error(
                                'Unable to process query<br />MetaLib Returned: ' . $error
                            )
                        );
                    }
                }    
                $template = 'list-none.tpl';
            }
        } else {
            $result = false;
            $interface->assign('noQuery', true);
            $template = 'list-none.tpl';

        }
        // 'Finish' the search... complete timers and log search history.
        $searchObject->close();
        $interface->assign('time', round($searchObject->getTotalSpeed(), 2));
        // Show the save/unsave code on screen
        // The ID won't exist until after the search has been put in the search
        //    history so this needs to occur after the close() on the searchObject
        $interface->assign('showSaved',   true);
        $interface->assign('savedSearch', $searchObject->isSavedSearch());
        $interface->assign('searchId',    $searchObject->getSearchId());

        // Save the URL of this search to the session so we can return to it easily:
        $_SESSION['lastSearchURL'] = $searchObject->renderSearchUrl();

        return $interface->fetch("MetaLib/$template");
    }

}
