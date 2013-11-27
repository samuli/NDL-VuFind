<?php
/**
 * Ajax page for Hierarchy Tree
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
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
 * @author   Luke O'Sullivan <l.osullivan@swansea.ac.uk>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
/**
 * Home action for Record module
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Luke O'Sullivan <l.osullivan@swansea.ac.uk>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class AJAX_HierarchyTree extends Action
{

    /**
     * Constructor.
     *
     * @access public
     */
    public function __construct()
    {
        parent::__construct();
        // Setup Search Engine Connection
        $this->db = ConnectionManager::connectToIndex();
        $_SESSION['no_store'] = true; 
    }

    /**
     * Process parameters and display the response.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        // Call the method specified by the 'method' parameter as long as it is
        // valid and will not result in an infinite loop!
        if ($_GET['method'] != 'launch'
            && $_GET['method'] != '__construct'
            && is_callable(array($this, $_GET['method']))
        ) {
            $this->$_GET['method']();
        } else {
            // Error
        }
    }

    /**
     * Output JSON
     *
     * @param string $json A JSON string
     *
     * @return void
     * @access public
     */
    public function outputJSON($json)
    {
        header("Content-Type: application/json");
        echo $json;
    }

    /** 
     * Outputs Json for a reverse path in the hierarchy
     *
     * @return void
     * @access public
     */
    public function getHierarchyTree($query = '', $returnArray = array(), $level = 0)
    {
        $query = ($query == '') ? $_GET['q'] : $query;
        if ($results = $this->db->getRecord($query)) {

            // If record has no parent, it is the root. 
            if (!isset($results['hierarchy_parent_id'][0])) {

                // Add root data to the array
                $returnArray['root'][] = array($results['id'], $results['title'], true, true);

                // Reverse the array and return the data in JSON format
                $returnArray = array_reverse($returnArray);
                $jsonString = json_encode($returnArray);
                $this->outputJSON($jsonString);
                return;
            }

            $parent = $results['hierarchy_parent_id'][0];
            $query = 'hierarchy_parent_id:"' . addcslashes($parent, '"') . '"';

            // If result parent != hierarchy top, this is the outermost leaf level
            $isBranch = ($results['hierarchy_parent_id'][0] == $results['hierarchy_top_id'][0]);

            if ($search = $this->db->search($query, null, null, 0, 999)) {

                if (isset($search['response']['docs'])) {
                    foreach ($search['response']['docs'] as $doc) {

                        
                        $open = ($doc['id'] == $results['id'] && !$isBranch);
                        $returnArray[$parent][] = array($doc['id'], $doc['title'], $isBranch, $open);
                    }
                }

                $this->getHierarchyTree($parent, $returnArray, $level+1);
            }
        }
    }

    /** 
     * Outputs Json for a single hierarchy branch
     *
     * @return void
     * @access public
     */
    public function getHierarchyBranch($getNumber = 10)
    {
        $q = isset($_GET['q'])? $_GET['q'] : "";
        $pos = isset($_GET['pos'])? $_GET['pos'] : 0;
        if ($pos != 0) { // If offset set, remove limit
            $getNumber = 9999;
        }
        $query = 'hierarchy_parent_id:"' . addcslashes($q, '"') . '"';
        $returnArray = array();
        $returnArray[] = array('false', ''); // Results clipped? (default=false, no position)


        if ($re = $this->db->search($query, null, null, $pos, $getNumber)) {
            if (isset($re['response']['docs'])) {
                foreach ($re['response']['docs'] as $doc) {
                    $isBranch = ($doc['hierarchy_parent_id'] == $doc['hierarchy_top_id']);
                    $returnArray[] = array($doc['id'], $doc['title'], $isBranch);
                }

                // Check if results > limit
                if ($re['response']['numFound'] > $getNumber && 
                    count($re['response']['docs']) >= $getNumber) {
    
                    $returnArray[0] = array('true', $getNumber + $pos);
                }
            }
        }

        $jsonString = json_encode($returnArray);
        $this->outputJSON($jsonString);
    }
}

?>
