<?php
/**
 * Due Date Reminders Sender
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2013.
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
 * @package  Controller
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/developer_manual Wiki
 */

require_once 'util.inc.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'services/MyResearch/lib/User_account.php';
require_once 'services/MyResearch/lib/Due_date_reminder.php';
require_once 'sys/SearchObject/Factory.php';
require_once 'sys/ConfigArray.php';
require_once 'sys/Interface.php';
require_once 'sys/Mailer.php';
require_once 'sys/Translator.php';
require_once 'sys/VuFindDate.php';

/**
 * Due Date Reminders Sender
 * 
 * @category VuFind
 * @package  Due_Date_Reminders
 * @author   Ere Maijala <ere.maijala@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/
 * 
 * Takes two optional parameters on command line:
 * 
 * php scheduled_alerts.php [main directory] [domain base]
 * 
 *   main directory   The main VuFind directory. Each web directory must reside under this (default: ..)
 *   domain base      Main domain name when using subdomains for different web directories. 
 * 
 */
class DueDateReminders
{
    /**
     * Send due date reminders
     *
     * @param string $mainDir         The main VuFind directory. Each web directory must reside under this (default: ..)
     * @param string $domainModelBase Main domain name when using subdomains for different web directories.
     *
     * @return void
     */
    public function sendReminders($mainDir, $domainModelBase)
    {
        global $configArray;
        global $interface;
        global $translator;
        
        $iso8601 = 'Y-m-d\TH:i:s\Z';
        
        ini_set('display_errors', true);
        
        $configArray = $mainConfig = readConfig();
        $datasourceConfig = getExtraConfigArray('datasources');
        $siteLocal = $configArray['Site']['local'];

        // Set up time zone. N.B. Don't use msg() or other functions requiring date before this.
        date_default_timezone_set($configArray['Site']['timezone']);

        $this->msg('Sending due date reminders');
        
        // Setup Local Database Connection
        ConnectionManager::connectToDatabase();
        
        // And index
        $db = ConnectionManager::connectToIndex();
        
        // Initialize Mailer
        $mailer = new VuFindMailer();
        
        // Find all scheduled alerts
        $sql = 'SELECT * FROM "user" WHERE "due_date_reminder" > 0 ORDER BY id';

        $user = new User();
        $user->query($sql);
        $this->msg('Processing ' . $user->N . ' users');
        $interface = false;
        $institution = false;
        $todayTime = new DateTime();
        $catalog = ConnectionManager::connectToCatalog();
        while ($user->fetch()) {
            if (!$user->email || trim($user->email) == '') {
                $this->msg('User ' . $user->username . ' does not have an email address, bypassing due date reminders');
                continue;
            }
            
            // Initialize settings and interface
            $userInstitution = reset(explode(':', $user->username, 2));
            if (!$institution || $institution != $userInstitution) {
                $institution = $userInstitution;
                
                if (!isset($datasourceConfig[$institution])) {
                    foreach ($datasourceConfig as $code => $values) {
                        if (isset($values['institution']) && strcasecmp($values['institution'], $institution) == 0) {
                            $institution = $code;
                            break;
                        }
                    }
                }
                if (!isset($datasourceConfig[$institution])) {
                    $institution = 'default';
                }
                
                if (isset($datasourceConfig[$institution]['mainView'])) {
                    // Read institution's configuration
                    $this->msg("Switching to configuration of '$institution'");
                    $configPath = "$mainDir/" . $datasourceConfig[$institution]['mainView'] . '/conf';
                    $configArray = readConfig($configPath);
                } else {
                    // Use default configuration
                    $this->msg("Switching to default configuration");
                    $configArray = $mainConfig;
                }
                
                // Setup url if necessary
                if (preg_match('/^https?:\/\/localhost/', $configArray['Site']['url'])) {
                    if ($domainModelBase) {
                        $parts = explode('/', $datasourceConfig[$institution]['mainView']);
                        if (end($parts) == 'default') {
                            array_pop($parts);
                        }
                        $configArray['Site']['url'] = 'http://' . implode('.', array_reverse($parts)) . ".$domainModelBase";
                    }
                }
                
                // Start Interface
                $interface = new UInterface($siteLocal);
                $validLanguages = array_keys($configArray['Languages']);
                $dateFormat = new VuFindDate();
            }
            
            $language = $user->language;
            if (!in_array($user->language, $validLanguages)) {
                $language = $configArray['Site']['language'];
            }
        
            $translator = new I18N_Translator(
                array($configArray['Site']['local'] . '/lang', $configArray['Site']['local'] . '/lang_local'),
                $language,
                $configArray['System']['debug']
            );
            $interface->setLanguage($language);
            
            // Go through accounts and check loans
            $account = new User_account();
            $account->user_id = $user->id;
            if (!$account->find(false)) {
                continue;
            }
            $remindLoans = array();
            while ($account->fetch()) {
                $patron = $catalog->patronLogin($account->cat_username, $account->cat_password);
                if (PEAR::isError($patron)) {
                    $this->msg('Catalog login failed for user ' . $user->id . ', account ' . $account->id . ' (' . $account->cat_username . ')');
                    continue;
                }
                $loans = $catalog->getMyTransactions($patron);
                if (PEAR::isError($loans)) {
                    $this->msg('Could not fetch loans for user ' . $user->id . ', account ' . $account->id . ' (' . $account->cat_username . ')');
                }
                foreach ($loans as $loan) {
                    $dueDate = new DateTime($loan['duedate']);
                    if ($todayTime >= $dueDate || $dueDate->diff($todayTime)->days <= $user->due_date_reminder) {
                        // Check that a reminder hasn't been sent already
                        $reminder = new Due_date_reminder();
                        $reminder->user_id = $user->id;
                        $reminder->loan_id = $loan['item_id'];
                        $reminder->due_date = $dueDate->format($iso8601);
                        if ($reminder->find(false)) {
                            // Reminder already sent
                            continue;
                        }
                        // Store also title for display in email
                        $title = isset($loan['title']) ? $loan['title'] : translate('Title not available');
                        if (isset($loan['id'])) {
                            $record = $db->getRecord($loan['id']);
                            if ($record && isset($record['title'])) {
                                $title = $record['title'];
                            }
                        }
                        $remindLoans[] = array(
                            'loanId' => $loan['item_id'],
                            'dueDate' => $loan['duedate'],
                            'dueDateFormatted' => $dueDate->format(
                                isset($configArray['Site']['displayDateFormat']) ? $configArray['Site']['displayDateFormat'] : "m-d-Y"
                            ),
                            'title' => $title
                        );
                    }
                }
            }
            
            if ($remindLoans) {
                $this->msg(count($remindLoans) . ' new loans to remind for user ' . $user->id);
                
                $interface->assign('date', $dateFormat->convertToDisplayDate("U", floor(time())));
                $interface->assign('loans', $remindLoans);
        
                // Load template
                $message = $interface->fetch('MyResearch/due-date-email.tpl');
                if (strstr($message, 'Warning: Smarty error:')) {
                    $this->msg("Message template processing failed: $message");
                    continue;
                }
                $result = $mailer->send($user->email, $configArray['Site']['email'], translate('due_date_email_subject'), $message);
                if (PEAR::isError($result)) {
                    $this->msg("Failed to send message to {$user->email}: " . $result->getMessage());
                    continue;
                }
                
                // Mark reminders sent
                foreach ($remindLoans as $loan) {
                    $reminder = new Due_date_reminder();
                    $reminder->user_id = $user->id;
                    $reminder->loan_id = $loan['loanId'];
                    $reminder->delete();
                    $dueDate = new DateTime($loan['dueDate']);
                    $reminder->due_date = $dueDate->format($iso8601);
                    $reminder->notification_date = gmdate($iso8601, time());
                    $reminder->insert();
                }
            } else {
                $this->msg('No loans to remind for user ' . $user->id);
            }
        }
        
        $this->msg('Due date reminders execution completed');
    }

    /**
     * Output a message with a timestamp
     * 
     * @param string $msg Message
     * 
     * @return void
     */
    protected function msg($msg)
    {
        echo date('Y-m-d H:i:s') . ' [' . getmypid() . "] $msg\n"; 
    }
}

$alerts = new DueDateReminders();
$alerts->sendReminders(isset($argv[1]) ? $argv[1] : '..', isset($argv[2]) ? $argv[2] : false);
