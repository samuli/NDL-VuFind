<?php
/**
 * UserComments action for Record module
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
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Record.php';

require_once 'services/MyResearch/lib/Resource.php';
require_once 'services/MyResearch/lib/Comments.php';
require_once 'services/MyResearch/lib/Comments_inappropriate.php';
require_once 'services/MyResearch/Login.php';

/**
 * UserComments action for Record module
 *
 * @category VuFind
 * @package  Controller_Record
 * @author   Andrew S. Nagy <vufind-tech@lists.sourceforge.net>
 * @author   Demian Katz <demian.katz@villanova.edu>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class UserComments extends Record
{
    /**
     * Process incoming parameters and display the page.
     *
     * @return void
     * @access public
     */
    public function launch()
    {
        global $interface;
        global $user;
        global $configArray;

        // Process Delete Comment
        if ((isset($_GET['delete'])) && (is_object($user))) {
            $this->deleteComment($_GET['delete'], $user);
        }

        // Process Inappropriate Comment
        if (isset($_GET['inappropriate'])) {
            if (isset($_GET['lightbox'])) {
                $interface->assign('commentId', $_GET['inappropriate']);
                $interface->display('Record/report-inappropriate.tpl');
                exit();
            } else {
                //TODO: non ajax functionality
                exit();
            }
        }

        if (isset($_REQUEST['comment'])) {
            if (!$user) {
                $interface->assign('recordId', $_GET['id']);
                // Use "extraParams" mechanism to make sure that user comment gets
                // passed safely through login process:
                $interface->assign(
                    'extraParams',
                    array(
                        array('name' => 'comment', 'value' => $_REQUEST['comment'])
                    )
                );
                $interface->assign('followup', true);
                $interface->assign('followupModule', 'Record');
                $interface->assign('followupAction', 'UserComments');
                $interface->setPageTitle('You must be logged in first');
                Login::setupLoginFormVars();
                $interface->assign('subTemplate', '../MyResearch/login.tpl');
                $interface->setTemplate('view-alt.tpl');
                $interface->display('layout.tpl', 'UserComments' . $_GET['id']);
                exit();
            }
            $result = $this->saveComment($user);
        }

        // Get number of comments for this record
        $comments = new Comments();
        $commentCount = $comments->getCommentCount($_REQUEST['id']);
   
        $interface->assign(compact('commentCount'));

        $interface->setPageTitle(
            translate('Comments') . ': ' . $this->recordDriver->getBreadcrumb()
        );

        // Set Messages
        $interface->assign('infoMsg', $this->infoMsg);
        $interface->assign('errorMsg', $this->errorMsg);

        $this->assignComments();
        $interface->assign('user', $user);
        $interface->assign('subTemplate', 'view-comments.tpl');
        $interface->setTemplate('view.tpl');

        // Display Page
        $interface->display('layout.tpl'/*, $cacheId */);
    }

    /**
     * Delete a comment
     *
     * @param int    $id   ID of comment to delete
     * @param object $user User whose comment is being deleted.
     *
     * @return bool        True for success, false for failure.
     * @access public
     */
    public static function deleteComment($id, $user)
    {
        $comment = new Comments();
        $comment->id = $id;
        if ($comment->find(true)) {
            if ($user->id == $comment->user_id) {
                $comment->delete();
                return true;
            }
        }
        return false;
    }
    
    /**
     * Report inappropriate comment
     *
     * @return bool        True for success, false for failure.
     * @access public
     */
    public static function inappropriateComment()
    {
        global $user;
        // What record are we operating on?
        if (!isset($_REQUEST['commentId'])) {
            return false;
        }
        $commentInapp = new Comments_inappropriate();
        $commentInapp->comment_id = $_REQUEST['commentId'];
        $commentInapp->user_id = isset($user) && is_object($user) ? $user->id : null;
        $commentInapp->created = date('Y-m-d H:i:s');
        // TODO: strip tags just in case
        $commentInapp->reason = $_REQUEST['reason'];
        $commentInapp->insert();
        unset($_SESSION['no_store']);
        $reported = isset($_SESSION['reportedComments']) ? $_SESSION['reportedComments'] : array();
        $reported[] = $_REQUEST['commentId'];
        $_SESSION['reportedComments'] = $reported;
        return true;
    }

    /**
     * Assign comments for the current resource to the interface.
     *
     * @return void
     * @access public
     */
    public static function assignComments()
    {
        global $interface, $user;

        $comments = new Comments();
        $commentList = $comments->getComments($_GET['id']);
        $interface->assign('commentList', $commentList);
        $reported = isset($_SESSION['reportedComments']) ? $_SESSION['reportedComments'] : array();
        $usersComments = array();
        if (is_object($user)) {
            $commentInapp = new Comments_inappropriate();
            $commentInapp->user_id = $user->id;
            $commentInapp->find();
            while ($commentInapp->fetch()) {
                $usersComments[] = $commentInapp->comment_id;
            }
            $commentedByUser = false;
            foreach ($commentList as $comment) {
                if ($user->id == $comment->user_id) {
                    $commentedByUser = true;
                    break;
                }
            }
            
        }
        include_once 'RecordDrivers/Factory.php';
        
        $db = ConnectionManager::connectToIndex();
        if (!($record = $db->getRecord($_REQUEST['id']))) {
            PEAR::raiseError(new PEAR_Error('Record Does Not Exist'));
        }
        $recordDriver = RecordDriverFactory::initRecordDriver($record);
        if ($recordDriver->getSector() == 'lib') {
            $interface->assign('ratings', true);
        }                
        $interface->assign(compact('commentedByUser'));        
        $interface->assign('reported', array_merge($reported, $usersComments));
    }

    /**
     * Save a user's comment to the database.
     *
     * @param object $user User whose comment is being saved.
     *
     * @return bool        True for success, false for failure.
     * @access public
     */
    public static function saveComment($user)
    {
        // What record are we operating on?
        if (!isset($_GET['id'])) {
            return false;
        }
        
        if ($_REQUEST['commentId'] == 0) {
            $searchObject = SearchObjectFactory::initSearchObject();
            $query = 'local_ids_str_mv:"' . addcslashes($_GET['id'], '"') . '"';
            $searchObject->disableLogging();
            $searchObject->setQueryString($query);
            $result = $searchObject->processSearch();
            $searchObject->close();
            if (PEAR::isError($result)) {
                PEAR::raiseError($result->getMessage());
            }

            if ($result['response']['numFound'] == 0) {
                $idArray = array($_GET['id']);
            } else {
                $idArray = $result['response']['docs'][0]["local_ids_str_mv"];
            }
            if ($_REQUEST['type'] == 1) {
                $commentsByUser = new Comments();
                $commentList = $commentsByUser->getComments($_REQUEST['recordId']);
                foreach ($commentList as $comment) {
                    if ($comment->user_id == $user->id) {
                        return false;
                    }
                }
                
            }            
            $comments = new Comments();
            $comments->user_id = $user->id;
            $rating = (float)$_REQUEST['rating'];
            $comments->rating = ($rating > 0 && $rating <= 5) ? $rating : null;
            $comments->comment = $_REQUEST['comment'];
            $comments->type = $_REQUEST['type'];
            $comments->created = date('Y-m-d H:i:s');
            $comments->insert();
            $comments->addLinks($idArray);
            return true;            
        } else {
            $comments = new Comments();
            $comments->get($_REQUEST['commentId']);
            if ($comments->user_id == $user->id) {
                $comments->comment = $_REQUEST['comment'];
                $comments->rating = $_REQUEST['rating'];
                $comments->updated = date('Y-m-d H:i:s');            
                $comments->update();
                return true;                
            } 
            return false;
        }
    }

}

?>
