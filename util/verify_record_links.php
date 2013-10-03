<?php
/**
 * Command-line tool to verify record links for comments.
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
 * @package  Utilities
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/jira/browse/VUFIND-235 JIRA Ticket
 */

/**
 * Set up util environment
 */
require_once 'util.inc.php';
require_once 'services/MyResearch/lib/Comments.php';
require_once 'services/MyResearch/lib/Comments_record.php';
require_once 'sys/ConnectionManager.php';
require_once 'sys/SearchObject/Factory.php';

// Retrieve values from configuration file
$configArray = readConfig();

// Setup time zone
date_default_timezone_set($configArray['Site']['timezone']);

// Setup Local Database Connection
ConnectionManager::connectToDatabase();

// Setup index connection
ConnectionManager::connectToIndex();

// Delete the expired searches -- this cleans up any junk left in the database
// from old search histories that were not caught by the session garbage collector.
$count = 0;
$fixed = 0;
$searchObject = SearchObjectFactory::initSearchObject();
$searchObject->disableLogging();
$comments = new Comments();
if ($comments->find()) {
    while ($comments->fetch()) {
        $commentsRecord = new Comments_record();
        $commentsRecord->comment_id = $comments->id;
        if ($commentsRecord->find(true)) {
            $query = 'local_ids_str_mv:"' . addcslashes($commentsRecord->record_id, '"') . '"';
            $searchObject->setQueryString($query);
            $result = $searchObject->processSearch();
            $searchObject->close();
            if (PEAR::isError($result)) {
                PEAR::raiseError($result->getMessage());
            }

            if ($result['response']['numFound'] > 0) {
                $idArray = $result['response']['docs'][0]["local_ids_str_mv"];
                if ($comments->verifyLinks($idArray)) {
                    ++$fixed;
                }
            }
                    
        }
        ++$count;
        if ($count % 1000 == 0) {
            echo date('Y-m-d H:i:s') . " $count comments checked, $fixed fixed\n";
        }
    }
    echo date('Y-m-d H:i:s') . " $count comments checked, $fixed fixed\n";
} else {
    echo date('Y-m-d H:i:s') . " No comments available for checking\n";
}
