<?php
/**
 * Organisations action for Content module
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2012
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
 * @package  Controller_Help
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';

/**
 * Organisations action for Content module
 *
 * @category VuFind
 * @package  Controller_Help
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Organisations extends Action
{
    const BUILDING = 'building';

    /**
     * Fetch all values of facet 'building' for each sector type (0/arc, 0/lib, 0/mus).
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;

        $facetConfig = getExtraConfigArray('facets');

        $sectors = array('arc', 'lib', 'mus');
        $res = array();
        $cnt = array();
        foreach ($sectors as $sector) {
            $searchObject = SearchObjectFactory::initSearchObject();
            $query = "sector_str_mv:0\/$sector\/";
            $searchObject->initBrowseScreen();
            $searchObject->disableLogging();
            $searchObject->setQueryString($query);
            $searchObject->addFacetPrefix('0');  // include only top-level buildings
            
            $result = $searchObject->getFullFieldFacets(array(organisations::BUILDING), true);
            
            $searchObject->close();
            if (PEAR::isError($result)) {
                PEAR::raiseError($result->getMessage());
            }
            
            if (isset($result[organisations::BUILDING]['data'])) {
                foreach ($result[organisations::BUILDING]['data'] as $i) {
                    $building = $i[0];

                    // Process inclusion filters
                    if (isset($facetConfig['FacetFilters'][organisations::BUILDING])) {
                        $match = false;
                        foreach ($facetConfig['FacetFilters'][organisations::BUILDING] as $filterItem) {
                            if (strncmp($building, $filterItem, strlen($filterItem)) == 0) {
                                $match = true;
                                break;
                            }
                        }
                        if (!$match) {
                            continue;
                        }
                    }
                    
                    // Process exclusion filters
                    if (isset($facetConfig['ExcludeFilters'][organisations::BUILDING])) {
                        foreach ($facetConfig['ExcludeFilters'][organisations::BUILDING] as $filterItem) {
                            if (strncmp($building, $filterItem, strlen($filterItem)) == 0) {
                                continue 2;
                            }
                        }                        
                    }

                    // cut trailing '/', append 'facet_' and translate
                    $name = translate('facet_' . substr($building, 0, -1));
                    $link = $searchObject->renderLinkWithFilter(organisations::BUILDING . ":$building");
                    $res[$sector][] = array($name, $link);
                }            
            }
            $cnt[$sector] = count($res[$sector]);
            usort(
                $res[$sector], 
                function($a,$b) { 
                    return $a[0] > $b[0]; 
                }
            );
        }

        $file = 'Organisations.tpl';
        $interface->setPageTitle(translate("content-organisations"));
        $interface->setTemplate($file);
        $interface->assign('organisations', $res);
        $interface->assign('cnt', $cnt);        
        $interface->display('layout.tpl');
    }
}

?>
