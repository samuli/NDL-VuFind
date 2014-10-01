<?php
/**
 * Search action for MetaLib module
 *
 * PHP version 5
 *
 * Copyright (C) Andrew Nagy 2009.
 * Copyright (C) Ere Maijala, The National Library of Finland 2012.
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
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Base.php';
require_once 'sys/Pager.php';
require_once 'services/MyResearch/Login.php';
require_once 'services/MyResearch/lib/User.php';

/**
 * Search action for MetaLib module
 *
 * @category VuFind
 * @package  Controller_MetaLib
 * @author   Andrew Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Search extends Base
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

        // Initialise SearchObject.
        $this->searchObject->init();

        $displayQuery = $this->searchObject->displayQuery();
        $interface->setPageTitle(
            translate('Search Results') .
            (empty($displayQuery) ? '' : ' - ' . htmlspecialchars($displayQuery))
        );

        $interface->assign('lookfor', $displayQuery);
        $interface->assign('searchIndex', $this->searchObject->getSearchIndex());
        $interface->assign('searchType', $this->searchObject->getSearchType());
        $interface->assign('searchSet', $this->searchObject->getSearchSet());

        $interface->assign('searchWithoutFilters', $this->searchObject->renderSearchUrlWithoutFilters());
        $interface->assign('searchWithFilters', $this->searchObject->renderSearchUrl());

        if ($this->isBrowseEnabled()) {
            include_once 'services/Browse/Database.php';
            $action = new Database();            
            $interface->assign('browseDatabases', $action->getBrowseUrl('Database'));        
        }

        if ($showGlobalFiltersNote = $interface->getGlobalFiltersNotification('MetaLib Searches')) {
            $interface->assign('showGlobalFiltersNote', $showGlobalFiltersNote);
        }

        if ($spatialDateRangeType = $this->searchObject->getSpatialDateRangeFilterType()) {
            $interface->assign('spatialDateRangeType', $spatialDateRangeType);
        }

        $filterListOthers = $this->searchObject->getFilterListOthers();
        $interface->assign(compact('filterListOthers'));
        $interface->assign('page', isset($_GET['page']) ? $_GET['page'] : 1);
        if (isset($_GET['set'])) {
            $interface->assign('set', $_GET['set']);
        }

        $interface->setTemplate('list.tpl');

        $interface->display('layout.tpl');
    }

}

?>
