<?php
/**
 * Command-line tool to clear expired users from the user table.
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
require_once 'services/MyResearch/lib/User.php';
require_once 'sys/ConnectionManager.php';

// Use command line value as expiration age, or default to 365.
$daysOld = isset($argv[1]) ? intval($argv[1]) : 365;

// Die if we have an invalid expiration age.
if ($daysOld < 180) {
    die("Expiration age must be at least 180 days.\n");
}

// Retrieve values from configuration file
$configArray = readConfig();

// Setup time zone
date_default_timezone_set($configArray['Site']['timezone']);

// Setup Local Database Connection
ConnectionManager::connectToDatabase();

// Delete the expired searches -- this cleans up any junk left in the database
// from old search histories that were not caught by the session garbage collector.
$user = new User();
$expired = $user->getExpiredUsers($daysOld);
if (empty($expired)) {
    die(date('Y-m-d H:i:s') . " No expired users to delete.\n");
}
while (!empty($expired)) {
    $count = count($expired);
    foreach ($expired as $oldUser) {
        $oldUser->delete();
    }
    echo date('Y-m-d H:i:s') . " {$count} expired users deleted.\n";
    $expired = $user->getExpiredUsers($daysOld);
}
?>