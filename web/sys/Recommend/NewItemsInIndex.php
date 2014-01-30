<?php
/**
 * OpenLibrarySubjects Recommendations Module
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
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */
require_once 'sys/OpenLibraryUtils.php';
require_once 'sys/Recommend/Interface.php';

/**
 * OpenLibrarySubjects Recommendations Module
 *
 * This class provides recommendations by doing a search of the catalog; useful
 * for displaying catalog recommendations in other modules (i.e. Summon, Web, etc.)
 *
 * @category VuFind
 * @package  Recommendations
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_recommendations_module Wiki
 */
class NewItemsInIndex implements RecommendationInterface
{
    private $_searchObject;

    /**
     * Constructor
     *
     * Establishes base settings for making recommendations.
     *
     * @param object $searchObject The SearchObject requesting recommendations.
     * @param string $params       Colon-separated settings from config file.
     *
     * @access public
     */
    public function __construct($searchObject, $params)
    {
        $this->_searchObject = $searchObject;
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
        // No action needed here.
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
        
        $newItemsValues = array('[NOW-1YEAR TO NOW]', 
            '[NOW-6MONTHS TO NOW]',
            '[NOW-3MONTHS TO NOW]',
            '[NOW-1MONTHS TO NOW]',
            '[NOW-7DAYS TO NOW]',
            '[xxx TO NOW]'
            
        );
        
        $filterList = $this->_searchObject->getFilterList(true);

        // Only one of the latest items recommendations can be in use at the same time
        foreach ($filterList as $filters) {
            foreach ($filters as $filter) {
                if ($filter['field'] === 'first_indexed') {
                    $this->_searchObject->removeFilter('first_indexed:' . $filter['value']);
                }                
            }
        }
        
        $filterList = $this->_searchObject->getFilterList(true);

        $newItemsLinks = array();
        
        foreach ($newItemsValues as $value) {
            $link = $this->_searchObject->renderLinkWithFilter("first_indexed:$value");
            $newItemsLinks[] = array(
                'label' => translate(array('text' => $value, 'prefix' => 'facet_')),
                'url' => $link
            );
        }
        
        $interface->assign(compact('newItemsLinks'));
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
        return 'Search/Recommend/NewItemsInIndex.tpl';
    }
}

?>