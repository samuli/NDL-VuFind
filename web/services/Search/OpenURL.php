<?php
/**
 * OpenURL action for Search module
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2014.
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
 * @package  Controller_Search
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once 'Results.php';

/**
 * OpenURL action for Search module
 *
 * @category VuFind
 * @package  Controller_Search
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class OpenURL extends Action
{
    /**
     * Process incoming parameters and display search results or a record.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        $params = $this->parseOpenURL();
        $searchObject = $this->processOpenURL($params);

        // If we were asked to return just information whether something was found,
        // do it here
        if (isset($_REQUEST['vufind_response_type'])
            && $_REQUEST['vufind_response_type'] == 'resultcount'
        ) {
            echo $searchObject->getResultTotal();
            return;
        }

        // Otherwise just display results
        $results = new Results();
        $results->showResults($searchObject);
    }

    /**
     * Parse OpenURL and return a keyed array
     *
     * @return array Parsed OpenURL values
     */
    protected function parseOpenURL()
    {
        $title = '';
        $author = '';
        $isbn = '';
        $issn = '';
        $eissn = '';
        $date = '';
        $volume = '';
        $issue = '';
        $spage = '';
        $journal = false;

        if (isset($_REQUEST['url_ver']) && $_REQUEST['url_ver'] == 'Z39.88-2004') {
            // Parse OpenURL 1.0
            if (isset($_REQUEST['rft_val_fmt'])
                && $_REQUEST['rft_val_fmt'] == 'info:ofi/fmt:kev:mtx:book'
            ) {
                // Book format
                if (isset($_REQUEST['rft_btitle'])) {
                    $title = $_REQUEST['rft_btitle'];
                } else if (isset($_REQUEST['rft_title'])) {
                    $title = $_REQUEST['rft_title'];
                }

                $isbn = isset($_REQUEST['rft_isbn']) ? $_REQUEST['rft_isbn'] : '';
            } else {
                // Journal / Article / something
                $journal = true;
                if (isset($_REQUEST['rft_atitle'])) {
                    $title = $_REQUEST['rft_atitle'];
                } else if (isset($_REQUEST['rft_jtitle'])) {
                    $title = $_REQUEST['rft_jtitle'];
                } else if (isset($_REQUEST['rft_title'])) {
                    $title = $_REQUEST['rft_title'];
                }
                $eissn = isset($_REQUEST['rft_eissn']) ? $_REQUEST['rft_eissn'] : '';
            }
            if (isset($_REQUEST['rft_aulast'])) {
                $author = $_REQUEST['rft_aulast'];
            }
            if (isset($_REQUEST['rft_aufirst'])) {
                $author .= ' ' . $_REQUEST['rft_aufirst'];
            } else if (isset($_REQUEST['rft_auinit'])) {
                $author .= ' ' . $_REQUEST['rft_auinit'];
            }
            $issn = isset($_REQUEST['rft_issn']) ? $_REQUEST['rft_issn'] : '';
            $date = isset($_REQUEST['rft_date']) ? $_REQUEST['rft_date'] : '';
            $volume = isset($_REQUEST['rft_volume']) ? $_REQUEST['rft_volume'] : '';
            $issue = isset($_REQUEST['rft_issue']) ? $_REQUEST['rft_issue'] : '';
            $spage = isset($_REQUEST['rft_spage']) ? $_REQUEST['rft_spage'] : '';
        } else {
            // OpenURL 0.1
            $issn = isset($_REQUEST['issn']) ? $_REQUEST['issn'] : '';
            $date = isset($_REQUEST['date']) ? $_REQUEST['date'] : '';
            $volume = isset($_REQUEST['volume']) ? $_REQUEST['volume'] : '';
            $issue = isset($_REQUEST['issue']) ? $_REQUEST['issue'] : '';
            $spage = isset($_REQUEST['spage']) ? $_REQUEST['spage'] : '';
            $isbn = isset($_REQUEST['isbn']) ? $_REQUEST['isbn'] : '';
            if (isset($_REQUEST['atitle'])) {
                $title = $_REQUEST['atitle'];
            } else if (isset($_REQUEST['jtitle'])) {
                $title = $_REQUEST['jtitle'];
            } else if (isset($_REQUEST['btitle'])) {
                $title = $_REQUEST['btitle'];
            } else if (isset($_REQUEST['title'])) {
                $title = $_REQUEST['title'];
            }
            if (isset($_REQUEST['aulast'])) {
                $author = $_REQUEST['aulast'];
            }
            if (isset($_REQUEST['aufirst'])) {
                $author .= ' ' . $_REQUEST['aufirst'];
            } else if (isset($_REQUEST['auinit'])) {
                $author .= ' ' . $_REQUEST['auinit'];
            }
        }

        if (ISBN::isValidISBN10($isbn)
            || ISBN::isValidISBN13($isbn)
        ) {
            $isbnObj = new ISBN($isbn);
            $isbn = $isbnObj->get13();
        }

        return compact(
            'journal', 'title', 'author', 'isbn', 'issn', 'eissn', 'date', 'volume',
            'issue', 'spage'
        );
    }
    /**
     * Process the OpenURL params and try to find record(s) with them
     *
     * @param array $params Referent params
     *
     * @return object Search object
     */
    protected function processOpenURL($params)
    {
        $searchObject = SearchObjectFactory::initSearchObject();
        $searchObject->init();

        // Journal first..
        if (!$params['eissn']
            || !($results = $this->trySearch(
                $searchObject, array('issn' => $params['eissn'])
            ))
        ) {
            if ($params['issn']) {
                $results = $this->trySearch(
                    $searchObject, array('issn' => $params['issn'])
                );
            }
        }
        if ($results) {
            if ($params['date'] || $params['volume'] || $params['issue']
                || $params['spage']
            ) {
                // Ok, we found a journal. See if we can find an article too.
                $articleSearchObject = clone($searchObject);
                $query = array();

                $ids = array();
                foreach ($results['response']['docs'] as $doc) {
                    if (isset($doc['local_ids_str_mv'])) {
                        $ids = array_merge($ids, $doc['local_ids_str_mv']);
                    }
                    $ids[] = $doc['id'];
                    // Take only max 20 IDs
                    if (count($ids) >= 20) {
                        break;
                    }
                }
                $query['hierarchy_parent_id'] = $ids;

                if ($params['date']) {
                    $query['publishDate'] = $params['date'];
                }
                if ($params['volume']) {
                    $query['container_volume'] = $params['volume'];
                }
                if ($params['issue']) {
                    $query['container_issue'] = $params['issue'];
                }
                if ($params['spage']) {
                    $query['container_start_page'] = $params['spage'];
                }
                if ($this->trySearch($articleSearchObject, $query)) {
                    return $articleSearchObject;
                }

                // Broaden the search until we find something or run out of
                // options
                foreach (
                    array('container_start_page', 'issue', 'volume') as $param
                ) {
                    if (isset($query[$param])) {
                        unset($query[$param]);
                        if ($this->trySearch($articleSearchObject, $query)) {
                            return $articleSearchObject;
                        }
                    }
                }
            }
            // No article, return the journal results
            return $searchObject;
        }

        // Try to find a book or something
        if (!$params['isbn']
            || !($results = $this->trySearch(
                $searchObject, array('isbn' => $params['isbn'])
            ))
        ) {
            $query = array();
            if ($params['title']) {
                $query['title'] = $params['title'];
            }
            if ($params['author']) {
                $query['author'] = $params['author'];
            }
            if ($query) {
                $this->trySearch($searchObject, $query);
            } else {
                $this->trySearch($searchObject, array('id' => 'null'));
            }
        }

        return $searchObject;
    }

    /**
     * Try a search and return result count
     *
     * @param object &$searchObject Search object
     * @param array  $params        Search params
     *
     * @return bool|array Results array if records found, otherwise false
     */
    protected function trySearch(&$searchObject, $params)
    {
        $mapFunc = function($val) {
            return addcslashes($val, '"');
        };

        $query = '';
        foreach ($params as $key => $param) {
            if ($query) {
                $query .= ' AND ';
            }
            if (is_array($param)) {
                $imploded = implode('" OR "', array_map($mapFunc, $param));
                $query .= "$key:(\"$imploded\")";
            } else {
                if (strstr($param, ' ')) {
                    $param = "($param)";
                }
                $query .= "$key:" . addcslashes($param, '"');
            }
        }

        $searchObject->setQueryString($query);
        $result = $searchObject->processSearch(true);
        if (PEAR::isError($result)) {
            PEAR::raiseError($result->getMessage());
        }
        if ($searchObject->getResultTotal() > 0) {
            return $result;
        }
        return false;
    }
}
