<?php
/**
 * A derivative of the Search Object for use with PCI.
 *
 * PHP version 5
 * 
 * Copyright (C) Villanova University 2010.
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
 * @package  SearchObject
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_search_object Wiki
 */
require_once 'sys/SearchObject/Base.php';
require_once 'sys/PCI.php';

/**
 * A derivative of the Search Object for use with PCI.
 *
 * @category VuFind
 * @package  SearchObject
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_search_object Wiki
 */
class SearchObject_PCI extends SearchObject_Base
{
    protected $baseUrl = '';
    protected $params = array();
    protected $indexResult; // PCI Search Response;
    protected $PCI; // PCI API

    const URL_FILTER_TYPE = 'pci';

    /**
     * Constructor. Initialise details about the server
     *
     * @access public
     */
    public function __construct()
    {
        parent::__construct();
        $this->resultsModule = 'PCI';
        $this->resultsAction = 'Search';
        $config = getExtraConfigArray("PCI");
        foreach ($config['Facets'] as $key => $value) {
            $parts = explode(',', $key);
            $facetName = trim($parts[0]);
            $this->facetConfig[$facetName] = $value;
        }
        $this->translatedFacets = isset($config['Facet_Settings']['translated_facets']) ? $config['Facet_Settings']['translated_facets'] : null;
        $this->facetTranslationPrefix = isset($config['Facet_Settings']['facet_translation_prefix']) ? $config['Facet_Settings']['facet_translation_prefix'] : null;
        
        // Set up basic and advanced PCI search types; default to basic.
        $this->searchType = $this->basicSearchType = 'PCI';
        $this->advancedSearchType = 'PCIAdvanced';
        
            // Set up search options
        $this->basicTypes = $config['Basic_Searches'];
        if (isset($config['Advanced_Searches'])) {
            $this->advancedTypes = $config['Advanced_Searches'];
        }
        
        $this->recommendIni = 'PCI';
        
        $this->params['institution'] = $config['General']['institution'];
        $this->params['highlight'] = $config['General']['highlight'];
        $this->params['db'] = isset($config['General']['db']) ? $config['General']['db'] : null;

        // Set up sort options
        $this->sortOptions = $config['Sorting'];
        // default sort for PCI is empty string
        $this->defaultSort = "";
        
        // Connect to PCI
        $this->PCI = new PCI();



    }

    /**
     * Turn the list of spelling suggestions into an array of urls
     *   for on-screen use to implement the suggestions.
     *
     * @return array Spelling suggestion data arrays
     * @access public
     */
    public function getSpellingSuggestions()
    {
        return array();
    }

    /**
     * Return error from index, always false on PCI
     *
     * @return indexError
     * @access public
     */
    public function getIndexError()
    {
        return false;
    }
    
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

        // Call the standard initialization routine in the parent:
        parent::init();

        //********************
        // Check if we have a saved search to restore -- if restored successfully,
        // our work here is done; if there is an error, we should report failure;
        // if restoreSavedSearch returns false, we should proceed as normal.
        $restored = $this->restoreSavedSearch();
        if ($restored === true) {
            return true;
        } else if (PEAR::isError($restored)) {
            return false;
        }

        //********************
        // Initialize standard search parameters
        $this->initView();
        $this->initPage();
        $this->initSort();
        $this->initFilters();
        $this->initLimit();

        //********************
        // Basic Search logic
        if ($this->initBasicSearch()) {
            // If we found a basic search, we don't need to do anything further.
        } else if (isset($_REQUEST['tag']) && $module != 'MyResearch') {
            // Tags, just treat them as normal searches for now.
            // The search processer knows what to do with them.
            if ($_REQUEST['tag'] != '') {
                $this->searchTerms[] = array(
                    'index'   => 'tag',
                    'lookfor' => $_REQUEST['tag']
                );
            }
        } else {
            $this->initAdvancedSearch();
        }
        $this->limit = 10;
        
    }

    /**
    * Add a field to facet on.
    *
    * @param string $newField Field name
    * @param string $newAlias Optional on-screen display label
    *
    * @return void
    * @access public
    */
    public function addFacet($newField, $newAlias = null)
    {
        // Save the full field name (which may include extra parameters);
        // we'll need these to do the proper search using the Summon class:
        $this->_fullFacetSettings[] = $newField;
    
        // Strip parameters from field name if necessary (since they get
        // in the way of most Search Object functionality):
        $newField = explode(',', $newField);
        $newField = trim($newField[0]);
        parent::addFacet($newField, $newAlias);
    }
    
    /**
     * Returns the stored list of facets for the last search
     *
     * @param array $filter         Array of field => on-screen description listing
     * all of the desired facet fields; set to null to get all configured values.
     * @param bool  $expandingLinks If true, we will include expanding URLs (i.e.
     * get all matches for a facet, not just a limit to the current search) in the
     * return array.
     *
     * @return array                Facets data arrays
     * @access public
     */
    public function getFacetList($filter = null, $expandingLinks = false)
    {
        // If there is no filter, we'll use all facets as the filter:
        if (is_null($filter)) {
            $filter = $this->facetConfig;
        } else {
            // If there is a filter, make sure the field names are properly
            // stripped of extra parameters:
            $oldFilter = $filter;
            $filter = array();
            foreach ($oldFilter as $key => $value) {
                $key = explode(',', $key);
                $key = trim($key[0]);
                $filter[$key] = $value;
            }
        }

        // We want to sort the facets to match the order in the .ini file.  Let's
        // create a lookup array to determine order:
        $i = 0;
        $order = array();
        foreach ($filter as $key => $value) {
            $order[$key] = $i++;
        }
        $list = array();
        $translationPrefix = isset($this->facetTranslationPrefix) 
            ? $this->facetTranslationPrefix : '';
        
        // Loop through every field returned by the result set
        $validFields = array_keys($filter);
        foreach ($this->indexResult['facetFields'] as $data) {
            $field = $data['id'];
            $tag = $data['tag'];
            // Skip filtered fields and empty arrays:
            if (!in_array($field, $validFields) || count($data) < 1) {
                continue;
            }
            $i = $order[$field];
            $list[$i]['label'] = $filter[$field];
            $list[$i]['tag'] = $tag;
            // Should we translate values for the current facet?
            $translate = in_array($field, $this->translatedFacets);
            // Loop through values:
            foreach ($data['values'] as $facet) {
                // Initialize the array of data about the current facet:
                $currentSettings = array();
                $currentSettings['value']
                    = $translate ? translate($translationPrefix . $facet['value']) : $facet['value'];
                $currentSettings['untranslated'] = $facet['value'];
                $currentSettings['count'] = $facet['count'];
                $currentSettings['isApplied'] = false;
                $currentSettings['url']
                    = $this->renderLinkWithFilter("$field:".$facet['value']);
                // If we want to have expanding links (all values matching the
                // facet) in addition to limiting links (filter current search
                // with facet), do some extra work:
                if ($expandingLinks) {
                    $currentSettings['expandUrl']
                        = $this->getExpandingFacetLink($field, $facet['value']);
                }
                // Is this field a current filter?
                if (in_array($field, array_keys($this->filterList))) {
                    // and is this value a selected filter?
                    if (in_array($facet['value'], $this->filterList[$field])) {
                        $currentSettings['isApplied'] = true;
                    }
                }
        
                // Put the current facet cluster in order based on the .ini
                // settings, then override the display name again using .ini
                // settings.
                $currentSettings['label'] = $filter[$field];
                
                // Store the collected values:
                $list[$i]['list'][] = $currentSettings;
            }
        }
        ksort($list);

        // Rewrite the sorted array with appropriate keys:
        $finalResult = array();
        foreach ($list as $current) {
            $finalResult[$current['tag']] = $current;
        }

        return $finalResult;
    }

    /**
    * Load all available facet settings.  This is mainly useful for showing
    * appropriate labels when an existing search has multiple filters associated
    * with it.
    *
    * @param string $preferredSection Section to favor when loading settings; if
    * multiple sections contain the same facet, this section's description will be
    * favored.
    *
    * @return void
    * @access public
    */
    public function activateAllFacets($preferredSection = false)
    {   
        if (isset($this->allFacetSettings) 
            && is_array($this->allFacetSettings)
        ) {
            foreach ($this->allFacetSettings as $section => $values) {
                foreach ($values as $key => $value) {
                    $this->addFacet($key, $value);
                }
            }
        }
        
        if ($preferredSection
            && is_array($this->allFacetSettings[$preferredSection])
        ) {
            foreach ($this->allFacetSettings[$preferredSection] as $key => $value) {
                $this->addFacet($key, $value);
            }
        }
    }
    
    /**
     * Actually process and submit the search
     *
     * @param bool $returnIndexErrors Should we die inside the index code if we
     * encounter an error (false) or return it for access via the getIndexError()
     * method (true)?
     * @param bool $recommendations   Should we process recommendations along with
     * the search itself?
     *
     * @return array                 PCI result structure
     * @access public
     */
    public function processSearch($returnIndexErrors = false, $recommendations = true) 
    {        
        // Get time before the query
        $this->startQueryTimer();
        if ($recommendations) {
            $this->initRecommendations();
        }
        $startRec = ($this->page - 1) * $this->limit;
        $this->indexResult = $this->PCI->query(
            $this->searchTerms, 
            $this->filterList, 
            $startRec, 
            $this->limit, 
            $this->sort
        );
        // Get time after the query
        $this->stopQueryTimer();
        
        $this->resultsTotal = $this->indexResult['recordCount'];
        
        // If extra processing is needed for recommendations, do it now:
        if ($recommendations && is_array($this->recommend)) {
            foreach ($this->recommend as $currentSet) {
                foreach ($currentSet as $current) {
                    $current->process();
                }
            }
        }
        
        return $this->indexResult;
    }

    /**
     * Get one record from API
     *
     * @param string $id record id.
     *
     * @return array PCI record.
     * @access public
     */     
    public function getRecord($id) 
    {
        return $this->PCI->getRecord($id);
    }      

    /**
     * Use the record driver to build an HTML display from the search
     * result suitable for use on a user's "favorites" page.
     *
     * @param array  $record    Record data.
     * @param object $user      User object owning tag/note metadata.
     * @param int    $listId    ID of list containing desired tags/notes (or
     * null to show tags/notes from all user's lists).
     * @param bool   $allowEdit Should we display edit controls?
     *
     * @return string HTML chunk for individual records.
     * @access public
     */
    public function getResultHTML($record, $user, $listId = null, $allowEdit = true)
    {
        global $interface;
    
        $interface->assign(array('record' => $record));
        
        // Pass some parameters along to the template to influence edit controls:
        $interface->assign('listSelected', $listId);
        $interface->assign('listEditAllowed', $allowEdit);
        
        return $interface->fetch('PCI/listentry.tpl');
    }

    /** Prettifies an XML string into a human-readable and indented work of art 
    *
    * @param string  $xml         The XML as a string
    * @param boolean $html_output True if the output should be escaped (for use in HTML)
    *
    * @return string prettified XML.
    * @access public
    */
    protected function xmlpp($xml, $html_output=false)
    {  
        $xml_obj = new SimpleXMLElement($xml);  
        $level = 4;  
        $indent = 0; // current indentation level  
        $pretty = array();  
      
        // get an array containing each XML element  
        $xml = explode("\n", preg_replace('/>\s*</', ">\n<", $xml_obj->asXML()));  
  
        // shift off opening XML tag if present  
        if (count($xml) && preg_match('/^<\?\s*xml/', $xml[0])) {  
            $pretty[] = array_shift($xml);  
        }  
  
        foreach ($xml as $el) {  
            if (preg_match('/^<([\w])+[^>\/]*>$/U', $el)) {  
                // opening tag, increase indent  
                $pretty[] = str_repeat(' ', $indent) . $el;  
                $indent += $level;  
            } else {  
                if (preg_match('/^<\/.+>$/', $el)) {              
                    $indent -= $level;  // closing tag, decrease indent  
                }  
                if ($indent < 0) {  
                    $indent += $level;  
                }  
                $pretty[] = str_repeat(' ', $indent) . $el;  
            }  
        }     
        $xml = implode("\n", $pretty);     
        return ($html_output) ? htmlentities($xml) : $xml;  
    }      
}
