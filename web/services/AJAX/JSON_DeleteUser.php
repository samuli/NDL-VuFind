<?php
/**
 * Delete user account action for MyResearch module
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
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 */
require_once 'JSON.php';
require_once 'Crypt/generateHMAC.php';

/**
 * Delete user account for MyResearch module
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 */
class JSON_DeleteUser extends JSON
{
    /**
     * Constructor.
     *
     * @access public
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Generate and assign a token to the confirmation dialog that is displayed in a lightbox.
     *
     * @return void
     * @access public
     */
    public function init()
    {
        global $user;

        if (!$user) {
            return $this->output(array('msg' => translate('You must be logged in first')), JSON::STATUS_NEED_AUTH);
        }

        global $interface;
        $interface->assign('token', $this->getSecret());
        $page = $interface->fetch('AJAX/deleteAccount.tpl');
        $interface->assign('title', $_GET['message']);
        $interface->assign('page', $page);        

        $interface->display('AJAX/lightbox.tpl');
        exit;
    }

    /**
     * Verify the request by comparing regenerated and submitted tokens.
     * If the tokens match, anonymize user account.
     *
     * @return void
     * @access public
     */
    public function delete()
    {
        global $user;

        if (!$user) {
            return $this->output(array('msg' => translate('You must be logged in first')), JSON::STATUS_NEED_AUTH);
        }

        if (!isset($_REQUEST['token'])) {
            return $this->output(array('msg' => 'Missing token'), JSON::STATUS_ERROR);
        }

        if ($_REQUEST['token'] !== $this->getSecret()) {
            return $this->output(array('msg' => 'Invalid token'), JSON::STATUS_ERROR);
        }

        $success = $user->anonymizeAccount();

        $res = array('success' => $success);
        if (!$success) {
            $res['msg'] = translate('delete_account_failure');
        }

        $this->output($res, JSON::STATUS_OK);        
    }

    /**
     * Utility function for generating a token.
     *
     * @return string token
     * @access public
     */
    protected function getSecret()
    {
        global $user;

        $data = array('id' => $user->id, 
                      'firstname' => $user->firstname, 
                      'lastname' => $user->lastname, 
                      'email' => $user->email, 
                      'created' => $user->created
                     );

        return generateHMAC(array_keys($data), $data);
    }

}

?>
