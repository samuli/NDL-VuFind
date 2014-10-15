<?php
/**
 * Base class shared by most Record module actions.
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
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';

require_once 'sys/Language.php';

require_once 'RecordDrivers/Factory.php';
require_once 'sys/ResultScroller.php';
require_once 'sys/VuFindDate.php';

/**
 * Base class shared by most Record module actions.
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Record extends Action
{
    protected $recordDriver;
    protected $cacheId;
    protected $db;
    protected $catalog;
    protected $errorMsg;
    protected $infoMsg;
    protected $hasHoldings;

    /**
     * Constructor
     *
     * @access public
     */
    public function __construct()
    {
        global $configArray;
        global $user;
        global $interface;

        //$interface->caching = 1;

        // Setup Search Engine Connection
        $this->db = ConnectionManager::connectToIndex();

        // Connect to Database
        $this->catalog = ConnectionManager::connectToCatalog();

        // Set up object for formatting dates and times:
        $this->dateFormat = new VuFindDate();

        // Register Library Catalog Account
        if (isset($_POST['submit']) && !empty($_POST['submit'])) {
            if (isset($_POST['cat_username'])
                && isset($_POST['cat_password'])
            ) {
                $username = $_POST['cat_username'];
                if (isset($_POST['login_target'])) {
                    $username = $_POST['login_target'] . '.' . $username;
                }
                $result = UserAccount::processCatalogLogin(
                    $username, $_POST['cat_password']
                );
                if ($result) {
                    $interface->assign('user', $user);
                } else {
                    $interface->assign('loginError', 'Invalid Patron Login');
                }
            }
        }

        // Retrieve the record from the index
        if (!($record = $this->db->getRecord($_REQUEST['id']))) {
            PEAR::raiseError(new PEAR_Error('Record Does Not Exist'));
        }

        $this->setRecord($_REQUEST['id'], $record);
    }

    /**
     * Record a record hit to the statistics index when stat tracking is enabled;
     * this is called by the Home action.
     *
     * @return void
     * @access public
     */
    public function recordHit()
    {
        global $configArray;

        if ($configArray['Statistics']['enabled']) {
            // Setup Statistics Index Connection
            $solrStats = ConnectionManager::connectToIndex('SolrStats');

            // Save Record View
            $solrStats->saveRecordView($this->recordDriver->getUniqueID());
            unset($solrStats);
        }
    }

    /**
     * Initialize the record
     *
     * @param string $id     Record ID
     * @param array  $record Record data
     *
     * @return void
     */
    protected function setRecord($id, $record)
    {
        global $interface;
        global $configArray;
        global $user;

        // Store ID of current record (this is needed to generate appropriate
        // links, and it is independent of which record driver gets used).
        $interface->assign('id', $_REQUEST['id']);

        $this->recordDriver = RecordDriverFactory::initRecordDriver($record);

        // Define Default Tab
        $defaultTab = isset($configArray['Site']['defaultRecordTab']) ?
            $configArray['Site']['defaultRecordTab'] : 'Holdings';

        // Don't let bots crawl holdings
        if (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/bot|crawl|slurp|spider/i', $_SERVER['HTTP_USER_AGENT'])) {
            $this->hasHoldings = false;
            $interface->assign('hasHoldings', false);
            $defaultTab = 'Description';
        } else {
            if (isset($configArray['Site']['hideHoldingsTabWhenEmpty'])
                && $configArray['Site']['hideHoldingsTabWhenEmpty']
            ) {
                $showHoldingsTab = $this->recordDriver->hasHoldings();
                $interface->assign('hasHoldings', $showHoldingsTab);
                $defaultTab =  (!$showHoldingsTab && $defaultTab == "Holdings") ?
                    "Description" : $defaultTab;
            } else {
                $interface->assign('hasHoldings', true);
            }
        }

        $tab = (isset($_GET['action'])) ? $_GET['action'] : $defaultTab;
        $interface->assign('tab', $tab);

        // Check if ajax tabs are active
        if (isset($configArray['Site']['ajaxRecordTabs']) && $configArray['Site']['ajaxRecordTabs']) {
            $interface->assign('dynamicTabs', true);
        }

        if ($this->recordDriver->hasRDF()) {
            $interface->assign(
                'addHeader', '<link rel="alternate" type="application/rdf+xml" ' .
                'title="RDF Representation" href="' . $configArray['Site']['url'] .
                '/Record/' . urlencode($_REQUEST['id']) . '/RDF" />' . "\n"
            );
        }
        $interface->assign('coreMetadata', $this->recordDriver->getCoreMetadata());

        // Determine whether to display book previews
        if (isset($configArray['Content']['previews'])) {
            $interface->assignPreviews();
        }

        // Determine whether comments or reviews are enabled
        if (isset($configArray['Site']['userComments']) && $configArray['Site']['userComments']) {
            $interface->assign('userCommentsEnabled', true);
        }

        // Ratings for libraries, comments for museums and archives
        if ($this->recordDriver->getSector() == 'lib') {
            $interface->assign('ratings', true);
        }

        if (isset($configArray['Site']['userComments']) && $configArray['Site']['userComments']) {
            // Get number of comments for this record
            include_once 'services/MyResearch/lib/Comments.php';
            $comments = new Comments();
            $commentCount = $comments->getCommentCount($_REQUEST['id']);
            $interface->assign(compact('commentCount'));
            $recordRating = $comments->getAverageRating($_REQUEST['id']);
            $interface->assign(compact('recordRating'));
        }

        // Determine whether to include script tag for syndetics plus
        if (isset($configArray['Syndetics']['plus'])
            && $configArray['Syndetics']['plus']
            && isset($configArray['Syndetics']['plus_id'])
        ) {
            $interface->assign(
                'syndetics_plus_js',
                "http://plus.syndetics.com/widget.php?id=" .
                $configArray['Syndetics']['plus_id']
            );
        }

        // Set flags that control which tabs are displayed:
        if (isset($configArray['Content']['reviews'])) {
            $interface->assign('hasReviews', $this->recordDriver->hasReviews());
        }
        if (isset($configArray['Content']['excerpts'])) {
            $interface->assign('hasExcerpt', $this->recordDriver->hasExcerpt());
        }

        //Hierarchy Tree
        $interface->assign(
            'hasHierarchyTree', $this->recordDriver->hasHierarchyTree()
        );

        $interface->assign('hasTOC', $this->recordDriver->hasTOC());
        $interface->assign('hasMap', $this->recordDriver->hasMap());
        $this->recordDriver->getTOC();

        $interface->assign(
            'extendedMetadata', $this->recordDriver->getExtendedMetadata()
        );

        // Assign the next/previous record data:
        $scroller = new ResultScroller();
        $scrollData = $scroller->getScrollData($_REQUEST['id']);
        $interface->assign('previousRecord', $scrollData['previousRecord']);
        $interface->assign('nextRecord', $scrollData['nextRecord']);
        $interface->assign('currentRecordPosition', $scrollData['currentPosition']);
        $interface->assign('resultTotal', $scrollData['resultTotal']);

        // Retrieve User Search History
        $lastsearch = isset($_SESSION['lastSearchURL']) ? $_SESSION['lastSearchURL'] : false;
        $interface->assign('lastsearch', $lastsearch);

        if ($lastsearch) {
            // Retrieve active filters and assign them to searchbox template.
            // Since SearchObjects use $_REQUEST to init filters, we stash the current $_REQUEST
            // and fill it temporarily with URL parameters from last search.

            $query = parse_url($lastsearch, PHP_URL_QUERY);
            parse_str($query, $vars);
            $oldReq = $_REQUEST;

            $_REQUEST = $vars;

            $searchObject = SearchObjectFactory::initSearchObject();
            $searchObject->init();
            // This is needed for facet labels
            $searchObject->initRecommendations();

            $filterList = $searchObject->getFilterList();
            $filterListOthers = $searchObject->getFilterListOthers();
            $checkboxFilters = $searchObject->getCheckboxFacets();
            $filterUrlParams = $searchObject->getfilterUrlParams();

            if (isset($vars['lookfor'])) {
                $interface->assign('lookfor', $vars['lookfor']);
            }
            $interface->assign('filterUrlParam', $filterUrlParams[0]);
            $interface->assign(compact('filterList'));
            $interface->assign(compact('filterListOthers'));
            $interface->assign('checkboxFilters', $checkboxFilters);

            if (isset($_SERVER['HTTP_REFERER'])) {
                // Set followup module & action for next search
                $parts = parse_url($_SERVER['HTTP_REFERER']);
                $pathParts = explode('/', $parts['path']);

                $refAction = array_pop($pathParts);
                $refModule = array_pop($pathParts);

                $interface->assign('followupSearchModule', $refModule);
                $interface->assign('followupSearchAction', $refAction);
            }

            $_REQUEST = $oldReq;
        }

        $interface->assign(
            'lastsearchdisplayquery',
            isset($_SESSION['lastSearchDisplayQuery']) ? $_SESSION['lastSearchDisplayQuery'] : false
        );

        $interface->assign(
            'searchId',
            isset($_SESSION['lastSearchID']) ? $_SESSION['lastSearchID'] : false
        );

        $interface->assign(
            'searchType',
            isset($_SESSION['searchType']) ? $_SESSION['searchType'] : false
        );

        unset($_SESSION['lastSearchID']);
        unset($_SESSION['searchType']);

        // Send down text for inclusion in breadcrumbs
        $interface->assign('breadcrumbText', $this->recordDriver->getBreadcrumb());

        // Send down OpenURL for COinS use:
        $interface->assign('openURL', $this->recordDriver->getOpenURL());

        // Whether RSI is enabled
        if (isset($configArray['OpenURL']['use_rsi']) && $configArray['OpenURL']['use_rsi']) {
            $interface->assign('rsi', true);
        }

        // Whether embedded openurl autocheck is enabled
        if (isset($configArray['OpenURL']['autocheck']) && $configArray['OpenURL']['autocheck']) {
            $interface->assign('openUrlAutoCheck', true);
        }

        // Send down legal export formats (if any):
        $interface->assign('exportFormats', $this->recordDriver->getExportFormats());

        // Set AddThis User
        $interface->assign(
            'addThis', isset($configArray['AddThis']['key'])
            ? $configArray['AddThis']['key'] : false
        );

        // Set Proxy URL
        if (isset($configArray['EZproxy']['host'])) {
            $interface->assign('proxy', $configArray['EZproxy']['host']);
        }

        // Get Messages
        $this->infoMsg = isset($_GET['infoMsg']) ? $_GET['infoMsg'] : false;
        $this->errorMsg = isset($_GET['errorMsg']) ? $_GET['errorMsg'] : false;

        // Set bX flag
        $interface->assign(
            'bXEnabled', isset($configArray['bX']['token'])
            ? true : false
        );
        
        // Get Record source driver
        $catalog = $this->catalog;
        $driver = is_callable(array($catalog, 'getSourceDriver')) ?
            $this->catalog->getSourceDriver($_REQUEST['id']) : '';

        $interface->assign('driver', $driver);
    }
}

?>
