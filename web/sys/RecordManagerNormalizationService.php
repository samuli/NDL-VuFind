<?php
/**
 * RecordManager Normalization Service Interface for On-the-fly metadata previewer. 
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
 * Copyright (C) Eero Heikkinen 2013
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
 * @package  Support_Classes
 * @author   Eero Heikkinen <eero.heikkinen@gmail.com>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'sys/NormalizationService.php';

/**
 * RecordManager Normalization Service implementation 
 * 
 * @category VuFind
 * @package  Support_Classes
 * @author   Eero Heikkinen <eero.heikkinen@gmail.com>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class RecordManagerNormalizationService implements NormalizationService
{
    protected $client;
    
    /**
     * Constructor.
     * 
     * @param string $url    The URL address of the remote service
     * @param string $format The record driver format to use
     * @param string $source The data source id to parse against
     */
    public function __construct($url, $format = null, $source = null)
    {
        $this->client = new Proxy_Request();
        $this->client->setMethod(HTTP_REQUEST_METHOD_POST);
        $this->client->setURL($url);
        
        if ($format !== null) {
            $this->client->addPostData('format', $format);
        }
        if ($source !== null) {
            $this->client->addPostData('source', $source);
        }
    }
    
    /**
     * Retrieve a record from a remote normalization preview service.
     * See {@link https://github.com/KDK-Alli/RecordManager/pull/7 this git pull request}
     * for a description of the contract of such a service.
     *
     * @param string $xml The XML metadata to parse
     *
     * @return array The parsed index fields as an array
     */
    public function normalize($xml)
    {
        $this->client->addPostData('data', $xml);
        
        $result = $this->client->sendRequest();
        if (!PEAR::isError($result)) {
            if ($this->client->getResponseCode() != 200) {
                PEAR::raiseError('Error generating normalization preview.');
            }
        } else {
            PEAR::raiseError($result);
        }
        return json_decode($this->client->getResponseBody(), true);
    }
}
