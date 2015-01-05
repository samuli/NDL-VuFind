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

        // Collect all messages so that nothing is overwritten
        $userMessages = array();
        $userErrors = array();


        // These require just a login
        if (UserAccount::isLoggedIn()) {
            // Update email address
            if (isset($_POST['email'])) {
                if ($user->changeEmailAddress($_POST['email'])) {
                    $userMessages[] = 'profile_update';
                }
            }
            $interface->assign('email', $user->email);

            // Update due date reminder
            if (isset($_POST['due_date_reminder'])) {
                $interval = $_POST['due_date_reminder'];
                if (is_numeric($interval) && $interval >= 0) {
                    if ($user->changeDueDateReminder(
                        $_POST['due_date_reminder']
                    )
                    ) {
                        $userMessages[] = 'profile_update';
                    }
                }
            }
            $interface->assign('dueDateReminder', $user->due_date_reminder);
        }

        // Get My Profile
        if ($patron = UserAccount::catalogLogin()) {
            if (PEAR::isError($patron)) {
                $this->handleCatalogError($patron);
            } else {
                // Address change request form
                if (isset($_POST['changeAddressRequest'])) {
                    $profile = $this->catalog->getMyProfile($patron);
                    if (!PEAR::isError($profile)) {
                        $interface->assign(
                            'address1',
                            isset($profile['address1']) ? $profile['address1'] : ''
                        );
                        $interface->assign(
                            'zip',
                            isset($profile['zip']) ? $profile['zip'] : ''
                        );
                    }
                    $interface->display('/MyResearch/change-address.tpl');
                    return;
                }

                // Address change request
                if (isset($_POST['changeAddressLine1'])
                    && isset($_POST['changeAddressZip'])
                ) {
                    $result = $this->sendEmail(
                        $patron,
                        filter_input_array(INPUT_POST, FILTER_SANITIZE_STRING)
                    );
                    if (!PEAR::isError($result)) {
                        $userMessages[] = 'address_change_email_sent';
                    } else {
                        error_log(
                            'Sending of address change requeste mail failed: '
                            . $result->getMessage()
                        );
                        $userErrors[] = 'address_change_email_failed';
                    }
                }

                // Change home library
                if (isset($_POST['home_library']) && $_POST['home_library'] != "") {
                    $home_library = $_POST['home_library'];
                    if ($user->changeHomeLibrary($home_library)) {
                        $userMessages[] = 'profile_update';
                    } else {
                        $userErrors[] = 'profile_update_failed';
                    }
                }
                // Change Password
                if (isset($_POST['oldPassword'])
                    && isset($_POST['newPassword'])
                    && isset($_POST['newPassword2'])
                ) {
                    if ($_POST['newPassword'] !== $_POST['newPassword2']) {
                        $userErrors[] = 'change_password_error_verification';
                    } else {
                        $result = $this->changePassword(
                            $_POST['oldPassword'], $_POST['newPassword']
                        );
                        if (PEAR::isError($result)) {
                            $userErrors[] = $result->getMessage();
                        } else {
                            if ($result['success']) {
                                $userMessages[] = 'change_password_ok';
                                $user->changeCatalogPassword($_POST['newPassword']);
                                // Re-retrieve patron to make sure it's up to date
                                $patron = UserAccount::catalogLogin();
                            } else {
                                $userErrors[] = $result['status'];
                            }
                        }
                    }
                }

                // Change phone number
                if (isset($_POST['phone_number'])) {
                    $phoneNumber = trim($_POST['phone_number']);
                    if (preg_match('/^[\+]?[ \d\-]+\d+$/', $phoneNumber)) {
                        $result = $this->catalog->setPhoneNumber(
                            $patron, $phoneNumber
                        );
                        if ($result['success']) {
                            $userMessages[] = 'phone_updated';
                            // Re-retrieve patron to make sure it's up to date
                            $patron = UserAccount::catalogLogin();
                        } else {
                            $userErrors[] = $result['sys_message'];
                        }
                    } else {
                        $userErrors[] = 'Phone Number is invalid';
                    }
                }
                // Change email address
                if (isset($_POST['email_address'])) {
                    $email = trim($_POST['email_address']);
                    if (Mail_RFC822::isValidInetAddress($email)) {
                        $result = $this->catalog->setEmailAddress($patron, $email);
                        if ($result['success']) {
                            $userMessages[] = 'email_updated';
                            // Re-retrieve patron to make sure it's up to date
                            $patron = UserAccount::catalogLogin();
                        } else {
                            $userErrors[] = $result['sys_message'];
                        }
                    } else {
                        $userErrors[] = 'Email address is invalid';
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
                } else {
                    $userErrors[] = $result->getMessage();
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

        $interface->assign('userMsg', array_unique($userMessages));
        $interface->assign('userError', array_unique($userErrors));


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
     * @param array $patron Patron
     * @param array $data   Array of address information to send
     *
     * @return mixed      Boolean true on success, PEAR_Error on failure.
     * @access protected
     */
    protected function sendEmail($patron, $data)
    {
        global $interface;
        global $configArray;

        $driver = explode('.', $patron['cat_username'], 2);
        $datasources = getExtraConfigArray('datasources');
        if (is_array($driver)
            && isset($driver[0])
            && isset($datasources[$driver[0]])
            && (isset($datasources[$driver[0]]['feedbackEmail'])
            || isset($datasources[$driver[0]]['addressChangeRequestEmail']))
        ) {
            $emailSource = $datasources[$driver[0]];
            $to = isset($emailSource['addressChangeRequestEmail'])
                ? $emailSource['addressChangeRequestEmail']
                : $emailSource['feedbackEmail'];
        } else {
            $to = $configArray['Site']['email'];
        }

        $profile = $this->catalog->getMyProfile($patron);
        if (PEAR::isError($profile)) {
            return $profile;
        }

        list($library, $username) = explode('.', $patron['cat_username']);
        $library = translate(array('text' => $library, 'prefix' => 'source_'));
        $name = trim(
            (isset($profile['firstname']) ? $profile['firstname'] : '')
            . ' '
            . (isset($profile['lastname']) ? $profile['lastname'] : '')
        );

        $subject = 'Osoitteenmuutospyyntö';
        $interface->assign('library', $library);
        $interface->assign('username', $username);
        $interface->assign('name', $name);
        $interface->assign('email', isset($patron['email']) ? $patron['email'] : '');
        $interface->assign(
            'oldAddress1', isset($profile['address1']) ? $profile['address1'] : ''
        );
        $interface->assign(
            'oldZip', isset($profile['zip']) ? $profile['zip'] : ''
        );
        $interface->assign('address1', $data['changeAddressLine1']);
        $interface->assign('zip', $data['changeAddressZip']);
        $body = $interface->fetch('Emails/change-address.tpl');

        $mail = new VuFindMailer();
        return $mail->send($to, $configArray['Site']['email'], $subject, $body);
    }

}

?>