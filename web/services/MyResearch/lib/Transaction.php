<?php
/**
 * Table Definition for transaction
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2014
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
 * @package  DB_DataObject
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://pear.php.net/package/DB_DataObject/ PEAR Documentation
 */
require_once 'DB/DataObject.php';

require_once 'services/MyResearch/lib/Fee.php';
require_once 'services/MyResearch/lib/Transaction_fees.php';

/**
 * Table Definition for transaction
 *
 * @category VuFind
 * @package  DB_DataObject
 * @author   Leszek Manicki <leszek.z.manicki@helsinki.fi>
 * @author   Samuli Sillanpää <samuli.sillanpaa@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://pear.php.net/package/DB_DataObject/ PEAR Documentation
 */ // @codingStandardsIgnoreStart
class Transaction extends DB_DataObject
{
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    public $__table = 'transaction';         // table name
    public $id;                              // int(11)  not_null primary_key auto_increment
    public $transaction_id;                  // string(50) not null
    public $driver;                          // string(50) not null
    public $user_id;                         // int(11)  not_null multiple_key
    public $amount;                          // float  not_null
    public $currency;                        // string(3) not_null
    public $transaction_fee;                 // float  not_null
    public $created;                         // datetime(19)  not_null binary
    public $paid;                            // datetime(19)  not_null binary
    public $registered;                      // datetime(19)  not_null binary
    public $status;                          // string(50)
    public $complete;                        // boolean

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('Transaction',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
    // @codingStandardsIgnoreEnd

    const STATUS_PROGRESS              = 0;    
    const STATUS_COMPLETE              = 1;
    
    const STATUS_CANCELLED             = 2;
    const STATUS_PAID                  = 3;
    const STATUS_PAYMENT_FAILED        = 4;

    const STATUS_REGISTRATION_FAILED   = 5;
    const STATUS_REGISTRATION_EXPIRED  = 6;
    const STATUS_REGISTRATION_RESOLVED = 7;




    /**
     * Add fee to the current transaction.
     *
     * @param array  $feeData array fee data hash array
     * @param object $user    user (patron) object
     *
     * @return boolean True on success, false otherwise.
     * @access public
     */
    public function addFee($feeData, $user)
    {
        $fee = new Fee();
        $fee->user_id = isset($user) && is_object($user) ? $user->id : null;
        $fee->title = $feeData['title'];
        $fee->type = $feeData['type'];
        $fee->amount = $feeData['amount'];
        $fee->currency = $feeData['currency'];
        if (!$fee->amount) {
            return false;
        }
        if (!$fee->insert()) {
            return false;
        }
        $transaction_fee_obj = new Transaction_fees();
        $transaction_fee_obj->transaction_id = $this->id;
        $transaction_fee_obj->fee_id = $fee->id;
        if (!$transaction_fee_obj->insert()) {
            return false;
        }
        return true;
    }

    /**
     * Get fees associated with the current transaction.
     *
     * @return array Array of fees
     * @access public
     */
    public function getFees()
    {
        $feesList = array();

        $join = new Transaction_fees();
        $join->transaction_id = $this->id;
        if (!$join->find()) {
            return false;
        }
        while ($join->fetch()) {
            $fee = new Fee();
            $fee->id = $join->fee_id;
            if (!$fee->find()) {
                return false;
            }
            if (!$fee->fetch()) {
                return false;
            }
            $feesList[] = clone($fee);
        }
        return $feesList;
    }

    /**
     * Fetch the catalog username of the patron related to the current
     * transaction.
     *
     * @return mixed string on success, null on failure
     * @access public
     */
    public function getPatronCatUsername()
    {
        include_once "services/MyResearch/lib/User.php";

        $user = new User();
        $user->id = $this->user_id;
        if (!$user->find()) {
            return null;
        }
        if (!$user->fetch()) {
            return null;
        }
        return $user->cat_username;
    }

    /**
     * Check if payment is permitted for the user.
     * 
     * Payment is not permitted if:
     *   - user has a transaction in progress and translation maximum duration 
     *     has not been exceeded
     *   - user has a paid transaction that has not been registered as paid 
     *     to the ILS
     *
     * @param object $patron                 Patron
     * @param int    $transactionMaxDuration Maximum wait time (in minutes) after 
     * which a started, and not processed, transaction is considered to have been 
     * interrupted by the user.   
     *
     * @return mixed true if payment is permitted, 
     * error message if payment is not permitted, false on error
     * @access public
     */
    public function isPaymentPermitted($patron, $transactionMaxDuration)
    {
        include_once "services/MyResearch/lib/User.php";

        $user = new User();
        $user->cat_username = $patron['cat_username'];
        if (!$user->find()) {
            return false;
        }
        if (!$user->fetch()) {
            return false;
        }

        $userId = $user->id;
        
        
        $duration = mysql_real_escape_string($transactionMaxDuration);
        $transaction = new Transaction();
        $transaction->user_id = $userId;
        $transaction->complete = self::STATUS_PROGRESS;        
        $transaction->whereAdd("NOW() < DATE_ADD(created, INTERVAL $duration MINUTE)", 'AND');

        if ($transaction->find()) {
            // Transaction still in progress
            return 'online_payment_in_progress';
        }
        
        $transaction = new Transaction();
        $transaction->user_id = $userId;
        $transaction->whereAdd('complete = ' . self::STATUS_REGISTRATION_FAILED);
        $transaction->whereAdd('complete = ' . self::STATUS_REGISTRATION_EXPIRED, 'or');

        if ($transaction->find()) {
            // Transaction could not be registered and is waiting to be resolved manually.
            return 'online_payment_registration_failed';
        }
        
        return true;
    }

    /**
     * Check if transaction is in progress.
     *
     * @param string $transactionId Transaction ID.
     *
     * @return boolean success
     * @access public
     */    
    public function isTransactionInProgress($transactionId)
    {
        if (!$t = $this->getTransaction($transactionId)) {
            return false;
        }
        
        return $t->complete == self::STATUS_PROGRESS;
    }

    /**
     * Update transaction status to paid.
     *
     * @param string   $transactionId Transaction ID.
     * @param datetime $timestamp     Timestamp
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionPaid($transactionId, $timestamp)
    {
        return $this->updateTransactionStatus($transactionId, $timestamp, self::STATUS_PAID, 'paid'); 
    }

   /**
     * Update transaction status to payment failed.
     *
     * @param string   $transactionId Transaction ID.
     * @param datetime $timestamp     Timestamp
     * @param string   $msg           Error message
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionPaymentFailed($transactionId, $timestamp, $msg = false)
    {
        return $this->updateTransactionStatus($transactionId, $timestamp, self::STATUS_PAYMENT_FAILED, $msg); 
    }

   /**
     * Update transaction status to cancelled.
     *
     * @param string $transactionId Transaction ID.
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionCancelled($transactionId)
    {
        return $this->updateTransactionStatus($transactionId, false, self::STATUS_CANCELLED, 'cancel'); 
    }

   /**
     * Update transaction status to registered.
     *
     * @param string $transactionId Transaction ID.
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionRegistered($transactionId)
    {
        
        return $this->updateTransactionStatus($transactionId, false, self::STATUS_COMPLETE, 'register_ok'); 
    }

   /**
     * Update transaction status to registering failed.
     *
     * @param string $transactionId Transaction ID.
     * @param string $msg           Error message
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionRegistrationFailed($transactionId, $msg)
    {
        return $this->updateTransactionStatus($transactionId, false, self::STATUS_REGISTRATION_FAILED, $msg); 
    }

   /**
     * Update transaction status to expired.
     *
     * @param string   $transactionId Transaction ID.
     * @param datetime $timestamp     Timestamp
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionExpired($transactionId, $timestamp)
    {
        return $this->updateTransactionStatus($transactionId, false, self::STATUS_REGISTRATION_EXPIRED);
    }

   /**
     * Update transaction status to resolved..
     *
     * @param string $transactionId Transaction ID.
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionResolved($transactionId)
    {
        return $this->updateTransactionStatus($transactionId, false, self::STATUS_REGISTRATION_RESOLVED); 
    }

   /**
     * Update transaction status to unkwnown payment response.
     *
     * @param string   $transactionId Transaction ID.
     * @param datetime $timestamp     Timestamp
     * @param string   $msg           Message
     *
     * @return boolean success
     * @access public
     */    
    public function setTransactionUnknownPaymentResponse($transactionId, $timestamp, $msg)
    {
        return $this->updateTransactionStatus($transactionId, false, 'unknown_response', $msg);        
    }

   /**
     * Updates transaction status.
     *
     * @param string   $transactionId Transaction ID.
     * @param datetime $timestamp     Timestamp
     * @param int      $status        Status
     * @param string   $statusMsg     Status message
     *
     * @return boolean success
     * @access public
     */    
    protected function updateTransactionStatus($transactionId, $timestamp, $status, $statusMsg = false)
    {
        if (!$t = $this->getTransaction($transactionId)) {
            return false;
        }
        
        if ($status !== false) {
            if ($timestamp === false) {
                $timestamp = time(); 
            }
            $dateStr = date("Y-m-d H:i:s", $timestamp);
            if ($status == self::STATUS_PAID) {
                $t->paid = $dateStr;
            } else if ($status == self::STATUS_COMPLETE) {
                $t->registered = $dateStr;
            }
            
            $t->complete = $status;
        }
        if ($statusMsg) {
            $t->status = $statusMsg;
        }

        return $t->update();
    }

   /**
     * Get transaction.
     *
     * @param string $transactionId Transaction ID.
     *
     * @return Transaction transaction or false on error
     * @access public
     */    
    public function getTransaction($transactionId)
    {
        $t = new Transaction();
        $t->transaction_id = $transactionId;
        $t->find(true);
        return $t;
    }

}
