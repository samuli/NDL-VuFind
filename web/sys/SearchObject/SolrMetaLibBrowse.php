<?php
/**
 * Solr Search Object class for browsing MetaLib databases.
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
 * @package  SearchObject
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_search_object Wiki
 */
require_once 'sys/SearchObject/Base.php';
require_once 'RecordDrivers/Factory.php';

/**
 * Solr Search Object class for browsing MetaLib databases.
 *
 * @category VuFind
 * @package  SearchObject
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_search_object Wiki
 */
class SearchObject_SolrMetaLibBrowse extends SearchObject_Solr
{
    const URL_FILTER_TYPE = 'metalibBrowse';

    /**
     * Initialise the object from the global
     *  search parameters in $_REQUEST.
     *
     * @return boolean
     * @access public
     */
    public function init()
    {
        global $module;
        global $action;

        $this->view = 'browse';
        $this->resultsModule = 'MetaLib';
        $this->resultsAction = 'Browse';
    

        $this->addHiddenFilter('format:0/Database/');        

        parent::init();

        $this->searchType = 'metaLibBrowse';
        $this->spellcheck  = false;

        return true;
    } 

    /**
     * Basic 'getter' for view mode.
     *
     * @return string
     * @access public
     */
    public function getView()
    {
        return 'browse';
    }

    /**
     * Load all recommendation settings from the relevant ini file.  Returns an
     * associative array where the key is the location of the recommendations (top
     * or side) and the value is the settings found in the file (which may be either
     * a single string or an array of strings).
     *
     * @return array associative: location (top/side) => search settings
     * @access protected
     */
    protected function getRecommendationSettings()
    {
        $searchSettings = getExtraConfigArray('searches');

        return isset($searchSettings['MetaLibBrowseActionRecommendations'])
            ? $searchSettings['MetaLibBrowseActionRecommendations']
            : array('side' => array('MetaLibBrowseSideFacets'));            
    }

}
?>
