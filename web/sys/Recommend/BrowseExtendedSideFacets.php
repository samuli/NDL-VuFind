<?php
/**
 * SideFacets Recommendations Module for MetaLib database browsing
 *
 * PHP version 5
 *
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
 * @package  Recommendations
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */
require_once 'sys/Recommend/Interface.php';
require_once 'sys/Recommend/SideFacets.php';

/**
 * SideFacets Recommendations Module for MetaLib database browsing
 *
 * This class provides recommendations displaying facets beside search results
 *
 * @category VuFind
 * @package  Recommendations
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */
class BrowseExtendedSideFacets extends SideFacets
{
    protected $browseType;

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
        $this->browseType = $params;
        
        parent::__construct($searchObject, 'BrowseExtended' . $params);
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
        global $configArray;
        global $interface;

        $interface->assign('searchObject', 'SolrBrowseExtended');
        parent::process();

        $interface->assign('activeFacets', array_keys($this->_mainFacets));
        $interface->assign('sideFacetLabel', "Narrow BrowseExtended $this->browseType");
    }

}

?>