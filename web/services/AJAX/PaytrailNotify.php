<?php
/**
 * PaytrailNotify action.
n *
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
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */

require_once 'services/MyResearch/Fines.php';

/**
 * PaytrailNotify action.
 *
 * This is used to handle Paytrail's notify requests (see Paytrail API
 * documentation for details).
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */
class PaytrailNotify extends Action
{
    /**
     * Process incoming Paytrail notify request.
     * This should not be accessed by user.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        $fines = new Fines(true);
        $res = $fines->processPayment($_SERVER["REQUEST_URI"], false);
        if (!$res['success']) {
            error_log('PaytrailNotify error: ' . $_SERVER["REQUEST_URI"]);
            if (isset($res['msg'])) {
                error_log('   ' . $res['msg']);
            }
        }
    }
}