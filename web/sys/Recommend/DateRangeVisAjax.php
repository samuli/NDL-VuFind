<?php
/**
 * DateRangeVis
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
 * @package  Recommendations
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */

require_once 'sys/Recommend/PubDateVisAjax.php';

/**
 * DateRangeVisAjax Recommendations Module
 *
 * This class displays a visualisation of facet values in a recommendation module 
 * and uses another index field for result filtering. 
 *
 * @category VuFind
 * @package  Recommendations
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */
class DateRangeVisAjax extends PubDateVisAjax
{
    protected $filterField = '';
    
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
        parent::__construct($searchObject, $params);
        $this->filterField = array_shift($this->dateFacets);
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
        
        parent::process();

        $interface->assign('filterField', $this->filterField);
        $filters = $this->searchObject->getFilters();
        $url = $this->searchObject->renderLinkWithoutFilter(
            isset($filters[$this->filterField][0])
            ? $this->filterField .':' . $filters[$this->filterField][0] : null
        );
        $parts = explode('?', $url);
        if (isset($parts[1])) {
            $interface->assign('searchParamsWithoutFilter', $parts[1]);
        } else {
            $interface->assign('searchParamsWithoutFilter', '');
        }
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
        return 'Search/Recommend/DateRangeVisAjax.tpl';
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
