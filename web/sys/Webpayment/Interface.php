<?php
/**
 * Webpayment handler interface
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
 * @package  Webpayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 */

/**
 * Webpayment handler interface.
 *
 * @category VuFind
 * @package  Webpayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 */
interface WebpaymentInterface
{
    /**
     * Constructor
     *
     * @param mixed $config          Hash array containing handler's
     * configuration as key-value pairs, or filename of the file
     * containing the configuration
     * @param mixed $paymentRegister Payment Register object or null
     * if none used
     *
     * @access public
     */
    public function __construct($config, $paymentRegister);

    /**
     * Generate the webpayment form.
     *
     * @param string  $patron      Patron's catalog username (e.g. barcode)
     * @param integer $amount      Payment amount (without decimal point)
     * @param array   $fees        Array of fee objects
     * @param string  $followupUrl URL the Payment service is supposed to return
     *                             after the payment
     * @param string  $statusParam HTTP parameter name to contain the payment status
     *
     * @return string The template to use to display the webpayment form.
     * @access public
     */
    public function displayPaymentForm($patron, $amount, $fees, $followupUrl,
        $statusParam
    );

    /**
     * Fetch payment data from patron's fees.
     *
     * @param string $patron Patron's catalog username (e.g. barcode)
     * @param array  &$fees  Array of fees
     *
     * @return array Array containing payment data: is payment permitted, payment
     * amount, sum of payable fees, details on why payment has not been permitted.
     * @access public
     */
    public function getPaymentData($patron, &$fees);

    /**
     * Process the response from the payment operator service.
     *
     * @param string $patron   Patron's Catalog Username (barcode)
     * @param string $status   Webpayment status
     * @param array  $response Array containing response fields
     * received from the payment service
     *
     * @return string Payment status text to be displayed to patron
     * @access public
     */
    public function processResponse($patron, $status, $response);
}


?>
