<?php
/**
 * PaytrailNotify action for MyResearch module
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
 * @link     http://docs.paytrail.com/ Paytrial API docoumentation
 */

require_once 'services/MyResearch/Fines.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'services/MyResearch/lib/Transaction.php';

/**
 * PaytrailNotify action for MyResearch module.
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
     * Process incoming notify request.
     * This should not be accessed by user.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        $parts = parse_url($_SERVER["REQUEST_URI"]);

        $params = array();
        foreach (($parts = explode('&', $parts['query'])) as $param) {
            list($key, $val) = explode('=', $param);
            $params[$key] = $val;            
        }

        if (!isset($params['ORDER_NUMBER'])) {
            error_log("PaytrailNotify error: invalid request.");
            error_log("   " . $_SERVER["REQUEST_URI"]);
            return;
        }

        $transactionId = $params['ORDER_NUMBER'];
        
        $tr = new Transaction();
        if (!$t = $tr->getTransaction($transactionId)) {
            error_log("PaytrailNotify error: transaction $transactionId not found");
            return;
        }
        
        $parts = explode('_', $transactionId);
        $catUsername = "{$parts[0]}_{$parts[1]}";
   
        $catalog = ConnectionManager::connectToCatalog();
        $user = array('cat_username' => $catUsername);

        if (!$paymentHandler = $catalog->getWebpaymentHandler($user)) {
            error_log("PaytrailNotify error: no payment handler found for transaction $transactionId");
            return;
        }

        $res = $paymentHandler->processResponse($user, $params);

        if (isset($res['markFeesAsPaid']) && $res['markFeesAsPaid']) {                    
            $res = $catalog->markFeesAsPaid($user, $res['amount']);

            if ($res !== true) { 
                if (!$t->setTransactionRegistrationFailed($transactionId, $res)) {
                    error_log("PaytrailNotify error: transaction ($transactionId) registration failed.");
                    error_log("   $res");
                }
            } else {
                if (!$t->setTransactionRegistered($transactionId)) {
                    error_log("PaytrailNotify error: failed to update transaction $transactionId to registered");
                }
            }
        }
    }
}

?>
