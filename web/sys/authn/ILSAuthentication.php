<?php
/**
 * ILS authentication module.
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
 * @package  Authentication
 * @author   Franck Borel <franck.borel@gbv.de>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 */
require_once 'Authentication.php';

/**
 * ILS authentication module.
 *
 * @category VuFind
 * @package  Authentication
 * @author   Franck Borel <franck.borel@gbv.de>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_an_authentication_handler Wiki
 */
class ILSAuthentication implements Authentication
{
    const ERROR_CONFIRM_CREATE_ACCOUNT = 1;

    /**
     * Attempt to authenticate the current user.
     *
     * @return object User object if successful, PEAR_Error otherwise.
     * @access public
     */
    public function authenticate()
    {
        global $configArray;
        
        $username = $_POST['username'];
        $password = $_POST['password'];
        $loginTarget = isset($_POST['login_target']) ? $_POST['login_target'] : false;
        if ($loginTarget) {
            $username = "$loginTarget.$username";
        }
        if ($username == '' || $password == '') {
            $user = new PEAR_Error('authentication_error_blank');
        } else {
            // Connect to catalog:
            $catalog = ConnectionManager::connectToCatalog();

            if ($catalog && $catalog->status) {
                $patron = $catalog->patronLogin($username, $password);
                if ($patron && !PEAR::isError($patron)) {
                    // If the login command did not return an email address, try to fetch it from the profile information
                    if (!$patron['email']) {
                        $profile = $catalog->getMyProfile($patron);
                        $patron['email'] = $profile['email'];
                    }

                    $confirm = isset($_POST['confirm']);
                    
                    if (!$confirm) {
                        list($ILSUserExists, $user) = $this->checkIfILSUserExists($patron);
                        if (!$ILSUserExists) {
                            // First login with library card
                            
                            // Check if account is connected to existing user(s)
                            $accounts = $this->checkIfLibraryCardIsConnectedToOtherUser($patron);
                            if (!empty($accounts)) {
                                $res = array();
                                foreach ($accounts as $account) {
                                    $tmp = array('email' => $account->email);
                                    if ($account->authMethod !== null) {
                                        $tmp['authMethod'] = translate("confirm_create_account_$account->authMethod");
                                    }
                                    $res[] = $tmp;
                                }
                                // Confirm if new user account should be created
                                return new PEAR_Error('confirm_create_account', 
                                                       ILSAuthentication::ERROR_CONFIRM_CREATE_ACCOUNT, 
                                                       null,
                                                       null, 
                                                       json_encode($res)
                                                       );
                            }
                        }
                    }
                    $user = $this->_processILSUser($patron);
                } else {
                    $user = new PEAR_Error('authentication_error_invalid');
                }
            } else {
                $user = new PEAR_Error('authentication_error_technical');
            }
        } 
        return $user;
    }

    /**
     * Check if an ILS User object matching the given patron info already exists in the database.
     *
     * @param array $info User details returned by ILS driver.
     *
     * @return array with elements:     
     *   - boolean true if User object exists in the database
     *   - User object, as retrieved from the database if found, or initialized with the field 'username' othervise.
     * @access private
     */
    protected function checkIfILSUserExists($info)
    {
        global $configArray;

        include_once "services/MyResearch/lib/User.php";

        // Figure out which field of the response to use as an identifier; fail
        // if the expected field is missing or empty:
        $usernameField = isset($configArray['Authentication']['ILS_username_field'])
            ? $configArray['Authentication']['ILS_username_field'] : 'cat_username';
        if (!isset($info[$usernameField]) || empty($info[$usernameField])) {
            return new PEAR_Error('authentication_error_technical');
        }

        // Check to see if we already have an account for this user:
        $user = new User();
        $user->username = (isset($configArray['Site']['institution']) ? $configArray['Site']['institution'] . ':' : '') . $info[$usernameField];
        $insert = $user->find(true);
        return array($insert, $user);
    }

    /**
     * Check if library card is already connected to an existing User object.
     *
     * @param array $info User details returned by ILS driver.
     *
     * @return array User objects that have the given library card connected.
     * @access private
     */
    protected function checkIfLibraryCardIsConnectedToOtherUser($info)
    {
        global $configArray;

        include_once "services/MyResearch/lib/User.php";
        include_once "services/MyResearch/lib/User_account.php";

        $account = new User_account();
        $account->cat_username = $info['cat_username'];

        $users = array();

        if ($account->find(false)) {
            $fullUsername = (isset($configArray['Site']['institution']) ? $configArray['Site']['institution'] . ':' : '') . $account->cat_username;
            while ($account->fetch()) {
                $user = new User();
                $user->id = $account->user_id;
                if ($user->find(true)) {
                    if ($user->username !== $fullUsername) {
                        $users[] = $user;
                    }
                }
            }
        }
        return $users;
    }

    /**
     * Update the database using details from the ILS, then return the User object.
     *
     * @param array $info User details returned by ILS driver.
     *
     * @return object     Processed User object.
     * @access private
     */
    private function _processILSUser($info)
    {
        global $configArray;

        include_once "services/MyResearch/lib/User.php";
        
        // Check to see if we already have an account for this user:
        list($ILSUserExists, $user) = $this->checkIfILSUserExists($info);
        $insert = !$ILSUserExists;

        // No need to store the ILS password in VuFind's main password field:
        $user->password = "";
        $user->authMethod = 'ILS';

        // Update user information based on ILS data:
        $user->firstname = $info['firstname'] == null ? " " : $info['firstname'];
        $user->lastname = $info['lastname'] == null ? " " : $info['lastname'];
        $user->cat_username = $info['cat_username'] == null
            ? " " : $info['cat_username'];
        $user->cat_password = $info['cat_password'] == null
            ? " " : $info['cat_password'];
        // Special case: don't override user's email address if it's already set
        if ($insert || !trim($user->email)) {
            $user->email = $info['email']        == null ? " " : $info['email'];
        }
        $user->major = $info['major']        == null ? " " : $info['major'];
        $user->college = $info['college']      == null ? " " : $info['college'];

        // Either insert or update the database entry depending on whether or not
        // it already existed:
        $user->last_login = date('Y-m-d H:i:s');
        if ($insert) {
            $user->created = date('Y-m-d');
            $user->insert();
        } else {
            $user->update();
        }

        // Send back the updated user object:
        return $user;
    }
}
?>
