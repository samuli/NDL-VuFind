<?php
/**
 * Factory class for constructing online payment modules.
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
 * @package  OnlinePayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 */

require_once 'UnknownOnlinePaymentHandlerException.php';

/**
 * Factory class for constructing online payment modules.
 *
 * @category VuFind
 * @package  OnlinePayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 */
class OnlinePaymentFactory
{
    /**
     * Initialize a online payment module.
     *
     * @param string $paymentHandler The name of the module to initialize
     * @param mixed  $configuration  Hash array containing OnlinePayment module
     * configuration as key-value pairs, or filename of the file containing
     * the configuration
     *
     * @return object OnlinePayment module
     * @access public
     */
    static function initOnlinePayment($paymentHandler, $configuration
    ) {
        // Build the class name and filename.  Use basename on the filename just
        // to ensure nothing weird can happen if bad values are passed through.
        $handler = $paymentHandler;
        $filename = basename($handler . '.php');

        // Load up the handler if a legal name has been supplied.
        if (!empty($paymentHandler)
            && file_exists(dirname(__FILE__) . '/' . $filename)
        ) {
            include_once $filename;
            return new $handler($configuration);
        } else {
            throw new UnknownOnlinePaymentHandlerException(
                'Online payment handler ' . $paymentHandler . ' does not exist!'
            );
        }
    }
}