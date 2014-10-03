<?php
/**
 * Solr Search Object class for extended browse actions.
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
 * Solr Search Object class for extended browse actions.
 *
 * @category VuFind
 * @package  SearchObject
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_search_object Wiki
 */
class SearchObject_SolrBrowseExtended extends SearchObject_Solr
{
    const URL_FILTER_TYPE = 'browse';

    protected $browseType;

    /**
     * Initialise the object from the global
     *  search parameters in $_REQUEST.
     *
     * @return boolean
     * @access public
     */
    public function init($browseType)
    {
        parent::init();

        $this->view = 'browse';
        $this->browseType = $browseType;
        $this->searchType = 'browse';

        $this->resultsModule = 'Browse';
        $this->resultsAction = $browseType;

        $this->spellcheck  = false;

        $settings = getExtraConfigArray('searches');

        $filters = array();
        if ($settings["BrowseExtended:$browseType"]) {
            $settings = $settings["BrowseExtended:$browseType"];
            $filters = isset($settings['filter']) ? $settings['filter'] : array();
        }
        foreach ($filters as $filter) {
            $this->addHiddenFilter($filter);
        }


        $limit = isset($settings['resultLimit']) ? $settings['resultLimit'] : 100;
        $sort = isset($settings['sort']) ? $settings['sort'] : 'title';

        $this->setLimit($limit);
        $this->setSort($sort);


        $searchType = !isset($_REQUEST['type']) && isset($settings['type']) 
            ? $settings['type'] 
            : false
        ;
        if ($searchType) {
            $this->searchTerms[0]['index'] = $searchType;
        }

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
        $res = isset($searchSettings['BrowseExtendedRecommendations' . $this->browseType])
            ? $searchSettings['BrowseExtendedRecommendations' . $this->browseType]
            : array('side' => array('BrowseExtendedRecommendations' . $this->browseType));

        return $res;
    }
}
?>
