<?php
/**
 * Browse action for MetaLib module
 *
 * PHP version 5
 *
 * Copyright (C) Andrew Nagy 2009.
 * Copyright (C) Ere Maijala, The National Library of Finland 2012.
 * Copyright (C) Samuli Sillanpää, The National Library of Finland 2014.
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
 * @package  Controller_MetaLib
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Silanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Base.php';
require_once 'sys/Pager.php';
require_once 'services/MyResearch/Login.php';
require_once 'services/MyResearch/lib/User.php';

/**
 * Browse action for MetaLib module
 *
 * @category VuFind
 * @package  Controller_MetaLib
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Silanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Browse extends Base
{
    /**
     * Process parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;

        $this->disallowBots();

        $returnUrl = null;

        $siteUrl = $interface->get_template_vars('url');

        // Build return link back to MetaLib search
        if (isset($_SERVER['HTTP_REFERER'])) {
            $parts = parse_url($_SERVER['HTTP_REFERER']);
            $pathParts = explode('/', $parts['path']);
            
            $refAction = array_pop($pathParts);
            $refModule = array_pop($pathParts);
        
            $returnUrl = null;
            $siteUrl = $interface->get_template_vars('url');

            if ($refModule !== 'MetaLib') {
                // Called outside MetaLib: no need to display link back to MetaLib.
                unset($_SESSION['backToMetaLibURL']);
                unset($_SESSION['metalibLookfor']);
            } else {
                if ($refAction === 'Home') {
                    // Called from MetaLib/Home: return to same page and reset previous MetaLib search term.
                    $returnUrl = "$siteUrl/MetaLib/Home";
                    unset($_SESSION['metalibLookfor']);
                } else if ($refAction === 'Search') {
                    if (stripos($_SESSION['lastSearchURL'], '/MetaLib/Search') !== false) {
                        // Called from MetaLib/Search: Set return url to current MetaLib search.
                        $returnUrl = $_SESSION['lastSearchURL'];
                    } else {
                        // Previous search was outside MetaLib: reset search term and return to MetaLib/Home.
                        $returnUrl = "$siteUrl/MetaLib/Home";
                        unset($_SESSION['metalibLookfor']);
                    }
                } else if (isset($_SESSION['backToMetaLibURL'])) {
                    // Called from MetaLib/Browse: use stored return url.
                    $returnUrl = $_SESSION['backToMetaLibURL'];
                }
            }

            if ($returnUrl && $interface->get_template_vars('metalibEnabled')) {
                $_SESSION['backToMetaLibURL'] = $returnUrl;
                $interface->assign('backToMetaLib', $returnUrl);
                $interface->assign('backToMetaLibLabel', translate('Back to MetaLib Search'));
            }
        } else {
            unset($_SESSION['metalibLookfor']);
        }


       
        if (isset($_REQUEST['refLookfor'])) {
            $_SESSION['metalibLookfor'] = $_REQUEST['refLookfor'];
        }       
        $metalibSearch = null;
        if (isset($_SESSION['metalibLookfor']) && $_SESSION['metalibLookfor'] !== '') {
            $metalibSearch = $this->getBrowseUrl('Search', $_SESSION['metalibLookfor']);
        } else {
            $metalibSearch = $this->getBrowseUrl('Home');
        }
        $interface->assign('metalibSearch', $metalibSearch);



        $searchObject = SearchObjectFactory::initSearchObject('SolrMetaLibBrowse');
        $searchObject->init();
        $searchObject->setLimit(100);
        $searchObject->setSort('title');

        $result = $searchObject->processSearch(true, true);
        if (PEAR::isError($result)) {
            PEAR::raiseError($result->getMessage());
        }

        $interface->assign(
            'sideRecommendations',
            $searchObject->getRecommendationsTemplates('side')
        );

        $displayQuery = $searchObject->displayQuery();
        $interface->assign('lookfor', $displayQuery);

        // If no record found
        if ($searchObject->getResultTotal() < 1) {
            $interface->setTemplate('list-none.tpl');
        } else {
            $summary = $searchObject->getResultSummary();
            $interface->assign('recordCount', $summary['resultTotal']);
            $interface->assign('recordStart', $summary['startRecord']);
            $interface->assign('recordEnd',   $summary['endRecord']);

            $interface->assign('recordSet', $searchObject->getResultRecordHTML());

            $interface->setTemplate('browse.tpl');

            // Process Paging
            $link = $searchObject->renderLinkPageTemplate();
            $options = array('totalItems' => $summary['resultTotal'],
                             'fileName'   => $link,
                             'perPage'    => $summary['perPage']);
            $pager = new VuFindPager($options);
            $interface->assign('pageLinks', $pager->getLinks());
        }
        $searchObject->close();

        $scroller = new ResultScroller();
        $scroller->init($searchObject, $result);

        // Done, display the page
        $interface->display('layout.tpl');
    }

}

?>
