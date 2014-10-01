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
 * Takes two parameters on command line:
 *
 * php webpayment_monitor.php expire_days [main directory] [email]
 *
 *   expire days      Number of days before considering unregistered
 *                    transaction to be an expired one
 *   main directory   The main VuFind directory. Each web directory
 *                    must reside under this (default: ..)
 *   email            Email address for error reporting
 *
 */
class WebpaymentMonitor extends ReminderTask
{
    /**
     * Constructor
     *
     * @param int    $expirationDays Number of days before considering
     *                               unregistered transaction to be
     *                               an expired one
     * @param string $mainDir        The main VuFind directory.
     *                               Each web directory must reside
     *                               under this (default: ..)
     * @param string $errEmail       Email address for error reporting.
     *
     * @return void
     */
    function __construct($expirationDays, $mainDir, $errEmail)
    {
        parent::__construct($mainDir, $errEmail);

        $this->expirationDays = $expirationDays;
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
        global $configArray;

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

        $this->msg('Checking unregistered payments');

        // Find all transaction that have not been registered
        // (rejected by payment register)
        $t = new Transaction();
        $t->query('SELECT * from transaction where paid > 0 and registered = 0 order by user_id');

        $expiredTransactionData = array();
        $failedToRegisterData  = array();
        $expiredTransactionCount = 0;
        $registeredTransactionCount = 0;
        $failedToRegisterCount = 0;
        $user = false;
        $institution = false;

        while ($t->fetch()) {
            if ($user === false || $t->user_id != $user->id) {
                $user = User::staticGet($t->user_id);
            }

            $userInstitution = reset(explode(':', $user->username, 2));
            if (!$institution || $institution != $userInstitution) {
                $institution = $userInstitution;

                if (!isset($datasourceConfig[$institution])) {
                    foreach ($datasourceConfig as $code => $values) {
                        if (isset($values['institution'])
                            && strcasecmp($values['institution'], $institution) == 0
                        ) {
                            $institution = $code;
                            break;
                        }
                    }
                }
            }

            if (!$institution) {
                //TODO: some exception?
                continue;
            }
            //check if the transaction has not been registered for too long
            $paid_time = new DateTime($t->paid);
            $diff = $now->diff($paid_time);
            if ( $diff->days > $this->expirationDays) {
                $feedbackEmail = null;
                if (isset($datasourceConfig[$institution])
                    && isset($datasourceConfig[$institution]['feedbackEmail'])
                ) {
                    $feedbackEmail
                        = $datasourceConfig[$institution]['feedbackEmail'];
                }
                if ($feedbackEmail === null) {
                    $this->msg(
                        "No feedback email found for institution {$institution}"
                    );
                    continue;
                }
                if (isset($expiredTransactionData[$feedbackEmail])) {
                    $expiredTransactionData[$feedbackEmail][] = array(
                        "transaction_id" => $t->transaction_id,
                        "user" => $user->cat_username,
                        "paid" => $paid_time
                    );
                } else {
                    $expiredTransactionData[$feedbackEmail] = array();
                    $expiredTransactionData[$feedbackEmail][] = array(
                        "transaction_id" => $t->transaction_id,
                        "user" => $user->cat_username,
                        "paid" => $paid_time
                    );
                }
                $this->err(
                    "Expired webpayment transaction: {$t->transaction_id}"
                );
            } else {
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
                            $feedbackEmail = null;
                            if (isset($datasourceConfig[$institution])
                                && isset($datasourceConfig[$institution]['feedbackEmail'])
                            ) {
                                $feedbackEmail
                                    = $datasourceConfig[$institution]['feedbackEmail'];
                            }
                            if ($feedbackEmail === null) {
                                $this->msg(
                                    "No feedback email found "
                                    . "for institution {$institution}"
                                );
                                continue;
                            }
                            if (isset($failedToRegisterData[$feedbackEmail])) {
                                $failedToRegisterData[$feedbackEmail][] = array(
                                    "transaction_id" => $t->transaction_id,
                                    "user" => $user->cat_username,
                                    "paid" => $paid_time
                                );
                            } else {
                                $failedToRegisterData[$feedbackEmail] = array();
                                $failedToRegisterData[$feedbackEmail][] = array(
                                    "transaction_id" => $t->transaction_id,
                                    "user" => $user->cat_username,
                                    "paid" => $paid_time
                                );
                            }
                            $this->err(
                                "Failed to register payment "
                                . "{$t->transaction_id}: "
                                . $registered->getMessage()
                            );
                            continue;
                        } else if ($registered) {
                            $transaction = clone($t);
                            $transaction->complete = true;
                            $transaction->status = 'payment_register_ok';
                            $transaction->registered = date("Y-m-d H:i:s");
                            if (!$transaction->update($t)) {
                                $this->msg(
                                    "Failed to update transaction data "
                                    . "({$t->transaction_id})"
                                );
                                continue;
                            }
                            $registeredTransactionCount ++;
                        }
                    }
                } else {
                    $this->msg(
                        "Failed to connect to catalog ({$user->cat_name})"
                    );
                    continue;
                }
            }
        }

        if (count($expiredTransactionData)) {
            foreach ($expiredTransactionData as $feedbackEmail => $transactions) {
                $message = "There are " . count($transactions)
                    . " expired unregistered webpayment transactions:\n";
                foreach ($transactions as $transaction_data) {
                    $datePaid = $transaction_data['paid']->format("Y-m-d H:i");
                    $message .= "{$transaction_data['transaction_id']} "
                        . "paid by {$transaction_data['user']} on {$datePaid}.\n";
                }

                $result = $mailer->send(
                    $feedbackEmail, $configArray['Site']['email'],
                    "Webpayment service: There are unregistered payments",
                    $message
                );
                if (PEAR::isError($result)) {
                    $this->msg(
                        "Failed to send message to {$feedbackEmail}: "
                        . $result->getMessage()
                    );
                    continue;
                }
                $expiredTransactionCount += count($transactions);
            }
        }
        if (count($failedToRegisterData)) {
            foreach ($failedToRegisterData as $feedbackEmail => $transactions) {
                $message = count($transactions)
                    . " webpayment transactions have failed to register:\n";
                foreach ($transactions as $transaction_data) {
                    $datePaid = $transaction_data['paid']->format("Y-m-d H:i");
                    $message .= "{$transaction_data['transaction_id']} "
                        . " paid by {$transaction_data['user']} on {$datePaid}.\n";
                }

                $result = $mailer->send(
                    $feedbackEmail, $configArray['Site']['email'],
                    "Webpayment service: Wepayment transactions registering failed",
                    $message
                );
                if (PEAR::isError($result)) {
                    $this->msg(
                        "Failed to send message to {$feedbackEmail}: "
                        . $result->getMessage()
                    );
                    continue;
                }
                $failedToRegisterCount += count($transactions);
            }
        }
        $this->msg("Registered {$registeredTransactionCount} transactions.");
        if ($failedToRegisterCount) {
            $this->msg(
                "{$failedToRegisterCount} transactions have failed to register."
                . " This has been reported to Webpayment maintenance."
            );
        }
        if ($expiredTransactionCount) {
            $this->msg(
                "{$expiredTransactionCount} expired transactions have "
                . " been reported to Webpayment maintenance."
            );
        }

        $this->reportErrors();
        $this->msg("Webpayment monitor execution completed");
    }
}

if (count($argv) < 2) {
    exit("Usage: php webpayment_monitor.php expire_days [main directory] [email]");
}

$monitor = new WebpaymentMonitor(
    $argv[1],
    isset($argv[2]) ? $argv[2] : '..',
    isset($argv[3]) ? $argv[3] : false
);
$monitor->process();
