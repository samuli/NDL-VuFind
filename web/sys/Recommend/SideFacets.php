<?php
/**
 * SideFacets Recommendations Module
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2010.
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
 * @package  Recommendations
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */
require_once 'sys/Recommend/Interface.php';

/**
 * SideFacets Recommendations Module
 *
 * This class provides recommendations displaying facets beside search results
 *
 * @category VuFind
 * @package  Recommendations
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */
class SideFacets implements RecommendationInterface
{
    protected $_searchObject;
    private $_dateFacets = array();
    protected  $_mainFacets;
    private $_checkboxFacets;
    private $_checkboxFacetsSection;
    protected $_hierarchicalFacets = array();
    protected $_hiddenFacets = array();
    
    /**
     * Constructor
     *
     * Establishes base settings for making recommendations.
     *
     * @param object $searchObject The SearchObject requesting recommendations.
     * @param string $params       Additional settings from searches.ini.
     *
     * @access public
     */
    public function __construct($searchObject, $params)
    {
        // Save the passed-in SearchObject:
        $this->_searchObject = $searchObject;

        // Parse the additional settings:
        $params = explode(':', $params);
        $mainSection = empty($params[0]) ? 'Results' : $params[0];
        $checkboxSection = isset($params[1]) ? $params[1] : false;
        $iniName = isset($params[2]) ? $params[2] : 'facets';

        // Load the desired facet information...
        $config = getExtraConfigArray($iniName);

        // All standard facets to display:
        $this->_mainFacets = isset($config[$mainSection]) ?
            $config[$mainSection] : array();

        // Get a list of fields that should be displayed as date ranges rather than
        // standard facet lists.
        if (isset($config['SpecialFacets']['dateRange'])) {
            $this->_dateFacets = is_array($config['SpecialFacets']['dateRange'])
                ? $config['SpecialFacets']['dateRange']
                : array($config['SpecialFacets']['dateRange']);
        }

        // Get a list of fields that should be displayed as a hierarchy.
        if (isset($config['SpecialFacets']['hierarchical'])) {
            $this->_hierarchicalFacets = $config['SpecialFacets']['hierarchical'];
        }        
        
        // Get a list of fields that should be open on default.
        if (isset($config['SpecialFacets']['default'])) {
            $this->_defaultFacets = $config['SpecialFacets']['default'];
        } else {
            $this->_defaultFacets = array();
        }

        // Get a list of facetfields that should not be displayed.
        if (isset($config['SpecialFacets']['hidden'])) {
            $this->_hiddenFacets = $config['SpecialFacets']['hidden'];
        } else {
            $this->_hiddenFacets = array();
        }
        
        // Checkbox facets:
        $checkboxFacets
            = ($checkboxSection && isset($config[$checkboxSection]))
            ? $config[$checkboxSection] : array();

        $this->_checkboxFacets = array();
        foreach ($checkboxFacets as $key => $val) {
            $this->_checkboxFacets[$key] = array('desc' => $val, 'data' => array());
        }

        // Checkbox facets inside facet sections
        foreach ($this->_mainFacets as $key => $val) {
            $section = "$checkboxSection:$key";
            if (isset($config[$section])) {
                $data = $config[$section];
                 $this->_checkboxFacetsSection[$val] = $data;
                
                foreach ($data as $filter => $translationKey) {
                    $sectionKey = array_pop(array_keys($filter));
                    // Store facet section id as 'parent'
                    $this->_checkboxFacets[$filter] 
                        = array('desc' => $translationKey, 'data' => array('parent' => $key));
                }
            }
        }

        //collection keyword filter
        $this->_collectionKeywordFilter
            = isset($config['Collection_Keyword']['search']) ? $config['Collection_Keyword']['search'] : false;
        
    }

    /**
     * init
     *
     * Called before the SearchObject performs its main search.  This may be used
     * to set SearchObject parameters in order to generate recommendations as part
     * of the search.
     *
     * @return void
     * @access public
     */
    public function init()
    {
        // Turn on side facets in the search results:
        foreach ($this->_mainFacets as $name => $desc) {
            $this->_searchObject->addFacet($name, $desc);
        }
        foreach ($this->_checkboxFacets as $name => $data) {
            $desc = $data['desc'];
            $data = $data['data'];
            $this->_searchObject->addCheckboxFacet($name, $desc, $data);
        }
    }

    /**
     * process
     *
     * Called after the SearchObject has performed its main search.  This may be 
     * used to extract necessary information from the SearchObject or to perform
     * completely unrelated processing.
     *
     * @return void
     * @access public
     */
    public function process()
    {
        global $interface;

        // All checkbox filters
        $checkboxFilters = $this->_searchObject->getCheckboxFacets();
        $checkboxStatus = $this->_searchObject->getCheckboxFacetStatus();

        // Checkbox filters displayed inside facet sections        
        $checkboxFiltersSection = array();

        // Checkbox filters displayed at the beginning of side navi
        $checkboxFiltersFacetNavi = array();

        // Divide checkbox filters into two groups (regular & inside facet section):
        foreach ($checkboxFilters as $key => $data) {
            $match = false;
            foreach ($this->_checkboxFacetsSection as $secKey => $secFilters) {
                foreach ($secFilters as $filter => $translationCode) {
                    if ($data['filter'] == $filter) {
                        // This goes inside a facet section
                        $checkboxFiltersSection[$secKey][$filter] = $data;
                        $match = true;                        
                    }
                }
                if ($match) {
                    continue;
                }
            }
            // No match found: this is a regular checkbox filter, 
            // and is not displayed inside a facet section.
            if (!$match) {
                $checkboxFiltersFacetNavi[$key] = $data;                
            }
        }


        $interface->assign('checkboxFilters', $checkboxFilters);
        $interface->assign('checkboxStatus', $checkboxStatus);
        $interface->assign('checkboxFiltersFacetNavi', $checkboxFiltersFacetNavi);
        $interface->assign('checkboxFiltersSection', $checkboxFiltersSection);


        $filterList = $this->_searchObject->getFilterList(true);

        // facet categories that have selections
        $activeFacets = array();
        foreach ($filterList as $filter) {
            $activeFacets[] = $filter[0]['field'];
        }

        // Checkbox filters inside facet sections (unlike regular checkbox filters) 
        // are also displayed as active filters, and therefore need to be added to 'filterList'.
        $filterListWithCheckbox = $this->_searchObject->getFilterList(false);
        foreach ($filterListWithCheckbox as $key => $filters) {
            foreach ($filters as $filterData) {
                $filter = $filterData['field'] . ':' . $filterData['value'];
                
                foreach ($checkboxFiltersSection as $sectionKey => $sectionFilters) {
                    foreach ($sectionFilters as $sectionFilter => $translationCode) {
                        if ($filter == $sectionFilter) {
                            // Hide field name
                            $filterData['hideField'] = true;
                            $filterList[$filterData['field']][] = $filterData;
                        }
                    }
                }
            }
        }

        $interface->assign(compact('filterList'));
        $interface->assign(compact('activeFacets'));

        $interface->assign(
            'dateFacets',
            $this->_processDateFacets($this->_searchObject->getFilters())
        );
        $interface->assign('hierarchicalFacets', $this->_hierarchicalFacets);
        $interface->assign('defaultFacets', $this->_defaultFacets);
        $interface->assign('hiddenFacets', $this->_hiddenFacets);
        
        $interface->assign(
            'sideFacetSet', $this->_searchObject->getFacetList($this->_mainFacets)
        );
        $interface->assign('sideFacetLabel', 'Narrow Search');
        $this->processNewItemsFacet($filterList);
    }

    /**
     * getTemplate
     *
     * This method provides a template name so that recommendations can be displayed
     * to the end user.  It is the responsibility of the process() method to
     * populate all necessary template variables.
     *
     * @return string The template to use to display the recommendations.
     * @access public
     */
    public function getTemplate()
    {
        return 'Search/Recommend/SideFacets.tpl';
    }

    /**
     * _processDateFacets
     *
     * Support method to pre-populate date ranges using values found in filters.
     *
     * @param array $filters Filter information from search object.
     *
     * @return array         Array of from/to value arrays keyed by field.
     * @access protected
     */
    protected function _processDateFacets($filters)
    {
        $result = array();
        foreach ($this->_dateFacets as $current) {
            $from = $to = '';
            if (isset($filters[$current])) {
                foreach ($filters[$current] as $filter) {
                    if ($range = VuFindSolrUtils::parseRange($filter)) {
                        $from = $range['from'] == '*' ? '' : $range['from'];
                        $to = $range['to'] == '*' ? '' : $range['to'];
                        break;
                    }
                }
            }
            $result[$current] = array($from, $to);
        }
        return $result;
    }
    
    protected function processNewItemsFacet($filterList) {
        global $interface;
        $newItemsValues = array('[NOW-1YEAR TO NOW]', 
            '[NOW-6MONTHS TO NOW]',
            '[NOW-3MONTHS TO NOW]',
            '[NOW-1MONTHS TO NOW]',
            '[NOW-7DAYS TO NOW]',
            '[xxx TO NOW]'
        );
        $removedValue = false;
        // Only one of the latest items recommendations can be in use at the same time
        foreach ($filterList as $filters) {
            foreach ($filters as $filter) {
                if ($filter['field'] === 'first_indexed') {
                    $this->_searchObject->removeFilter('first_indexed:' . $filter['value']);
                    $removedValue = $filter['value'];
                }                
            }
        }
        $newItemsLinks = array();
        foreach ($newItemsValues as $value) {
            $link = $this->_searchObject->renderLinkWithFilter("first_indexed:$value");
            $newItemsLinks[] = array(
                'label' => translate(array('text' => $value, 'prefix' => 'facet_')),
                'url' => $link
            );
        }
        if ($removedValue) {
            if(!in_array($removedValue, $newItemsValues)) {
                $datePart = substr($removedValue, 1, 20);
                $interface->assign('newItemsDate', $datePart);
            }
            
            // Put the filter back on for ordering purposes.
            $this->_searchObject->addFilter('first_indexed:' . $removedValue);
        }
        $interface->assign(compact('newItemsLinks'));
    }
}

?>