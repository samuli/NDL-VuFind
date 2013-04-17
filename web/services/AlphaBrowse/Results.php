<?php
/**
 * Results action for AlphaBrowse module
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
 * @package  Controller_AlphaBrowse
 * @author   Mark Triggs <vufind-tech@lists.sourceforge.net>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/alphabetical_heading_browse Wiki
 */
require_once 'Home.php';

/**
 * Results action for AlphaBrowse module
 *
 * @category VuFind
 * @package  Controller_AlphaBrowse
 * @author   Mark Triggs <vufind-tech@lists.sourceforge.net>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/alphabetical_heading_browse Wiki
 */
class Results extends Home
{
    /**
     * Display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;

        // Connect to Solr:
        $db = ConnectionManager::connectToIndex();

        // Process incoming parameters:
        $source = isset($_GET['source']) ? $_GET['source'] : false;
        $from = isset($_GET['from']) ? $_GET['from'] : false;
        $rowid = isset($_GET['rowid']) ? $_GET['rowid'] : false;
        $page = (isset($_GET['page']) && is_numeric($_GET['page']))
            ? $_GET['page'] : 0;
        $limit = isset($configArray['AlphaBrowse']['page_size'])
            ? $configArray['AlphaBrowse']['page_size'] : 20;
        $extras = isset($configArray['AlphaBrowse_Extras'][$source])
            ? $configArray['AlphaBrowse_Extras'][$source] : null;

        // Normalize input for call numbers
        if (($source == 'lcc') && $from) {
            $from = $this->_normalizeCallNumber($from);
        }

        // If required parameters are present, load results:
        if ($source && (($from !== false) || ($rowid !== false))) {
            // Load Solr data or die trying:
            $result = $db->alphabeticBrowse($source, $from, $rowid, $page, $limit, $extras, true);
            $this->_checkError($result);

            // No results?  Try the previous page just in case we've gone past the
            // end of the list....
            if ($result['Browse']['totalCount'] == 0) {
                $page--;
                $result = $db->alphabeticBrowse($source, $from, $rowid, $page, $limit, $extras, true);
                $this->_checkError($result);
            }

            // Only display next/previous page links when applicable:
            $interface->assign('nextpage', $page + 1);
            $interface->assign('nextRowid', $result['Browse']['endRow']);
            if ($result['Browse']['startRow'] > 1) {
                $interface->assign('prevpage', -1);
                $interface->assign('prevRowid', $result['Browse']['startRow']);
            }

            // Send other relevant values to the template:
            $interface->assign('source', $source);
            $interface->assign('from', $from);

            // Before assigning results, lets dedupe the extras
            foreach ($result['Browse']['items'] as &$item) {
                foreach ($item['extras'] as &$extra) {
                    $extra = array_unique($extra);
                }
            }
            $interface->assign('result', $result);
        }

        // We also need to load all the same details as the basic Home action:
        parent::launch();
    }
    
    /**
     * Given an alphabrowse response, die with an error if necessary.
     *
     * @param array $result Result to check.
     *
     * @return void
     * @access private
     */
    private function _checkError($result)
    {
        if (isset($result['error'])) {
            $error = $result['error'];
            if (is_array($error)) {
                $error = $error['msg'];
            }
            // Special case --  missing alphabrowse index probably means the
            // user could use a tip about how to build the index.
            if (strstr($error, 'does not exist')
                || strstr($error, 'no such table')
                || strstr($error, 'couldn\'t find a browse index')
            ) {
                $result['error'] = "Alphabetic Browse index missing.  See " .
                    "http://vufind.org/wiki/alphabetical_heading_browse for " .
                    "details on generating the index.";
            }
            PEAR::raiseError(new PEAR_Error($error));
        }
    }

    /**
     * Given an alphabrowse seed for a call number
     *  Normalize it so that it seeds into the browse index correctly
     *  This needs to correspond with the java routine that builds the index
     *      CallNumUtils::getLCShelfkey
     *
     * @param string $callNumberSeed The input call number string
     *
     * @return string
     * @access private
     */
    private function _normalizeCallNumber($callNumberSeed)
    {
        // upper case the string
        $callNum = strtoupper(trim($callNumberSeed));
        // get the LC start letters
        $callNumArray = preg_split("/(^[A-Z]+)/", $callNum, 2, PREG_SPLIT_DELIM_CAPTURE);
        // If we matched we will have an array of size 3
        // [0] is empty, [1] is our letters, [2] is empty or has the rest of the string
        if (count($callNumArray) != 3) {
            return $callNum;
        }
        $finalCallNum = str_pad($callNumArray[1], 4, " ",  STR_PAD_RIGHT);
        // Now lets look at the rest
        if (trim($callNumArray[2]) == '') {
            // There is nothing else, return the orignal
            return $callNum;
        }
        // We should have numbers to start with
        $callNumArray = preg_split("/(^[\d|.]*\d+)/", trim($callNumArray[2]), 2, PREG_SPLIT_DELIM_CAPTURE);
        // I don't think this can happen, but
        if (count($callNumArray) != 3) {
            return $callNum;
        } else {
            // We should have a number in $callNumArray[1]
            $callNumberArray = explode('.', trim($callNumArray[1]), 2);
            // Should be 2 pieces
            if (count($callNumberArray) > 2) {
                return $callNum;
            }
            $finalCallNum .= str_pad($callNumberArray[0], 4, '0', STR_PAD_LEFT) . '.' . str_pad($callNumberArray[1], 6, '0', STR_PAD_RIGHT);
        }
        // Is there more? if not return what we have
        // Find letters and numbers, ignore .s
        while (isset($callNumArray[2]) && (trim($callNumArray[2]) != '') && (preg_match("/^.?[A-Z]/", trim($callNumArray[2])))) {
            $callNumArray = preg_split("/^\.?([A-Z]+[\d]+)/", trim($callNumArray[2]), 2, PREG_SPLIT_DELIM_CAPTURE);
            // This should be a letter followed by a number
            if (isset($callNumArray[1])) {
                $finalCallNum .= " " . substr($callNumArray[1], 0, 1) . "0." . str_pad(substr($callNumArray[1], 1), 6, '0', STR_PAD_RIGHT);
            } else {
                $finalCallNum .= " " . $callNumArray[0];
            }
        }
        if (isset($callNumArray[2]) && (trim($callNumArray[2]) != '')) {
            $callNumArray = preg_split("/^(\d+)/", trim($callNumArray[2]), 2, PREG_SPLIT_DELIM_CAPTURE);
            $finalCallNum .= " " . str_pad($callNumArray[1], 6, '0', STR_PAD_LEFT) . $callNumArray[2];
        }
        return $finalCallNum;
    }


}

?>
