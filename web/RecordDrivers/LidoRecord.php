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
        $interface->assign('coreFormatClassifications', $this->getFormatClassifications());
        
        if (isset($this->fields['measurements'])) {
            $measurements = $this->fields['measurements'];
            
            // Special case: If configured for the datasource, augment 
            // first displayable measurement field (displayObjectMeasurements) 
            // with first 'extentMeasurement' field.
            global $configArray;
            $confParam = 'lido_augment_display_measurement_with_extent';
            $datasource = $this->fields['datasource_str_mv'];
            $datasource = $datasource[0];
            if (isset($configArray['Record'][$confParam]) &&
                isset($configArray['Record'][$confParam][$datasource]) &&
                (boolean)$configArray['Record'][$confParam][$datasource]) {
                if ($extent = $this->xml->xpath('lido/descriptiveMetadata/objectIdentificationWrap/objectMeasurementsWrap/objectMeasurementsSet/objectMeasurements/extentMeasurements')) {
                    $measurements[0] = "$measurements[0] ($extent[0])";
                }
            }
            $interface->assign('coreMeasurements', $measurements);
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
        $resultDates = $this->getResultDates();
        if ($resultDates) {
            $interface->assign('summDate', $resultDates);
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
     * Assign necessary Smarty variables and return a template name to
     * load in order to display a summary of the item suitable for use in
     * user's favorites list.
     *
     * @param object $user      User object owning tag/note metadata.
     * @param int    $listId    ID of list containing desired tags/notes (or null
     * to show tags/notes from all user's lists).
     * @param bool   $allowEdit Should we display edit controls?
     *
     * @return string           Name of Smarty template file to display.
     * @access public
     */    
    public function getListEntry($user, $listId = null, $allowEdit = true)
    {
        
        global $interface;

        $res = parent::getListEntry($user, $listId, $allowEdit);
        $resultDates = $this->getResultDates();
        if ($resultDates) {
            $interface->assign('listDate', $resultDates);
        }

        return $res;
    }
    
    /**
     * Return an associative array of image URLs associated with this record (key = URL,
     * value = description), if available; false otherwise. 
     *
     * @param string $size Size of requested images
     *
     * @return mixed
     * @access protected
     */
    public function getAllImages($size = 'large')
    {
        $urls = array();
        $url = '';
        foreach ($this->xml->xpath('/lidoWrap/lido/administrativeMetadata/resourceWrap/resourceSet/resourceRepresentation') as $node) {
            if ($node->linkResource) {
                $attributes = $node->attributes();
                if (!$attributes->type 
                    || (($size != 'large' && $attributes->type == 'thumb') || $size == 'large' && $attributes->type == 'large' || $attributes->type == 'zoomview')
                ) {
                    $url = (string)$node->linkResource;
                    $urls[$url] = '';
                }
            }
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
        $urls = $this->getAllImages($size);
        return $urls ? reset(array_keys($urls)) : false;
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
            $materials = array();
            
            if (isset($node->eventMaterialsTech->displayMaterialsTech)) {
                // Use displayMaterialTech (default)
                $materials[] = (string)$node->eventMaterialsTech->displayMaterialsTech;
            } else if (isset($node->eventMaterialsTech->materialsTech)) {                
                // display label not defined, build from materialsTech
                $materials = array();
                foreach ($node->xpath('eventMaterialsTech/materialsTech') as $materialsTech) {
                    if ($terms = $materialsTech->xpath('termMaterialsTech/term')) {
                        foreach ($terms as $term) {
                            $label = null;
                            $attributes = $term->attributes();
                            if (isset($attributes->label)) {
                                // Musketti
                                $label = $attributes->label;
                            } else if (isset($materialsTech->extentMaterialsTech)) {
                                // Siiri
                                $label = $materialsTech->extentMaterialsTech;
                            }
                            if ($label) {
                                $term = "$label: $term";
                            }
                            $materials[] = $term;
                        }
                    }
                }
            }

            $place = isset($node->eventPlace->displayPlace) ? (string)$node->eventPlace->displayPlace : '';
            $places = array();
            if (!$place) {
                if (isset($node->eventPlace->place->namePlaceSet)) {
                    $eventPlace = array();
                    foreach ($node->eventPlace->place->namePlaceSet as $namePlaceSet) {
                        if (trim((string)$namePlaceSet->appellationValue) != '') {
                            $eventPlace[] = isset($namePlaceSet) ? trim((string)$namePlaceSet->appellationValue) : '';
                        }
                    }
                    $places[] = implode(', ', $eventPlace);
                }
                if (isset($node->eventPlace->place->partOfPlace)) {
                    foreach ($node->eventPlace->place->partOfPlace as $partOfPlace) {
                        $partOfPlaceName = array(); 
                        while (isset($partOfPlace->namePlaceSet)):
                        if (trim((string)$partOfPlace->namePlaceSet->appellationValue) != '') {
                            $partOfPlaceName[] = isset($partOfPlace->namePlaceSet->appellationValue) ? trim((string)$partOfPlace->namePlaceSet->appellationValue) : '';                            
                        }
                        $partOfPlace = $partOfPlace->partOfPlace;
                        endwhile;
                        $places[] = implode(', ', $partOfPlaceName);
                    }
                }
            } else {
                $places[] = $place;    
            }
            $actors = array();
            if (isset($node->eventActor)) {
                foreach ($node->eventActor as $actor) {
                    if (isset($actor->actorInRole->actor->nameActorSet->appellationValue) && trim($actor->actorInRole->actor->nameActorSet->appellationValue) != '') {
                        $role = isset($actor->actorInRole->roleActor->term) ? $actor->actorInRole->roleActor->term : '';
                        $actors[] = array('name'  => $actor->actorInRole->actor->nameActorSet->appellationValue, 'role' => $role);
                    }        
                }
            }
            $culture = isset($node->culture->term) ? (string)$node->culture->term : '';
            $description = isset($node->eventDescriptionSet->descriptiveNoteValue) ? (string)$node->eventDescriptionSet->descriptiveNoteValue : '';
            $event = array('type' => $type, 'name' => $name, 'date' => $date, 'method' => $method, 'materials' => $materials,
                'place' => $places, 'actors' => $actors, 'culture' => $culture, 'description' => $description);
            $events[$type][] = $event;
        }
        return $events;    
    }

    /**
     * Get an array of format classifications for the record.
     *
     * @return array
     * @access protected
     */
    protected function getFormatClassifications()
    {
        $results = array();
        foreach ($this->xml->xpath("lido/descriptiveMetadata/objectClassificationWrap") as $node) {
            if ((string)$node->objectWorkTypeWrap->objectWorkType->term == 'rakennetun ympäristön kohde') {
                foreach ($node->classificationWrap->classification as $classificationNode) {
                    $type = null;
                    $attributes = $classificationNode->attributes();
                    $type = isset($attributes->type) ? $attributes->type : '';
                    if ($type) {
                        $results[] = (string)$classificationNode->term . ' (' . $type . ')';
                    } else {
                        $results[] = (string)$classificationNode->term;
                    }
                }
            } else if ((string)$node->objectWorkTypeWrap->objectWorkType->term == 'arkeologinen kohde') {
                foreach ($node->classificationWrap->classification->term as $classificationNode) {
                    $label = null;
                    $attributes = $classificationNode->attributes();
                    $label = isset($attributes->label) ? $attributes->label : '';
                    if ($label) {
                        $results[] = (string)$classificationNode . ' (' . $label . ')';
                    } else {
                        $results[] = (string)$classificationNode;
                    }
                }                
            }
        }     
        return $results;
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
            $label = null;
            $attributes = $node->attributes();
            $label = isset($attributes->label) ? $attributes->label : '';
            if ($label) {
                $results[] = (string)$node . ' (' . $label . ')';
            } else {
                $results[] = (string)$node;  

            }
        }    
        return $results;
    }
    
    /**
     * Get an array of dates for results list display
     *
     * @return array
     * @access protected
     */
    protected function getResultDates()
    {
        if (!isset($this->fields['creation_sdaterange'])) {
            return null;
        }
        $range = explode(' ', $this->fields['creation_sdaterange'], 2);
        if (!$range) {
            return null;
        }
        $range[0] *= 86400;
        $range[1] *= 86400;
        $startDate = new DateTime("@{$range[0]}");
        $endDate = new DateTime("@{$range[1]}");
        if ($startDate->format('m') == 1 && $startDate->format('d') == 1 
            && $endDate->format('m') == 12 && $endDate->format('d') == 31
        ) {
            return array($startDate->format('Y'), $endDate->format('Y'));
        }
        $date = new VuFindDate();
        return array(
            $date->convertToDisplayDate('U', $range[0]), 
            $date->convertToDisplayDate('U', $range[1])
        );        
    }
    
}
