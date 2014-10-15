<?php
/**
 * AJAX action for the Autocomplete module.
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2010.
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
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Tuan Nguyen <tuan@yorku.ca>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'sys/Autocomplete/AutocompleteFactory.php';
require_once 'JSON.php';

/**
 * AJAX action for the Autocomplete module.
 *
 * @category VuFind
 * @package  Controller_AJAX
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @author   Tuan Nguyen <tuan@yorku.ca>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_Autocomplete extends JSON
{
    /**
     * Process search query and display suggestion as a JSON object.
     *
     * @return void
     * @access public
     */
    public function getSuggestions()
    {
        $autocomplete = true;
        $prefilters = getExtraConfigArray('prefilters');
        if (isset($_REQUEST['prefilter']) 
            && $_REQUEST['prefilter'] 
            && isset($prefilters[$_REQUEST['prefilter']])
        ) {
            $prefilter = $prefilters[$_REQUEST['prefilter']];
            if (($prefilter && $_REQUEST['prefilter'] != '-')) {
                $params = $_REQUEST;
                $params['prefiltered'] = $params['prefilter'];
                unset($params['prefilter']);
                foreach ($prefilter as $key => $value) {
                    if ($key == 'module' || $key == 'action') {
                        if ($key == 'module' && ($value != 'Search' && $value != 'Browse')) {
                            // only autocomplete on local index and browse
                            $autocomplete = false;
                            break;
                        }
                        continue;
                    }
                    if (is_array($value)) {
                        foreach ($value as $v) {
                            $params[$key][] = $v;
                        }
                    } else {
                        $params[$key] = $value;
                    }
                }
                $_REQUEST = $params;
            }
        }
        
        if ($autocomplete) {
            $this->output(
                array_values(AutocompleteFactory::getSuggestions()), JSON::STATUS_OK
            );
        } else {
            $this->output('', JSON::STATUS_ERROR);
        }
    }
}
?>
