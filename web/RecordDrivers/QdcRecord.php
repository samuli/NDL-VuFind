<?php
/**
 * Qualified Dublin Core Record Driver
 *
 * PHP version 5
 *
 * Copyright (C) Anna Pienimäki 2013.
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
 * @author   Anna Pienimäki <anna.pienimaki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/other_than_marc Wiki
 */
require_once 'RecordDrivers/IndexRecord.php';

/**
 * Qualified Dublin Core Record Driver
 *
 * This class is designed to handle Qualified Dublin Core records.
 *
 * @category VuFind
 * @package  RecordDrivers
 * @author   Anna Pienimäki <anna.pienimaki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/other_than_marc Wiki
 */
class QdcRecord extends IndexRecord
{
    // QDC record
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
        $interface->assign('coreAbstracts', $this->getAbstracts());

        return 'RecordDrivers/Qdc/core.tpl';
    }

    /**
     * Return an associative array of abstracts associated with this record, if available; false otherwise.
     *
     * @return array of abstracts using abstract languages as keys
     * @access protected
     */
    protected function getAbstracts()
    {
        $abstractValues = array();
        $abstracts = array();
        $abstract = '';
        $lang = '';
        foreach ($this->xml->xpath('/qualifieddc/abstract') as $node) {
            $abstract = (string)$node;
            $lang = (string)$node['lang'];
            if ($lang == "en") {
                $lang .= "-gb";
            }
            $abstracts[$lang] = $abstract;
        }

        return $abstracts;
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
        return empty($this->fields['thumbnail'])
            ? false : $this->fields['thumbnail'];
    }
}
