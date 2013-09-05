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
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'JSON_Vis.php';
require_once 'RecordDrivers/Factory.php';

/**
 * AJAX functions for the Recommender Date Range Visualisation module 
 * using JSON as output format.
 * 
 * Gets the data using a different field than the actual filter.
 *
 * @category VuFind
 * @package  Controller_AJAX
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_DateRangeVis extends JSON
{
    protected $dateFacet = '';
    protected $filterField = '';
    
    /**
     * Constructor
     *
     * @access public
     */
    public function __construct()
    {
        global $action;
        parent::__construct();
        if (isset($_REQUEST['collection'])) {
            $this->searchObject
                = SearchObjectFactory::initSearchObject('SolrCollection');
            $action = isset($_REQUEST['collectionAction'])
                ? $_REQUEST['collectionAction']: 'Home';
        } else {
            $this->searchObject = SearchObjectFactory::initSearchObject();
        }
        
        // Load the desired facet information...
        $config = getExtraConfigArray('facets');
        if (isset($config['SpecialFacets']['dateRangeVis'])) {
            list($this->filterField, $this->dateFacet) = explode(':', $config['SpecialFacets']['dateRangeVis'], 2);
        }
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
        
        if (is_a($this->searchObject, 'SearchObject_Solr')) {
            if (isset($_REQUEST['collection'])) {
                //ID of the collection
                $collection = $_REQUEST['collection'];

                // Retrieve the record for this collection from the index
                $this->db = ConnectionManager::connectToIndex();
                if (!($record = $this->db->getRecord($collection))) {
                    PEAR::raiseError(new PEAR_Error('Record Does Not Exist'));
                }
                $this->recordDriver = RecordDriverFactory::initRecordDriver($record);

                //get the collection identefier for this record
                $this->collectionIdentifier
                    = $this->recordDriver->getCollectionRecordIdentifier();
                $this->searchObject->setCollectionField(
                    $this->collectionIdentifier
                );

                // Set the searchobjects collection id to the collection id
                $this->searchObject->collectionID($collection);

            }
            $this->searchObject->init();
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
                if (isset($_REQUEST['collection'])) {
                    $collection = $_REQUEST['collection'];
                    $facets[$field]['removalURL']
                        = str_replace(
                            'Search/Results',
                            'Collection/' . $collection .
                            '/' .$_REQUEST['collectionAction'],
                            $facets[$field]['removalURL']
                        );
                }
            }
            $this->output($facets, JSON::STATUS_OK);
        } else {
            $this->output("", JSON::STATUS_ERROR);
        }
    }

    /**
     * Support method for getVisData() -- filter bad values from facet lists.
     *
     * @return array
     * @access protected
     */
    protected function processFacetValues()
    {
        $this->searchObject->setFacetSortOrder('index');
        $facets = $this->searchObject->getFullFieldFacets(array($this->dateFacet));
        $retVal = array();
        foreach ($facets as $field => $values) {
            $newValues = array('data' => array());
            foreach ($values['data'] as $current) {
                // Only retain numeric values!
                if (preg_match("/^-?[0-9]+$/", $current[0])) {
                    $newValues['data'][] = $current;
                }
            }
            $retVal[$this->filterField] = $newValues;
        }
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
