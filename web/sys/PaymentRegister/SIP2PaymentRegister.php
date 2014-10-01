<?php
/**
 * SIP2 Payment Register class.
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
 * @package  PaymentRegister
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 * @link     http://multimedia.3m.com/mws/mediawebserver?mwsId=SSSSSuH8gc7nZxtUm8_9m82UevUqe17zHvTSevTSeSSSSSS--&fn=SIP2%20Protocol%20Definition.pdf
 * Protocol specification
 */

require_once 'sys/SIP2.php';
require_once 'sys/PaymentRegister/Interface.php';

/**
 * SIP2 Payment Register class.
 *
 * @category VuFind
 * @package  PaymentRegister
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 * @link     http://multimedia.3m.com/mws/mediawebserver?mwsId=SSSSSuH8gc7nZxtUm8_9m82UevUqe17zHvTSevTSeSSSSSS--&fn=SIP2%20Protocol%20Definition.pdf
 * Protocol specification
 */
class SIP2PaymentRegister implements PaymentRegisterInterface
{
    protected $config;

    /**
     * Constructor
     *
     * @param mixed $config Hash array containing module's configuration
     * as key-value pairs, or filename of the file containing the
     * configuration
     *
     * @access public
     */
    public function __construct($config)
    {
        if (is_array($config)) {
            // Load Configuration passed in
            $this->config = $config;
        } else {
            // Load Configuration from the file passed in
            $this->config = parse_ini_file('conf/'.$config, true);
        }
    }

    /**
     * Register Patron's payment.
     *
     * @param string $patron Patron's Catalog username (barcode)
     * @param string $amount Amount of the payment
     *
     * @return mixed Boolean true on success, PEAR_Error on failure
     * @access public
     */
    public function register($patron, $amount)
    {
        if (!isset($this->config['host']) || !isset($this->config['port'])
            || !isset($this->config['userID']) || !isset($this->config['password'])
            || !isset($this->config['locationCode'])
        ) {
            return new PEAR_Error('sip2_payment_connection_params_missing');
        }

        $sip = new sip2;
        $sip->error_detection = false; // TODO: parametrize?
        $sip->msgTerminator = "\r";    // TODO: parametrize?
        $sip->hostname = $this->config['host'];
        $sip->port = $this->config['port'];
        $sip->AO = ''; // institution ID, not used by Voyager.
                       //TODO: Should it nevertheless be set to some other value
                       //than SIP2's default?

        if ($sip->connect()) {
            $sip->scLocation = $this->config['locationCode'];
            $sip->UIDalgorithm = 0; //TODO: customize?
            $sip->PWDalgorithm = 0; //TODO: customize?
            $login_msg = $sip->msgLogin(
                $this->config['userID'], $this->config['password']
            );
            $login_response = $sip->get_message($login_msg);
            if (preg_match("/^94/", $login_response)) {
                $login_result = $sip->parseLoginResponse($login_response);
                if ($login_result['fixed']['Ok'] == '1') {
                    list($catSource, $catUsername) = explode('.', $patron, 2);
                    if (!empty($catUsername)) {
                        $sip->patron = $catUsername;
                    } else {
                        $sip->patron = $patron['cat_username']; // barcode
                    }
                    //TODO: what about setting some actual reasonable fee and
                    //payment types, not using just 1 and 0
                    //TODO: customize currency?
                    $feepaid_msg = $sip->msgFeePaid(1, 0, $amount, 'EUR');
                    $feepaid_response = $sip->get_message($feepaid_msg);
                    if (preg_match("/^38/", $feepaid_response)) {
                        $feepaid_result
                            = $sip->parseFeePaidResponse($feepaid_response);
                        if ($feepaid_result['fixed']['PaymentAccepted'] == 'Y') {
                            $sip->disconnect();
                            return true;
                        } else {
                            $sip->disconnect();
                            return new PEAR_Error('sip2_payment_rejected');
                        }
                    } else {
                        $sip->disconnect();
                        return new PEAR_Error('sip2_payment_failed');
                    }
                } else {
                    $sip->disconnect();
                    return new PEAR_Error('sip2_login_failed');
                }
            } else {
                $sip->disconnect();
                return new PEAR_Error('sip2_login_failed');
            }
        } else {
            return new PEAR_Error('sip2_connection_error');
        }
    }
}

?>
