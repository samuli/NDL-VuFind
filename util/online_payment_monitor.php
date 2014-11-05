<?php
/**
 * OnlinePayment Monitor script
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2012.
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
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/developer_manual Wiki
 */

require_once 'reminder_task.php';
require_once 'util.inc.php';
require_once 'services/MyResearch/lib/Transaction.php';
require_once 'services/MyResearch/lib/User.php';
require_once 'sys/ConfigArray.php';
require_once 'sys/Interface.php';
require_once 'sys/Mailer.php';
require_once 'sys/SearchObject/Factory.php';
require_once 'sys/Translator.php';
require_once 'sys/User.php';

/**
 * Online payment monitor. Validates unregistered online payment transactions.
 *
 * @category VuFind
 * @package  OnlinePayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/
 *
 * Takes the following parameters on command line:
 *
 * php online_payment_monitor.php expire_hours main_directory internal_email from_email report_interval_hours
 *
 *   expire_hours          Number of hours before considering unregistered
 *                         transaction to be an expired one
 *   main_directory        The main VuFind directory. Each web directory
 *                         must reside under this (default: ..)
 *   internal_email        Email address for internal error reporting
 *   from_email            Sender email address for notification of expired transactions
 *   report_interval_hours Interval when to re-send report of unresolved transactions
 *
 */
class OnlinePaymentMonitor extends ReminderTask
{

    protected $expireHours;
    protected $fromEmail;
    protected $reportIntervalHours;

    /**
     * Constructor

     * @param int $expireHours            Number of days before considering unregistered
     *                                    transaction to be an expired one
     * @param string $mainDir             The main VuFind directory. Each web directory
     *                                    must reside under this (default: ..)
     * @param string $internalErrEmail    Email address for internal error reporting
     * @param string $formEmail           Sender email address for notification of expired transactions.
     * @param string $reportIntervalHours Interval when to re-send report of unresolved transactions.
     *
     * @return void
     */
    function __construct($expireHours, $mainDir, $internalErrEmail, $fromEmail, $reportIntervalHours)
    {
        parent::__construct($mainDir, $internalErrEmail);

        $this->expireHours = $expireHours;
        $this->fromEmail = $fromEmail;
        $this->reportIntervalHours = $reportIntervalHours;
    }

    /**
     * Process transactions. Try to register unregistered transactions
     * and inform on expired transactions.
     *
     * @return void
     * @access public
     */
    public function process()
    {
        $this->msg("OnlinePayment monitor started");

        global $configArray;
        global $interface;

        ini_set('display_errors', true);

        $configArray = $mainConfig = readConfig();
        $datasourceConfig = getExtraConfigArray('datasources');

        // Set up time zone. N.B. Don't use msg() or other
        // functions requiring date before this.
        date_default_timezone_set($configArray['Site']['timezone']);

        // Setup Local Database Connection
        ConnectionManager::connectToDatabase();

        // Initialize Mailer
        $mailer = new VuFindMailer();
        $now = new DateTime();


        $expiredCnt = 0;
        $failedCnt = 0;
        $registeredCnt = 0;
        $remindCnt = 0;
        
        $user = false;
        $report = array();


        // Attempt to re-register paid transactions whose registration has failed.
        $t = new Transaction();	
        $t->whereAdd('complete = ' . Transaction::STATUS_REGISTRATION_FAILED);
        $t->whereAdd('paid > 0');
        $t->orderBy('user_id');
        $t->find();

        while ($t->fetch()) {
            $this->msg("  Registering transaction id {$t->id} / {$t->transaction_id}");

            // check if the transaction has not been registered for too long
            $paid_time = new DateTime($t->paid);
            $diff = $now->diff($paid_time);
            $diffHours = ($diff->days*24) + $diff->h;
            if ($diffHours > $this->expireHours) {
                if (!isset($report[$t->driver])) {
                    $report[$t->driver] = 0;
                }
                $report[$t->driver]++;
                $expiredCnt++;


                if (!$t->setTransactionReported($t->transaction_id)) {
                    $this->err('    Failed to update transaction ' . $t->transaction_id . 'as reported');
                }
              
                $transaction = clone($t);              
                $transaction->complete = Transaction::STATUS_REGISTRATION_EXPIRED;
                if ($transaction->update($t) === false) {
                    $this->err('    Failed to update transaction ' . $t->transaction_id . 'as expired.');
                } else {
                    $this->msg('    Transaction ' . $t->transaction_id . ' expired.');
                }
            } else {
                if ($user === false || $t->user_id != $user->id) {
                    $user = User::staticGet($t->user_id);
                }

                $catalog = ConnectionManager::connectToCatalog();
                if ($catalog && $catalog->status) {
                    $patronId = $t->cat_username;
                    $res = $catalog->markFeesAsPaid($patronId, $t->amount);
                    if ($res === true) {
                        if (!$t->setTransactionRegistered($t->transaction_id)) {
                            $this->err('    Failed to update transaction ' . $t->transaction_id . 'as registered');
                        }
                        $registeredCnt++;
                    } else {
                        $t->setTransactionRegistrationFailed($t->transaction_id, $res);
                        $failedCnt++;
                        $this->msg('    Registration of transaction ' . $t->transaction_id . 'failed');
                        $this->msg("      {$res}");
                    }
                } else {
                    $this->err("Failed to connect to catalog ($patronId)");
                    continue;
                }
            }
        }

        /*
        Report paid and unregistered transactions whose registration 
        can not be re-tried:
        
        1. Transaction::STATUS_REGISTRATION_EXPIRED
              Transaction has been updated to 'expired' 
              after failed registration attempts.
        2. Transaction::STATUS_FINES_UPDATED
              Registration was not attempted after a successful payment 
              because patron's payable sum got updated during the payment process.
        */
        $t = new Transaction();	
        $t->whereAdd('complete = ' . Transaction::STATUS_REGISTRATION_EXPIRED . ' OR complete = ' . Transaction::STATUS_FINES_UPDATED);
        $t->whereAdd('paid > 0');
        $t->whereAdd('reported = 0 OR NOW() > DATE_ADD(reported, INTERVAL ' . $this->reportIntervalHours . ' HOUR)');
        $t->orderBy('user_id');
        $t->find();

        while ($t->fetch()) {
            $this->msg("  Transaction id {$t->transaction_id} still unresolved.");
            
            if (!$t->setTransactionReported($t->transaction_id)) {
                $this->err('    Failed to update transaction ' . $t->transaction_id . ' as reported');
            }
            if (!isset($report[$t->driver])) {
                $report[$t->driver] = 0;
            }
            $report[$t->driver]++;
            $remindCnt++;
        }



        if ($registeredCnt) {
            $this->msg("  Total registered: $registeredCnt");
        }
        if ($expiredCnt) {
            $this->msg("  Total expired: $expiredCnt");
        }
        if ($failedCnt) {
            $this->msg("  Total failed: $failedCnt");
        }
        if ($remindCnt) {
            $this->msg("  Total to be reminded: $remindCnt");
        }


        $configArray = readConfig();
        $siteLocal = $configArray['Site']['local'];
        $interface = new UInterface($siteLocal);

        // Send report of transactions that need to be resolved manually:
        foreach ($report as $driver => $cnt) {
            if ($cnt) {
                $settings = getExtraConfigArray("VoyagerRestful_$driver");
                if (!$settings || !isset($settings['OnlinePayment']['errorEmail'])) {
                    $this->err("  Error email for expired transactions not defined for driver $driver ($cnt expired transactions)");
                    continue;
                }

                $email = $settings['OnlinePayment']['errorEmail'];
                $this->msg("  [$driver] Inform $cnt expired transactions for driver $driver to $email");

                $mailer = new VuFindMailer();
                $subject = "Finna: ilmoitus tietokannan $driver epäonnistuneista verkkomaksuista";

                $interface->assign('driver', $driver);
                $interface->assign('cnt', $cnt);
                $msg = $interface->fetch('Emails/online-payment-error.tpl');

                if (!$result = $mailer->send($email, $this->fromEmail, $subject, $msg)) {
                    $this->err("    Failed to send error email to customer: $email");
                }
            }
        }

        $this->msg("OnlinePayment monitor completed");
        $this->reportErrors();
    }
}

if (count($argv) < 6) {
    die("Usage: php {$argv[0]} expire_hours main_directory internal_error_email from_email report_interval_hours" . PHP_EOL);
}

$monitor = new OnlinePaymentMonitor(
    $argv[1],
    $argv[2],
    $argv[3],
    $argv[4],
    $argv[5]
);
$monitor->process();
