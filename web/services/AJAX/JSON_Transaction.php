<?php
/**
 * JSON handler for online payment transactions
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
 * @package  Controller_MyResearch
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */

require_once 'services/MyResearch/Fines.php';
require_once 'services/MyResearch/lib/Transaction.php';
require_once 'JSON.php';

/**
 * JSON online payment transaction handler
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class JSON_Transaction extends JSON
{
    /**
     * Register payment provided in the request.
     *
     * @return void
     * @access public
     */
    public function registerPayment()
    {        
        unset($_SESSION['no_store']);

        $url = parse_url($_REQUEST['url']);
        parse_str($url['query'], $params);
        
        $fines = new Fines();
        $res = $fines->processPayment($params);
        if ($res['success']) {
            $this->output(
                '',  JSON::STATUS_OK
            );
        } else {
            $this->output(
                isset($res['msg']) ? $res['msg'] : '',  JSON::STATUS_ERROR
            );
        }
    }
}