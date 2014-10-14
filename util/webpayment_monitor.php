<?php
/**
 * Webpayment Monitor script
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
require_once 'sys/PaymentRegister/PaymentRegisterFactory.php';
require_once 'sys/Translator.php';
require_once 'sys/User.php';

/**
 * Webpayment monitor. Validates unregistered webpayment transactions.
 *
 * @category VuFind
 * @package  Webpayment
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/
 *
 * Takes the following parameters on command line:
 *
 * php webpayment_monitor.php expire_hours main_directory internal_email customer_email
 *
 *   expire_hours      Number of days before considering unregistered
 *                     transaction to be an expired one
 *   main_directory    The main VuFind directory. Each web directory
 *                     must reside under this (default: ..)
 *   internal_email    Email address for internal error reporting
 *   customer_email    Email address for reporting failed transactions 
 *                     that need to be resolved by library staff.
 *
 */
class WebpaymentMonitor extends ReminderTask
{

    protected $expireHours;
    protected $customerErrEmail;

    /**
     * Constructor

     * @param int $expireHours          Number of days before considering unregistered
     *                                  transaction to be an expired one
     * @param string $mainDir           The main VuFind directory. Each web directory
     *                                  must reside under this (default: ..)
     * @param string $internalErrEmail  Email address for internal error reporting
     * @param string $customerErrEmail  Email address for reporting failed transactions 
     *                                  that need to be resolved by library staff.
     *
     * @return void
     */
    function __construct($expireHours, $mainDir, $internalErrEmail, $customerErrEmail)
    {
        parent::__construct($mainDir, $internalErrEmail);

        $this->customerErrEmail = $customerErrEmail;
        $this->expireHours = $expireHours;
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
        $this->msg("Webpayment monitor started");

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

        // Find all paid transactions that have not been registered,
        // and that have not been marked as failed.
        $t = new Transaction();	
        $t->whereAdd('complete = ' . Transaction::STATUS_RETRY);
        $t->orderBy('user_id');
        $t->find();

        $expiredCnt = 0;
        $failedCnt = 0;
        $registeredCnt = 0;

        $user = false;
        $expired = array();

        while ($t->fetch()) {
            $this->msg("  Registering transaction id {$t->id} / {$t->transaction_id}");

            // check if the transaction has not been registered for too long
            $paid_time = new DateTime($t->paid);
            $diff = $now->diff($paid_time);
            if ($diff->h > $this->expireHours) {
                if (!isset($expired[$t->driver])) {
                    $expired[$t->driver] = 0;
                }
                $expired[$t->driver]++;
                $expiredCnt++;
              
                $transaction = clone($t);              
                $transaction->complete = Transaction::STATUS_FAILED;
                if ($transaction->update($t) === false) {
                    $this->err("    Failed to update transaction as expired.");
                } else {
                    $this->msg("    Transaction expired.");
                }
            } else {
                if ($user === false || $t->user_id != $user->id) {
                    $user = User::staticGet($t->user_id);
                }

                $catalog = ConnectionManager::connectToCatalog();
                if ($catalog && $catalog->status) {
                    $paymentRegisterConfig = $catalog->getConfig(
                        'PaymentRegister', $user->cat_username
                    );
                    $paymentRegister = null;
                    if (isset($paymentRegisterConfig)
                        && isset($paymentRegisterConfig['handler'])
                    ) {
                        $paymentRegister
                            = PaymentRegisterFactory::initPaymentRegister(
                                $paymentRegisterConfig['handler'],
                                $paymentRegisterConfig
                            );
                        $fees_amount = $t->amount - $t->transaction_fee;
                        $registered = $paymentRegister->register(
                            $user->cat_username, $fees_amount
                        );
                        if (PEAR::isError($registered)) {
                            $failedCnt++;
                            $this->msg("    Registration failed");
                            $this->msg("      {$registered->toString()}");
                        } else if ($registered) {
                            $transaction = clone($t);
                            $transaction->complete = Transaction::STATUS_COMPLETE;
                            $transaction->status = 'payment_register_ok';

                            $transaction->registered = date("Y-m-d H:i:s");
                            if (!$transaction->update($t)) {
                                $this->err("Failed to update transaction as complete.");
                                continue;
                            } else {
                                $registeredCnt++;
                            }
                        }
                    }
                } else {
                    $this->err("Failed to connect to catalog ({$user->cat_name})");
                    continue;
                }
            }
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

        // Check for failed transactions that need to be resolved manually:
        foreach ($expired as $driver => $cnt) {
            if ($cnt) {
                $settings = getExtraConfigArray("VoyagerRestful_$driver");
                if (!$settings || !isset($settings['Webpayment']['errorEmail'])) {
                    $this->err("  Error email for expired transactions not defined for driver $driver");
                    continue;
                }

                $email = $settings['Webpayment']['errorEmail'];
                $this->msg("  [$driver] Inform $cnt expired transactions for driver $driver to $email");

                $mailer = new VuFindMailer();
                $from = 'finna-posti@helsinki.fi';
                $subject = "Ilmoitus tietokannan $driver epäonnistuneista verkkomaksuista";


                $msg = $interface->fetch('MyResearch/webpayment-error.tpl');
                $msg->assign('driver', $driver);
                $msg->assign('cnt', $cnt);

                if (!$result = $mailer->send($email, $from, $subject, $msg)) {
                    $this->err("    Failed to send error email to customer: $email");
                }
            }
        }

        $this->msg("Webpayment monitor completed");

        $this->reportErrors();
    }
}

if (count($argv) < 5) {
    exit("Usage: php webpayment_monitor.php expire_hours main_directory internal_email customer_email" . PHP_EOL);
}

$monitor = new WebpaymentMonitor(
    $argv[1],
    $argv[2],
    $argv[3],
    $argv[4]
);
$monitor->process();
