<?php
/**
 * SaveSearch action for MyResearch module
 *
 * PHP version 5
 *
 * Copyright (C) Villanova University 2007.
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
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'services/MyResearch/MyResearch.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'services/MyResearch/lib/Search.php';
require_once 'services/MyResearch/lib/Due_date_reminder.php';
require_once 'Crypt/generateHMAC.php';

/**
 * SaveSearch action for MyResearch module
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Kalle Pyykkönen <kalle.pyykkonen@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Unsubscribe extends MyResearch
{
    /**
     * Constructor
     *
     * @access public
     */
    public function __construct()
    {
        parent::__construct(true);
    }

    /**
     * Process parameters and remove the subscription.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $configArray;

        if (!isset($_REQUEST['id']) || !isset($_REQUEST['key']) || !isset($_REQUEST['type'])) {
            PEAR::raiseError('Can\'t unsubscribe');
            return;
        }

        $id = $_REQUEST['id'];
        $key = $_REQUEST['key'];
        $type = $_REQUEST['type'];

        // display confirm dialog
        if (!isset($_REQUEST['confirm']) || !$_REQUEST['confirm']) {
            $params = array('id' => $id, 'type' => $type, 'key' => $key, 'confirm' => true);
            $unsubscribeUrl = $configArray['Site']['url'] . '/MyResearch/Unsubscribe?' . http_build_query($params);
            $interface->assign('unsubscribeUrl', $unsubscribeUrl);
            $interface->setTemplate('unsubscribe.tpl');
            $interface->display('layout.tpl');
        } else {
            $success = false;
            // scheduled alert
            if ($type == 'alert') {
                $search = new SearchEntry();
                if ($search->get($id)) {
                    $user = new User();
                    if ($user->get($search->user_id)) {
                        $secret = $this->_getSecret($user, $id);
                        if ($key === $secret) {
                            $search->schedule = 0;
                            $search->update();
                            $success = true;
                        }
                    }
                }
            } else if ($type == 'reminder') { // due date reminder
                $user = new User();
                if ($user->get($id)) {
                    $secret = $this->_getSecret($user, $id);
                    if ($key === $secret) {
                        $user->due_date_reminder = 0;
                        $user->update();
                        $success = true;
                    }
                }
            }

            if ($success) {
                $interface->assign('success', true);
                $interface->setTemplate('unsubscribe.tpl');
                $interface->display('layout.tpl');
            } else {
                PEAR::raiseError('Can\'t unsubscribe');
            }
        }
    }

    /**
     * Utility function for generating a token.
     *
     * @param object $user User object
     * @param string $id   Record ID
     *
     * @return string token
     * @access public
     */
    private function _getSecret($user, $id)
    {
        $data = array('id' => $id,
                      'user_id' => $user->id,
                      'created' => $user->created
                     );

        $secret = generateHMAC(array_keys($data), $data);
        return($secret);
    }
}

?>