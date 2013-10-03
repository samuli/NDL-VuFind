<?php
/**
 * LIDO Record Driver
 *
 * PHP version 5
 *
 * Copyright (C) Ere Maijala 2012.
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
 * @package  RecordDrivers
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/other_than_marc Wiki
 */
require_once 'RecordDrivers/IndexRecord.php';
require_once 'modules/geshi.php';

/**
 * LIDO Record Driver
 *
 * This class is designed to handle LIDO records.
 *
 * @category VuFind
 * @package  RecordDrivers
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/other_than_marc Wiki
 */
class LidoRecord extends IndexRecord
{
    // LIDO record
    protected $xml;
    
    /**
     * Constructor.  We build the object using all the data retrieved
     * from the (Solr) index (which also happens to include the
     * 'fullrecord' field containing raw metadata).  Since we have to
     * make a search call to find out which record driver to construct,
     * we will already have this data available, so we might as well
     * just pass it into the constructor.
     *
     * @param array $indexFields All fields retrieved from the index.
     *
     * @access public
     */
    public function __construct($indexFields)
    {
        parent::__construct($indexFields);
        
        $this->xml = simplexml_load_string($this->fields['fullrecord']);
    }
    
    /**
     * Assign necessary Smarty variables and return a template name to
     * load in order to display core metadata (the details shown in the
     * top portion of the record view pages, above the tabs).
     *
     * @return string Name of Smarty template file to display.
     * @access public
     */
    public function getCoreMetadata()
    {
        global $interface;
        
        parent::getCoreMetadata();
        $interface->assign('coreImages', $this->getAllImages());
        $interface->assign('coreSubjectDates', $this->getSubjectDates());
        $interface->assign('coreSubjectPlaces', $this->getSubjectPlaces());
        $interface->assign('coreSubjectDetails', $this->getSubjectDetails());
        
        if (isset($this->fields['measurements'])) {
            $interface->assign('coreMeasurements', $this->fields['measurements']);
        }
        
        $interface->assign('coreEvents', $this->getEvents());
        $interface->assign('coreInscriptions', $this->getInscriptions());
        
        $interface->assign('coreIdentifier', $this->getIdentifier());
        
        return 'RecordDrivers/Lido/core.tpl';
    }
        
    /**
     * Assign necessary Smarty variables and return a template name for the current
     * view to load in order to display a summary of the item suitable for use in
     * search results.
     *
     * @param string $view The current view.
     *
     * @return string      Name of Smarty template file to display.
     * @access public
     */
    public function getSearchResult($view = 'list')
    {
        global $configArray;
        global $interface;
        
        parent::getSearchResult($view);
    
        $interface->assign('summImages', $this->getAllImages());
        if (in_array('Image', $this->getFormats()) && $this->getSubtitle() == '') {
            if ($this->getHighlightedTitle()) {
                $interface->assign('summHighlightedTitle', $this->getHighlightedTitle());
            }
            $interface->assign('summTitle', $this->getTitle());
        }
        $interface->assign('summSubtitle', $this->getSubtitle());
        
        $mainFormat = $this->getFormats();
        if (is_array($mainFormat)) {
            $mainFormat = $mainFormat[0];
        } else {
            $mainFormat = '';
        }
        if (isset($this->fields['main_date_str'])) {
            $interface->assign('summDate', array($this->fields['main_date_str']));
        }
        if (isset($this->fields['event_creation_displaydate_str'])) {
            if ($mainFormat == 'Image') {
                $interface->assign('summImageDate', $this->fields['event_creation_displaydate_str']);
            } else {
                $interface->assign('summCreationDate', $this->fields['event_creation_displaydate_str']);
            }
        }
        if (isset($this->fields['event_use_displaydate_str'])) {
            $interface->assign('summUseDate', $this->fields['event_use_displaydate_str']);
        }
        if (isset($this->fields['event_use_displayplace_str'])) {
            $interface->assign('summUsePlace', $this->fields['event_use_displayplace_str']);
        }
        
        return 'RecordDrivers/Lido/result-' . $view . '.tpl';
    }
    
    /**
     * Return an associative array of image URLs associated with this record (key = URL,
     * value = description), if available; false otherwise. 
     *
     * @return mixed
     * @access protected
     */
    public function getAllImages()
    {
        $urls = array();
        $url = '';
        foreach ($this->xml->xpath('/lidoWrap/lido/administrativeMetadata/resourceWrap/resourceSet/resourceRepresentation/linkResource') as $node) {
            $url = (string)$node;
            $urls[$url] = '';
        }
        return $urls;
    }
    
    /**
     * Return a URL to a thumbnail preview of the record, if available; false
     * otherwise.
     *
     * @param array $size Size of thumbnail (small, medium or large -- small is
     * default).
     *
     * @return mixed
     * @access public
     */
    public function getThumbnail($size = 'small')
    {
        global $configArray;
        if (isset($this->fields['thumbnail']) && $this->fields['thumbnail']) {
            return $configArray['Site']['url'] . '/thumbnail.php?id=' .
                urlencode($this->getUniqueID()) . '&size=' . urlencode($size);
        }
        return false;
    }

    /**
     * Return the actual URL where a thumbnail can be retrieved, if available; false
     * otherwise.
     *
     * @param array $size Size of thumbnail (small, medium or large -- small is
     * default).
     *
     * @return mixed
     * @access public
     */
    public function getThumbnailURL($size = 'small')
    {
        global $configArray;
        if (isset($this->fields['thumbnail']) && $this->fields['thumbnail']) {
            return $this->fields['thumbnail'];
        }
        return false;
    }

    /**
     * Check if an item has holdings in order to show or hide the holdings tab
     *
     * @return bool
     * @access public
     */
    public function hasHoldings()
    {
        return false;
    }
    
    /**
     * Assign necessary Smarty variables and return a template name to
     * load in order to display the full record information on the Staff
     * View tab of the record view page.
     *
     * @return string Name of Smarty template file to display.
     * @access public
     */
    public function getStaffView()
    {
        global $interface;

        // Get Record as XML
        $xml = trim($this->fields['fullrecord']);

        // Prettify XML
        $doc = new DOMDocument;
        $doc->preserveWhiteSpace = false;
        if ($doc->loadXML($xml)) {
            $doc->formatOutput = true;
            $geshi = new GeSHi($doc->saveXML(), 'xml');
            $geshi->enable_classes(); 
            $interface->assign('record', $geshi->parse_code());
        }
        $interface->assign('details', $this->fields);
        
        return 'RecordDrivers/Lido/staff.tpl';
    }

    /**
     * Get identifier
     *
     * @return array
     * @access protected
     */
    protected function getIdentifier()
    {
        return isset($this->fields['identifier']) ? $this->fields['identifier'] : array();
    }
    
    /**
     * Get subject dates
     *
     * @return array
     * @access protected
     */
    protected function getSubjectDates() 
    {
        $results = array();
        foreach ($this->xml->xpath('lido/descriptiveMetadata/objectRelationWrap/subjectWrap/subjectSet/subject/subjectDate/displayDate') as $node) {
            $results[] = (string)$node;
        }
        return $results;
    }
    
    /**
     * Get subject places
     *
     * @return array
     * @access protected
     */
    protected function getSubjectPlaces()
    {
        $results = array();
        foreach ($this->xml->xpath('lido/descriptiveMetadata/objectRelationWrap/subjectWrap/subjectSet/subject/subjectPlace/displayPlace') as $node) {
            $results[] = (string)$node;
        }
        return $results;	
    }
    
    /**
     * Get subject details
     *
     * @return array
     * @access protected
     */
    protected function getSubjectDetails() 
    {
        $results = array();
        foreach ($this->xml->xpath("lido/descriptiveMetadata/objectIdentificationWrap/titleWrap/titleSet/appellationValue[@label='aiheen tarkenne']") as $node) {
            $results[] = (string)$node;
        }
        return $results;
    }
    
    /**
     * Get an array of alternative titles for the record.
     *
     * @return array
     * @access protected
     */
    protected function getAlternativeTitles()
    {
        $results = array();
        $mainTitle = $this->getTitle();
        foreach ($this->xml->xpath("lido/descriptiveMetadata/objectIdentificationWrap/titleWrap/titleSet/appellationValue[@label='teosnimi']") as $node) {
            if ((string)$node != $mainTitle) {
                $results[] = (string)$node;
            }
        }
        return $results;
    }

    /**
     * Get an array of events for the record.
     *
     * @return array
     * @access protected
     */
    protected function getEvents()
    {
        $events = array();
        foreach ($this->xml->xpath('/lidoWrap/lido/descriptiveMetadata/eventWrap/eventSet/event') as $node) {
            $name = isset($node->eventName->appellationValue) ? (string)$node->eventName->appellationValue : '';
            $type = isset($node->eventType->term) ? mb_strtolower((string)$node->eventType->term) : '';
            $date = isset($node->eventDate->displayDate) ? (string)$node->eventDate->displayDate : '';
            if (!$date && isset($node->eventDate->date)) {
                $startDate = (string)$node->eventDate->date->earliestDate;
                $endDate = (string)$node->eventDate->date->latestDate;
                if (strlen($startDate) == 4 && strlen($endDate) == 4) {
                    $date = "$startDate-$endDate";
                } else {
                    $startDateType = 'Y-m-d';
                    $endDateType = 'Y-m-d';
                    if (strlen($startDate) == 7) {
                        $startDateType = 'Y-m';
                    }                    
                    if (strlen($endDate) == 7) {
                        $endDateType = 'Y-m';
                    }
                    $vufindDate = new VuFindDate();
                    $date = $vufindDate->convertToDisplayDate($startDateType, $startDate);
                    if ($startDate != $endDate) {
                        $date .= '-' . $vufindDate->convertToDisplayDate($endDateType, $endDate);
                    }
                }
            }
            $method = isset($node->eventMethod->term) ? (string)$node->eventMethod->term : '';
            $materials = isset($node->eventMaterialsTech->displayMaterialsTech) ? (string)$node->eventMaterialsTech->displayMaterialsTech : '';
            $place = isset($node->eventPlace->displayPlace) ? (string)$node->eventPlace->displayPlace : '';
            $actors = array();
            if (isset($node->eventActor->actorInRole)) {
                foreach ($node->eventActor->actorInRole as $actor) {
                    if (isset($actor->actor->nameActorSet->appellationValue)) {
                        $role = isset($actor->roleActor->term) ? $actor->roleActor->term : '';
                        $actors[] = array('name'  => $actor->actor->nameActorSet->appellationValue, 'role' => $role);
                    }        
                }
            }
            $culture = isset($node->culture->term) ? (string)$node->culture->term : '';
            $description = isset($node->eventDescriptionSet->descriptiveNoteValue) ? (string)$node->eventDescriptionSet->descriptiveNoteValue : '';
            $event = array('type' => $type, 'name' => $name, 'date' => $date, 'method' => $method, 'materials' => $materials,
                'place' => $place, 'actors' => $actors, 'culture' => $culture, 'description' => $description);
            $events[$type][] = $event;
        }
        return $events;    
    }

    /**
     * Get an array of inscriptions for the record.
     *
     * @return array
     * @access protected
     */
    protected function getInscriptions()
    {
        $results = array();
        foreach ($this->xml->xpath("lido/descriptiveMetadata/objectIdentificationWrap/inscriptionsWrap/inscriptions/inscriptionDescription/descriptiveNoteValue") as $node) {
            $results[] = (string)$node;
        }
        return $results;
    }
    
}
