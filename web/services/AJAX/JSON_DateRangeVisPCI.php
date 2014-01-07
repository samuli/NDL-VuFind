<?php
/**
 * AJAX functions for the Recommender Date Range Visualisation module 
 * using JSON as output format.
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2013.
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
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'JSON_Vis.php';
require_once 'sys/SearchObject/PCI.php';
require_once 'RecordDrivers/Factory.php';
/**
 * AJAX functions for the Recommender Date Range Visualisation module 
 * using JSON as output format.
 * 
 * Gets the data using a different field than the actual filter.
 *
 * @category VuFind
 * @package  Controller_AJAX
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_DateRangeVisPCI extends JSON
{
    protected $dateFacet = '';
    protected $filterField = '';
    protected $searchObject = null;
    /**
     * Constructor
     *
     * @access public
     */
    public function __construct()
    {
        global $action;
        parent::__construct();
        $this->searchObject = SearchObjectFactory::initSearchObject('PCI');
        $this->filterField = 'creationdate';
        $this->dateFacet = 'creationdate';
    }
   
    /**
     * Get data and output in JSON
     *
     * @return void
     * @access public
     */
    public function getVisData()
    {
        global $interface;

        $facetField = isset($_REQUEST['facetField']) ? $_REQUEST['facetField'] : '';
        $filterField = isset($_REQUEST['filterField']) ? $_REQUEST['filterField'] : '';
        
        $this->searchObject->init();
        $this->searchObject->processSearch();
        $filters = $this->searchObject->getFilters();
        $filterFields = $this->processDateFacets($filters);
        $facets = $this->processFacetValues();
        foreach ($filterFields as $field => $val) {
            $facets[$field]['min'] = $val[0];
            $facets[$field]['max'] = $val[1];
            $facets[$field]['removalURL']
                = $this->searchObject->renderLinkWithoutFilter(
                    isset($filters[$filterField][0])
                        ? $field .':' . $filters[$filterField][0] : null
                    );
        }
            $this->output($facets, JSON::STATUS_OK);
    }

    /**
     * Support method for getVisData() -- filter bad values from facet lists.
     *
     * @return array
     * @access protected
     */
    protected function processFacetValues()
    {
        $facets = $this->searchObject->getFacetList();
        $retVal = array();
        $newValues = array('data' => array());
        foreach ($facets['creationdate']['list'] as $facet) {
            $newValues['data'][] = array(0 => $facet['value'], 1 => (int) $facet['count']);
        }
        $retVal[$this->filterField] = $newValues;
        return $retVal;
    }

    /**
     * Support method for getVisData() -- extract details from applied filters.
     *
     * @param array $filters Current filter list
     *
     * @return array
     * @access protected
     */
    protected function processDateFacets($filters)
    {
        $result = array();
        $from = $to = '';
        if (isset($filters[$this->filterField])) {
            foreach ($filters[$this->filterField] as $filter) {
                if ($range = VuFindSolrUtils::parseSpatialDateRange($filter)) {
                    $startDate = new DateTime("@{$range['from']}");
                    $endDate = new DateTime("@{$range['to']}");
                    $from = $startDate->format('Y');
                    $to = $endDate->format('Y');
                    break;
                }
            }
        }
        $result[$this->filterField] = array($from, $to);
        $result[$this->filterField]['label']
            = $this->searchObject->getFacetLabel($this->filterField);
        return $result;
    }
    
}
