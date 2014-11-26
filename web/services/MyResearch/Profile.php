<?php
/**
 * Profile action for MyResearch module
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
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'services/MyResearch/MyResearch.php';
require_once 'services/MyResearch/Login.php';
require_once 'sys/Mailer.php';

/**
 * Profile action for MyResearch module
 *
 * @category VuFind
 * @package  Controller_MyResearch
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class Profile extends MyResearch
{
    /**
     * Process parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $configArray;
        global $interface;
        global $user;

        if (UserAccount::isLoggedIn()) {
            // Update email address
            if (isset($_POST['email'])) {
                if ($user->changeEmailAddress($_POST['email'])) {
                    $interface->assign('userMsg', 'profile_update');
                }
            }
            $interface->assign('email', $user->email);

            // Update due date reminder
            if (isset($_POST['due_date_reminder'])) {
                $interval = $_POST['due_date_reminder'];
                if (is_numeric($interval) && $interval >= 0) {
                    if ($user->changeDueDateReminder($_POST['due_date_reminder'])) {
                        $interface->assign('userMsg', 'profile_update');
                    }
                }
            }
            $interface->assign('dueDateReminder', $user->due_date_reminder);

            // Change Password
            if (isset($_POST['oldPassword'])
                && isset($_POST['newPassword'])
                && isset($_POST['newPassword2'])
            ) {
                if ($_POST['newPassword'] !== $_POST['newPassword2']) {
                    $interface->assign(
                        'userError', 'change_password_error_verification'
                    );
                } else {
                    $result = $this->changePassword(
                        $_POST['oldPassword'], $_POST['newPassword']
                    );
                    if (PEAR::isError($result)) {
                        $interface->assign('userError', $result->getMessage());
                    } else {
                        if ($result['success']) {
                            $interface->assign('userMsg', 'change_password_ok');
                            $user->changeCatalogPassword($_POST['newPassword']);
                        } else {
                            $interface->assign('userError', $result['status']);
                        }
                    }
                }
            }
        }

        // Get My Profile
        if ($patron = UserAccount::catalogLogin()) {
            if (PEAR::isError($patron)) {
                $this->handleCatalogError($patron);
            } else {
                if (isset($_POST['home_library']) &&  $_POST['home_library'] != "") {
                    $home_library = $_POST['home_library'];
                    $updateProfile = $user->changeHomeLibrary($home_library);
                    if ($updateProfile == true) {
                        $interface->assign('userMsg', 'profile_update');
                    }
                }
                if (isset($_POST['phone_number'])) {
                    $phoneNumber = trim($_POST['phone_number']);
                    if (preg_match('/^[\+]?[ \d\-]+\d+$/', $phoneNumber)) {
                        $result = $this->catalog->setPhoneNumber(
                            $patron,  $phoneNumber
                        );
                        if ($result['success']) {
                            $interface->assign('userMsg', 'profile_update');
                            $patron['phone'] = $phoneNumber;
                        } else {
                            $interface->assign('userError', $result['sys_message']);
                        }
                    } else {
                        $interface->assign('userError', 'Phone Number is invalid');
                    }
                }
                if (isset($_POST['email_address'])) {
                    $email = trim($_POST['email_address']);
                    if (Mail_RFC822::isValidInetAddress($email)) {
                        $result = $this->catalog->setEmailAddress($patron, $email);
                        if ($result['success']) {
                            $interface->assign('userMsg', 'profile_update');
                            $patron['email'] = $email;
                        } else {
                            $interface->assign('userError', $result['sys_message']);
                        }
                    } else {
                        $interface->assign('userError', 'Email address is invalid');
                    }
                }
                if (isset($_POST['changeAddressRequest'])) {
                    $_POST  = filter_input_array(INPUT_POST, FILTER_SANITIZE_STRING);
                    $interface->assign('email', $_POST['email']);
                    $interface->assign('name', $_POST['name']);
                    $interface->assign('library', $_POST['library']);
                    $interface->assign('address', $_POST['address']);
                    $interface->assign('zip', $_POST['zip']);
                    $interface->assign('username', $patron['cat_username']);
                    $interface->display('/MyResearch/change-address.tpl');
                    return;
                }
            
                if (isset($_POST['changeAddressLine1'])
                    && isset($_POST['changeAddressZip'])
                ) {
                    $driver = explode('.', $patron['cat_username'], 2);
                    $datasources = getExtraConfigArray('datasources');
                    $to = (is_array($driver)
                        && isset($driver[0])
                        && $datasources[$driver[0]])
                        && isset($datasources[$driver[0]]['feedbackEmail'])
                        ? $datasources[$driver[0]]['feedbackEmail']
                        : $configArray['Site']['email'];
                    $result = $this->sendEmail(
                        filter_input_array(INPUT_POST, FILTER_SANITIZE_STRING), $to
                    );
                    if (!PEAR::isError($result)) {
                        $interface->assign('userMsg', 'address_change_email_sent');
                    } else {
                        $interface->assign('userError', $result->getMessage());
                    }
                }
                $result = $this->catalog->getMyProfile($patron);
                if (!PEAR::isError($result)) {
                    $result['home_library'] = $user->home_library;
                    $libs = $this->catalog->getPickUpLocations($patron);
                    $defaultPickUpLocation
                        = $this->catalog->getDefaultPickUpLocation($patron);
                    $interface->assign(
                        'defaultPickUpLocation',
                        $defaultPickUpLocation
                    );
                    $interface->assign('pickup', $libs);
                    $interface->assign('profile', $result);
                }
                $result = $this->catalog->checkFunction('changePassword');
                if ($result !== false) {
                    $interface->assign('changePassword', $result);
                }
                $driver = isset($patron['driver']) ? $patron['driver'] : '';
                $interface->assign('driver', $driver);
            }
        } else {
            Login::setupLoginFormVars();
        }

        $interface->assign(
            'hideDueDateReminder',
            isset($configArray['Site']['hideDueDateReminder'])
            && (boolean)$configArray['Site']['hideDueDateReminder']
        );

        $interface->assign(
            'hideProfileEmailAddress',
            isset($configArray['Site']['hideProfileEmailAddress'])
            && (boolean)$configArray['Site']['hideProfileEmailAddress']
        );

        $interface->setTemplate('profile.tpl');
        $interface->setPageTitle('My Profile');
        $interface->display('layout.tpl');
    }

    /**
     * Change patron's password (PIN code)
     *
     * @param string $oldPassword Old password for verification
     * @param string $newPassword New password
     *
     * @return mixed Array of information on success/failure, PEAR_Error on error
     */
    protected function changePassword($oldPassword, $newPassword)
    {
        if ($patron = UserAccount::catalogLogin()) {
            if (PEAR::isError($patron)) {
                PEAR::raiseError($patron);
            }
            $data = array(
                'patron' => $patron,
                'oldPassword' => $oldPassword,
                'newPassword' => $newPassword
            );
            return $this->catalog->changePassword($data);
        }
    }

    /**
     * Send address change request email
     *
     * @param array  $data Array of values to send
     * @param string $to   Email recipient
     *
     * @return mixed      Boolean true on success, PEAR_Error on failure.
     * @access protected
     */
    protected function sendEmail($data, $to)
    {
        global $interface;
        global $configArray;

        $subject = 'Osoitteen muutospyyntö';
        $interface->assign('data', $data);
        $body = $interface->fetch('Emails/change-address.tpl');

        $mail = new VuFindMailer();
        return $mail->send($to, $configArray['Site']['email'], $subject, $body);
    }

}

?>