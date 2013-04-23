<?php
/**
 * On-the-fly metadata previewer. 
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
 * Copyright (C) Eero Heikkinen 2013
 * Copyright (C) The National Library of Finland 2013
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
 * @author   Eero Heikkinen <eero.heikkinen@gmail.com>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Record.php';
require_once 'sys/Language.php';
require_once 'RecordDrivers/Factory.php';
require_once 'sys/ResultScroller.php';
require_once 'sys/VuFindDate.php';

/**
 * Base class shared by most Record module actions.
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Eero Heikkinen <eero.heikkinen@gmail.com>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */


class Preview extends Record
{
    protected $service;
    protected $factoryClassName;
    protected $fields;

    /**
     * Constructor.
     * 
     * @param string $service Service to use for normalization (defaults to RecordManager based service)
     */
    public function __construct($service = null)
    {
        global $configArray;

        // If marc is set, we're receiving a record from Voyager's Send Record to WebVoyage function
        if (isset($_REQUEST['marc'])) {
            $marc = $_REQUEST['marc'];
            unset($_REQUEST['marc']);
            // For some strange reason recent Voyager versions double-encode the data with encodeURIComponent
            if (substr($marc, -3) == '%1D') {
                $marc = urldecode($marc);
            }
            // Voyager doesn't tell the proper encoding, so it's up to the browser to decide. 
            // Try to handle both UTF-8 and ISO-8859-1.
            $len = substr($marc, 0, 5);
            if (strlen($marc) != $len) {
                $marc = utf8_decode($marc);
            }
            $_REQUEST['data'] = $marc;
            $_REQUEST['source'] = '_marc_preview';
            $_REQUEST['format'] = 'marc';       
        }
        
        if (!isset($_REQUEST['data']) || !isset($_REQUEST['format']) || !isset($_REQUEST['source'])) {
            PEAR::raiseError('Missing parameters.');
        }
        
        if ($service !== null) {
            $this->service = $service;
        } else { // Default to RecordManager_Normalization_Service if none specified
            if (!isset($configArray['NormalizationPreview']['url'])) {
                PEAR::raiseError('No normalization service configured.');
            }
            
            include_once 'sys/RecordManagerNormalizationService.php';
            $this->service = new RecordManagerNormalizationService(
                $configArray['NormalizationPreview']['url'], 
                $_REQUEST['format'], 
                $_REQUEST['source']
            );
        }
    }
    
    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        
        $indexFields = $this->service->normalize($_REQUEST['data']);
        $this->setRecord($indexFields['id'], $indexFields);
        
        $interface->assign('dynamicTabs', true);
        $interface->setTemplate('view.tpl');
        $interface->display('layout.tpl');
    }
    
    /**
     * Returns a record driver for handling the pseudo-record. 
     * In a separate method so the static call can be mocked.
     * 
     * @param array $record The index fields to read from
     * 
     * @return Record driver instance
     */
    protected function getDriver($record) 
    {
        return RecordDriverFactory::initRecordDriver($record);
    }
}
