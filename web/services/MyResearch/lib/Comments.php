<?php
/**
 * Table Definition for comments
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
 * @package  DB_DataObject
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://pear.php.net/package/DB_DataObject/ PEAR Documentation
 */
require_once 'DB/DataObject.php';

/**
 * Table Definition for comments
 *
 * @category VuFind
 * @package  DB_DataObject
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://pear.php.net/package/DB_DataObject/ PEAR Documentation
 */
class Comments extends DB_DataObject
{
    // @codingStandardsIgnoreStart
    ###START_AUTOCODE
    /* the code below is auto generated do not remove the above tag */

    public $__table = 'comments';                        // table name
    public $id;                              // int(11)  not_null primary_key auto_increment
    public $user_id;                         // int(11)  not_null multiple_key
    public $resource_id;                     // int(11)  not_null multiple_key
    public $comment;                         // blob(65535)  not_null blob
    public $rating;                          // float
    public $type;                            // boolean, 0 = comment, 1 = rating
    public $created;                         // datetime(19)  not_null binary

    /* Static get */
    function staticGet($k,$v=NULL) { return DB_DataObject::staticGet('Comments',$k,$v); }

    /* the code above is auto generated do not remove the tag below */
    ###END_AUTOCODE
    // @codingStandardsIgnoreEnd

    /**
     * Get a list of all comments associated with this resource.
     *
     * @return array
     * @access public
     */
    public function getComments($recordId)
    {
        $recordId = mysql_real_escape_string($recordId);        
        $sql = "SELECT comments.*, user.firstname || user.lastname as fullname, " .
               "user.username " .
               "FROM comments " . 
               "RIGHT OUTER JOIN user ON comments.user_id = user.id " . 
               "JOIN comments_record ON comments.id = comments_record.comment_id " . 
               "WHERE comments_record.record_id = '$recordId' " .
               "AND comments.visible = 1 " . 
               "ORDER BY comments.created ";        

        $commentList = array();

        $result = $this->query($sql);
        
        if ($this->N) {
            while ($this->fetch()) {
                $commentList[] = clone($this);
            }
        }

        return $commentList;
    }

    /**
     * Get number of comments on record.
     *
     * @return int
     * @access public
     */
    public function getCommentCount($record_id)
    {
        require_once 'services/MyResearch/lib/Comments_record.php';
        $commentsRecord = new Comments_record();
        $commentsRecord->record_id = $record_id;
        return $commentsRecord->count('id');
    }    

    /**
     * Add a link to a record.
     *
     * @return boolean success
     * @access public
     */
    public function addLinks($recordIdArray)
    {
        require_once 'services/MyResearch/lib/Comments_record.php';
        foreach ($recordIdArray as $recordId) {
            $commentsRecord = new Comments_record();
            $commentsRecord->record_id = $recordId;
            $commentsRecord->comment_id = $this->id;
            $commentsRecord->insert();
        }
        return true;
    }    
}
