<?php
/**
 * JSON handler for facet requests
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2012.
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
 * @package  Controller_Record
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'JSON.php';

/**
 * JSON Facet request action. Returns facets for the given search and hierarchy level.
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

class JSON_Facets extends JSON
{
    /**
     * Get data and output in JSON
     *
     * @return void
     * @access public
     */
    public function getFacets()
    {
        $facetConfig = getExtraConfigArray('facets');

        // Initialize from the current search globals
        $searchObject = null;
        if (isset($_REQUEST['searchObject'])) {
            $searchObject = SearchObjectFactory::initSearchObject($_REQUEST['searchObject']);
        } else {
            $searchObject = SearchObjectFactory::initSearchObject();
        }
        if (get_class($searchObject) == 'SearchObject_SolrBrowseExtended' && isset($_REQUEST['vufindAction'])) {
            $searchObject->init($_REQUEST['vufindAction']);
        } else {
            $searchObject->init();
        }

        $prefix = explode('/', isset($_REQUEST['facetPrefix']) ? $_REQUEST['facetPrefix'] : '', 2);
        $prefix = end($prefix);
        $facetName = $_REQUEST['facetName'];
        $level = isset($_REQUEST['facetLevel']) ? $_REQUEST['facetLevel'] : false;

        // Add any facet filters unless a specific prefix has been specified
        if ($level !== false) {
            $searchObject->addFacetPrefix(array($facetName => "$level/$prefix"));
        } elseif ($prefix) {
            $searchObject->addFacetPrefix(array($facetName => $prefix));
        }
        $result = $searchObject->processSearch(true, false);
        if (PEAR::isError($result)) {
            $this->output("Search failed: $result", JSON::STATUS_ERROR);
            return;
        }
        $facets = $searchObject->getFacetList(array($facetName => $facetName));
        if (!isset($facets[$facetName]['list'])) {
            $this->output(array(), JSON::STATUS_OK);
            return;
        }
        if (!isset($facetConfig['FacetFilters'][$facetName])) {
            $facets = $facets[$facetName]['list'];
        } else {
            $list = array();
            foreach ($facets[$facetName]['list'] as $item) {
                list($level) = explode('/', $item['untranslated']);
                $match = false;
                $levelSpecified = false;
                foreach ($facetConfig['FacetFilters'][$facetName] as $filterItem) {
                    list($filterLevel) = explode('/', $filterItem);
                    if ($level == $filterLevel) {
                        $levelSpecified = true;
                    }
                    if (strncmp($item['untranslated'], $filterItem, strlen($filterItem)) == 0) {
                        $match = true;
                    }
                }
                if ($match || !$levelSpecified) {
                    $list[] = $item;
                }
            }
            $facets = $list;
        }

        // Process exclusion filters
        if (isset($facetConfig['ExcludeFilters'][$facetName])) {
            $list = array();
            foreach ($facets as $item) {
                $match = false;
                foreach ($facetConfig['ExcludeFilters'][$facetName] as $filterItem) {
                    if (strncmp($item['untranslated'], $filterItem, strlen($filterItem)) == 0) {
                        $match = true;
                        break;
                    }
                }
                if (!$match) {
                    $list[] = $item;
                }
            }
            $facets = $list;
        }

        // For hierarchical facets: Now that we have the current facet level, try next level
        // so that we can indicate which facets on this level have children.
        if ($level !== false) {
            ++$level;
            $searchObject->addFacetPrefix(array($facetName => "$level/$prefix"));
            $result = $searchObject->processSearch(true, false);
            if (PEAR::isError($result)) {
                $this->output("Search failed: $result", JSON::STATUS_ERROR);
                return;
            }
            $subFacets = $searchObject->getFacetList(array($facetName => $facetName));
            if (isset($subFacets[$facetName]['list'])) {
                foreach ($subFacets[$facetName]['list'] as $subFacet) {
                    // Apply filters
                    if (isset($facetConfig['FacetFilters'][$facetName])) {
                        list($level) = explode('/', $subFacet['untranslated']);
                        $match = false;
                        $levelSpecified = false;
                        foreach ($facetConfig['FacetFilters'][$facetName] as $filterItem) {
                            list($filterLevel) = explode('/', $filterItem);
                            if ($level == $filterLevel) {
                                $levelSpecified = true;
                            }
                            if (strncmp($subFacet['untranslated'], $filterItem, strlen($filterItem)) == 0) {
                                $match = true;
                            }
                        }
                        if (!$match && $levelSpecified) {
                            continue;
                        }
                    }

                    $subFacetCode = implode('/', array_slice(explode('/', $subFacet['untranslated']), 1, $level));
                    foreach ($facets as &$facet) {
                        $facetCode = implode('/', array_slice(explode('/', $facet['untranslated']), 1, $level));
                        if ($facetCode == $subFacetCode) {
                            $facet['children'] = true;
                            break;
                        }
                    }
                }
            }
        }

        $this->output($facets, JSON::STATUS_OK);
    }
}
