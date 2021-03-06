<?php
/**
 * Advanced search action for Search module
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
 * @package  Controller_Search
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';

/**
 * Advanced search action for Search module
 *
 * @category VuFind
 * @package  Controller_Search
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Advanced extends Action
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
        global $user;

        // Create our search object
        $searchObject = SearchObjectFactory::initSearchObject();
        $searchObject->initAdvancedFacets();
        // We don't want this search in the search history
        $searchObject->disableLogging();
        // Go get the facets
        $searchObject->processSearch();
        $facetList = $searchObject->getFacetList();
        // OR filters from advanced search
        $orFilters = $searchObject->getOrFilters();
        //Assign page limit options & last limit from session
        $interface->assign('limitList',  $searchObject->getLimitList());
        // Shutdown the search object
        $searchObject->close();

        // Load a saved search, if any:
        $savedSearch = $this->_loadSavedSearch();

        // Process the facets for appropriate display on the Advanced Search screen:
        $facets = $this->_processFacets($facetList, $savedSearch);
        $interface->assign('facetList', $facets);
        // OR filters from advanced search
        $interface->assign('orFilters', $orFilters);
        
        // Integer for % width of each column (be careful to avoid divide by zero!)
        $columnWidth = (count($facets) > 1) ? round(100 / count($facets), 0) : 0;
        $interface->assign('columnWidth', $columnWidth);

        // Process settings to control special-purpose facets not supported by the
        //     more generic configuration options.
        $specialFacets
            = $searchObject->getFacetSetting('Advanced_Settings', 'special_facets');
        if (stristr($specialFacets, 'illustrated')) {
            $interface->assign(
                'illustratedLimit', $this->_getIllustrationSettings($savedSearch)
            );
        }
        if (stristr($specialFacets, 'daterange')) {
            $interface->assign(
                'dateRangeLimit', $this->_getDateRangeSettings($savedSearch)
            );
            $interface->assign(
                'spatialDateRangeLimit', $this->getSpatialDateRangeSettings($savedSearch)
            );
        }

        // Send search type settings to the template
        $interface->assign('advSearchTypes', $searchObject->getAdvancedTypes());

        // If we found a saved search, let's assign some details to the interface:
        if ($savedSearch) {
            $interface->assign('searchDetails', $savedSearch->getSearchTerms());
            $interface->assign('searchFilters', $savedSearch->getFilterList());
        }

        $interface->setPageTitle('Advanced Search');
        $interface->setTemplate('advanced.tpl');
        $interface->display('layout.tpl');
    }

    /**
     * Get the current settings for the spatial date range facet, if it is set:
     *
     * @param object $savedSearch Saved search object (false if none)
     *
     * @return array              Date range: Key 0 = from, Key 1 = to.
     * @access protected
     */
    protected function getSpatialDateRangeSettings($savedSearch = false)
    {
        // Default to blank strings:
        $from = $to = '';

        // Check to see if there is an existing range in the search object:
        if ($savedSearch) {
            $filters = $savedSearch->getFilters();
            if (isset($filters['search_sdaterange_mv'])) {
                foreach ($filters['search_sdaterange_mv'] as $current) {
                    if ($range = VuFindSolrUtils::parseSpatialDateRange($current)) {
                        $from = $range['from'] == '*' ? '' : $range['from'];
                        $to = $range['to'] == '*' ? '' : $range['to'];
                        $savedSearch->removeFilter('search_sdaterange_mv:' . $current);
                        break;
                    }
                }
            }
        }

        // Send back the settings:
        if ($from === '' || $to === '') {
            return array('', '');
        }
        $startDate = new DateTime("@$from");
        $endDate = new DateTime("@$to");
        if ($startDate->format('m') == 1 && $startDate->format('d') == 1 
            && $endDate->format('m') == 12 && $endDate->format('d') == 31
        ) {
            return array(ltrim($startDate->format('Y'), '0'), ltrim($endDate->format('Y'), '0'));
        }
        return array($startDate->format('Y-m-d'), $endDate->format('Y-m-d'));
    }

    /**
     * Get the possible legal values for the illustration limit radio buttons.
     *
     * @param object $savedSearch Saved search object (false if none)
     *
     * @return array              Legal options, with selected value flagged.
     * @access private
     */
    private function _getIllustrationSettings($savedSearch = false)
    {
        $illYes= array(
            'text' => 'Has Illustrations', 'value' => 1, 'selected' => false
        );
        $illNo = array(
            'text' => 'Not Illustrated', 'value' => 0, 'selected' => false
        );
        $illAny = array(
            'text' => 'No Preference', 'value' => -1, 'selected' => false
        );

        // Find the selected value by analyzing facets -- if we find match, remove
        // the offending facet to avoid inappropriate items appearing in the
        // "applied filters" sidebar!
        if ($savedSearch && $savedSearch->hasFilter('illustrated:Illustrated')) {
            $illYes['selected'] = true;
            $savedSearch->removeFilter('illustrated:Illustrated');
        } else if ($savedSearch
            && $savedSearch->hasFilter('illustrated:"Not Illustrated"')
        ) {
            $illNo['selected'] = true;
            $savedSearch->removeFilter('illustrated:"Not Illustrated"');
        } else {
            $illAny['selected'] = true;
        }
        return array($illYes, $illNo, $illAny);
    }

    /**
     * Get the current settings for the date range facet, if it is set:
     *
     * @param object $savedSearch Saved search object (false if none)
     *
     * @return array              Date range: Key 0 = from, Key 1 = to.
     * @access private
     */
    private function _getDateRangeSettings($savedSearch = false)
    {
        // Default to blank strings:
        $from = $to = '';

        // Check to see if there is an existing range in the search object:
        if ($savedSearch) {
            $filters = $savedSearch->getFilters();
            if (isset($filters['main_date_str'])) {
                foreach ($filters['main_date_str'] as $current) {
                    if ($range = VuFindSolrUtils::parseRange($current)) {
                        $from = $range['from'] == '*' ? '' : $range['from'];
                        $to = $range['to'] == '*' ? '' : $range['to'];
                        $savedSearch->removeFilter('main_date_str:' . $current);
                        break;
                    }
                }
            }
        }

        // Send back the settings:
        return array($from, $to);
    }

    /**
     * Load a saved search, if appropriate and legal; assign an error to the
     * interface if necessary.
     *
     * @return mixed Search Object on successful load, false otherwise
     * @access private
     */
    private function _loadSavedSearch()
    {
        global $interface;

        // Are we editing an existing search?
        if (isset($_REQUEST['edit'])) {
            // Go find it
            $search = new SearchEntry();
            $search->id = $_REQUEST['edit'];
            if ($search->find(true)) {
                // Check permissions
                if ($search->session_id == session_id()
                    || $search->user_id == $user->id
                ) {
                    // Retrieve the search details
                    $minSO = unserialize($search->search_object);
                    $savedSearch = SearchObjectFactory::deminify($minSO);
                    // Make sure it's an advanced search
                    if ($savedSearch->getSearchType() == 'advanced') {
                        // Activate facets so we get appropriate descriptions
                        // in the filter list:
                        $savedSearch->activateAllFacets('Advanced');
                        return $savedSearch;
                    } else {
                        $interface->assign('editErr', 'notAdvanced');
                    }
                } else {
                    // No permissions
                    $interface->assign('editErr', 'noRights');
                }
            } else {
                // Not found
                $interface->assign('editErr', 'notFound');
            }
        }

        return false;
    }

    /**
     * Process the facets to be used as limits on the Advanced Search screen.
     *
     * @param array  $facetList    The advanced facet values
     * @param object $searchObject Saved search object (false if none)
     *
     * @return array               Sorted facets, with selected values flagged.
     * @access private
     */
    private function _processFacets($facetList, $searchObject = false)
    {
        // Process the facets, assuming they came back
        $facetConfig = getExtraConfigArray('facets');
        $facets = array();
        foreach ($facetList as $facet => $list) {
            $currentList = array();
            foreach ($list['list'] as $value) {
                // Build the filter string for the URL:
                $fullFilter = $facet.':"'.$value['untranslated'].'"';

                // If we haven't already found a selected facet and the current
                // facet has been applied to the search, we should store it as
                // the selected facet for the current control.
                if ($searchObject && $searchObject->hasOrFilter($fullFilter)) {
                    $selected = true;
                } else {
                    $selected = false;
                }
                $parts = explode('/', $value['untranslated']);
                if (!in_array($facet, $facetConfig['SpecialFacets']['hierarchical']) || count($parts) < 2) {
                    $key = $value['value'];
                    $level = 0;
                } else {
                    $level = array_shift($parts);
                    $key = implode('/', $parts);
                }
                $currentList[$key] = array(
                    'filter' => $fullFilter,
                    'selected' => $selected,
                    'translated' => $value['value'],
                    'level' => $level
                );
            }

            // Perform a natural case sort on the array of facet values:
            $keys = array_keys($currentList);
            natcasesort($keys);
            foreach ($keys as $key) {
                $facets[$list['label']][$key] = $currentList[$key];
            }
            
            $searchesConf = getExtraConfigArray('Searches');
            
            // Move primary languages (if set) to the top of the language list
            if (isset($facets['Language']) 
                && isset($searchesConf['PrimaryLanguages']['lang'])
            ) {

                $primaryLanguages = $searchesConf['PrimaryLanguages']['lang'];
                $facets['Language'] = $this->_orderLanguageFacets(
                    $facets['Language'], 
                    $primaryLanguages
                );
            }
        }
        return $facets;
    }
    
    /**
     * Move primary languages to top of the language facet array
     *
     * @param array $languages        The alphabetical language facet array
     * @param array $primaryLanguages The languages to be prioritized
     * 
     * @return array The re-ordered language facet array
     * @access private
     */
    private function _orderLanguageFacets($languages, $primaryLanguages) 
    {
        $primaryLanguages = array_reverse($primaryLanguages);
        $ordered = 0;
        foreach ($primaryLanguages as $primary) {
            foreach ($languages as $key => $language) {
                if ($language['filter'] == 'language:"'.$primary.'"') {
                    $languages = array($key => $languages[$key]) + $languages;
                    $ordered++;
                    break;
                }
            } 
        }
        
        global $interface;
        $interface->assign('languagesSorted', $ordered);
        
        return $languages;
        
    }
}
?>