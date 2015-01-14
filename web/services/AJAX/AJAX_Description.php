<?php
/**
 * Ajax page for BTJ descriptions
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
 * @package  Controller_AJAX
 * @author   Bjarne Beckmann <bjarne.beckmann@helsinki.fi>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once 'sys/SearchObject/Solr.php';

/**
 * Ajax page for BTJ descriptions
 *
 * @category VuFind
 * @package  Controller_AJAX
 * @author   Bjarne Beckmann <bjarne.beckmann@helsinki.fi>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class AJAX_Description extends Action
{
    /**
     * Constructor.
     *
     * @access public
     */
    public function __construct()
    {
        parent::__construct();
        $_SESSION['no_store'] = true; 
    }
    
    /**
     * Get description and return html snippet
     * 
     * @return void
     */
    public function launch()
    {
        global $configArray;

        if (!isset($_GET['id']) || !$_GET['id']) {
            return;
        }
        
        $id = $_GET['id'];
        
        $localFile = 'interface/cache/description_' . urlencode($id) . '.txt';
        $maxAge = isset($configArray['Content']['summarycachetime']) ? $configArray['Content']['summarycachetime'] : 1440;

        if (false && is_readable($localFile) && time() - filemtime($localFile) < $maxAge * 60) {
            // Load local cache if available
            header('Content-type: text/plain');
            echo file_get_contents($localFile);
            return;
        } else {    
            // Get URL
            $db = ConnectionManager::connectToIndex();
            if (!($record = $db->getRecord($id))) {
                return;
            }
            $recordDriver = RecordDriverFactory::initRecordDriver($record);
            
            $url = $recordDriver->getDescriptionURL();            
            // Get, manipulate, save and display content if available
            if ($url) {
                if ($content = @file_get_contents($url)) {
                    $content = preg_replace('/.*<.B>(.*)/', '\1', $content);

                    $content = strip_tags($content);

                    // Replace line breaks with <br>
                    $content = preg_replace('/(\r|\n)+/', '\1\1', $content);
                    $content = preg_replace('/\r|\n/', '<br>', $content);
                    
                    $content = utf8_encode($content); 
                    file_put_contents($localFile, $content);


                    $content .= $content .= $content;
                    echo $content;
                }    
            }
        }
    }
}
