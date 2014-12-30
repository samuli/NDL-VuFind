<?php
/**
 * Extended browse action for databases.
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
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'BrowseExtended.php';

/**
 * Extended browse action for databases.
 *
 * @category VuFind
 * @package  Controller_MetaLib
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Database extends BrowseExtended
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

        // Build return link back to MetaLib search
        if (isset($_SERVER['HTTP_REFERER'])) {
            $parts = parse_url($_SERVER['HTTP_REFERER']);
            $pathParts = explode('/', $parts['path']);

            $refAction = array_pop($pathParts);
            $refModule = array_pop($pathParts);

            $returnUrl = null;
            $siteUrl = $interface->get_template_vars('url');

            if ($refModule === 'MetaLib') {
                if ($refAction === 'Home') {
                    // Called from MetaLib/Home:
                    // return to same page and reset previous MetaLib search term.
                    $returnUrl = "$siteUrl/MetaLib/Home";
                    unset($_SESSION['metalibLookfor']);
                } else if ($refAction === 'Search') {
                    $fromMetaLibSearch = stripos(
                        $_SESSION['lastSearchURL'], '/MetaLib/Search'
                    ) !== false;
                    if ($fromMetaLibSearch) {
                        // Called from MetaLib/Search:
                        // Set return url to current MetaLib search.
                        $returnUrl = $_SESSION['lastSearchURL'];
                    } else {
                        // Previous search was outside MetaLib:
                        // reset search term and return to MetaLib/Home.
                        $returnUrl = "$siteUrl/MetaLib/Home";
                        unset($_SESSION['metalibLookfor']);
                    }
                }
            } else if ($refModule == 'Browse'
                && $refAction === 'Database'
                && isset($_SESSION['backToMetaLibURL'])
            ) {
                // Called from Browse/Database:
                // use stored return url.
                $returnUrl = $_SESSION['backToMetaLibURL'];
            } else {
                // Called outside Browse/Database and MetaLib:
                // no need to display link back to MetaLib.
                unset($_SESSION['backToMetaLibURL']);
                unset($_SESSION['metalibLookfor']);
            }

            if ($returnUrl && $interface->get_template_vars('metalibEnabled')) {
                $_SESSION['backToMetaLibURL'] = $returnUrl;
                $interface->assign('backToMetaLib', $returnUrl);
                $interface->assign(
                    'backToMetaLibLabel', translate('Back to MetaLib Search')
                );
            }
        } else {
            unset($_SESSION['metalibLookfor']);
        }


        if (isset($_REQUEST['refLookfor'])) {
            $_SESSION['metalibLookfor'] = $_REQUEST['refLookfor'];
        }
        $metalibSearch = null;
        if (isset($_SESSION['metalibLookfor'])
            && $_SESSION['metalibLookfor'] !== ''
        ) {
            $metalibSearch = $this->getBrowseUrl(
                'Search', $_SESSION['metalibLookfor']
            );
        } else {
            $metalibSearch = $this->getBrowseUrl('Home');
        }
        $interface->assign('metalibSearch', $metalibSearch);

        parent::launch();
    }

    /**
     * Build a url to or from MetaLib Browse.
     *
     * @param string $action  destination action (Home, Search or Browse).
     * @param string $lookfor search term or null if search term should be dropped.
     *
     * @return string URL
     * @access public
     */
    public function getBrowseUrl($action = 'Home', $lookfor = null)
    {
        global $configArray;
        global $interface;

        $fullPath = $interface->get_template_vars('fullPath');
        $parts = parse_url($fullPath);
        $params = isset($parts['query']) ? $parts['query'] : null;
        $tmp = null;

        $searchTermReplaced = false;
        if ($params) {
            $params = explode('&', $params);

            // Url parameters that should be reset when moving between Search and Browse.
            $reset = array(
                'prefilter', 'page', 'prefiltered', 'type', 'refLookfor', 'set'
            );

            $tmp = array();
            foreach ($params as $param) {
                $var = explode('=', $param);

                if (strcasecmp($var[0], 'lookfor') === 0) {
                    if ($action === 'Database') {
                        // Preserve current MetaLib search term
                        $tmp[] = "refLookfor=$var[1]";
                    } else if ($lookfor) {
                        $tmp[] = "lookfor=$lookfor";
                        $searchTermReplaced = true;
                    }
                } else if (!in_array($var[0], $reset)) {
                    $tmp[] = $param;
                }
            }
        }
        if (!$searchTermReplaced && $lookfor) {
            $tmp[] = "lookfor=$lookfor";
        }


        $url = $configArray['Site']['url'];
        $url .=  strcmp($action, 'Database') === 0 ? '/Browse' : '/MetaLib';
        $url .= "/$action?";
        if ($tmp) {
            $url .= implode('&', $tmp) . '&';
        }
        return $url;
    }

}

?>
