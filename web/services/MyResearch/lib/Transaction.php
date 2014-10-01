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
}
