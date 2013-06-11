<?php
/**
 * Ajax page for rendering HTML from RSS feed
 *
 * PHP version 5
 *
 * Copyright (C) The National Library of Finland 2012
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
 * @package  Controller_AJAX
 * @author   Timo Laine <timo.mz.laine@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
require_once 'Action.php';
require_once "XML/RSS.php";

/**
 * Ajax page for rendering HTML from RSS feed
 *
 * @category VuFind
 * @package  Controller_AJAX
 * @author   Timo Laine <timo.mz.laine@helsinki.fi>
 * @license  http://opensource.org/licenses/gpl-2.0.php GNU General Public License
 * @link     http://vufind.org/wiki/building_a_module Wiki
 */
class AJAX_RenderRSS extends Action
{
    /**
     * Constructor.
     *
     * @access public
     */
    public function __construct()
    {
        parent::__construct();
        $_SESSION['no_store'] = true; 
    }
    
    /**
     * Get feed and pass configuration variables to template
     * 
     * @return void
     */
    public function launch()
    {
        global $interface;
        
        if (!isset($_REQUEST['id'])) {
            return;
        } else {
            $id = $_REQUEST['id'];
        }
        
        /*
         * let's get the list of feeds and pick the right one by the id set in
         * the template that called us
         */
        $rssConfArray = $interface->get_template_vars('rssFeeds');
        $feed = $rssConfArray[$id];

        /*
         * various configuration settings
         */
        $rssFeed['type'] = $feed['type'];
        $rssFeed['numberOfItems'] = isset($feed['items']) ? $feed['items'] : 0;
        $rssFeed['itemsPerPage'] = isset($feed['itemsPerPage']) ? $feed['itemsPerPage'] : 4;
        $rssFeed['scrolledItems'] = isset($feed['scrolledItems']) ? $feed['scrolledItems'] : $rssFeed['itemsPerPage'];
        $rssFeed['useChannelTitle'] = isset($feed['useChannelTitle']) ? $feed['useChannelTitle'] : false;
        $rssFeed['direction'] = isset($feed['direction']) ? $feed['direction'] : 'left';
        $rssFeed['height'] = (!isset($feed['height']) || $feed['height'] == 0) ? false : $feed['height'];
        $rssFeed['dateFormat'] = isset($feed['dateFormat']) ? $feed['dateFormat'] : "j.n.";

        /*
         * first we look for a feed for the language we are in; if that fails we look
         * for url[*]; if that fails we set the url as false
         */
        $language = $interface->get_template_vars('userLang');
        if($language) {
            $rssFeed['url'] = isset($feed['url'][$language]) ?
                   $feed['url'][$language] : false;
        }
        if(!$rssFeed['url']) {
            $rssFeed['url'] = isset($feed['url']['*']) ?
                   $feed['url']['*'] : false;
        }
        if(!$rssFeed['url']) {
            $rssFeed['url'] = false;
        }

        if($rssFeed['url']) {
            $rss =& new XML_RSS($rssFeed['url']);
            $rss->parse();

            $channelInfo = $rss->getChannelInfo();
            $rssFeed['channelURL'] = $channelInfo['link'];

            if ($rssFeed['numberOfItems']>0) {
                $rssFeed['items'] = array_slice($rss->getItems(), 0, $rssFeed['numberOfItems']);
            } else {
                $rssFeed['items'] = $rss->getItems();
            }

            /* process the raw data in the array before passing it on to the
             * template */
            foreach($rssFeed['items'] as &$item) {
                /* to find the item image, first we look for enclosure elements in the
                 * feed item... */
                if(array_key_exists("enclosures", $item)) {
                    if(count($item['enclosures']) > 0) {
                        foreach($item['enclosures'] as $enclosure) {
                            if(is_int(stripos($enclosure['type'], "image"))) {
                                $item['imageUrl'] = $enclosure['url'];
                                break;
                            }
                        }
                    }
                }
                /* ...and if that fails, we try to extract the image url from the
                 * description element */
                if(!array_key_exists("imageUrl", $item)) {
                    preg_match("/src=\"([^\"]*)/", $item['description'], $matches);
                    $item['imageUrl'] = $matches[1];
                }

                /* remove all HTML tags */
                $item['description'] = strip_tags($item['description']);
                
                /* process and format the date */
                if(array_key_exists("dc:date", $item)) {
                    $dateTime = DateTime::createFromFormat(DATE_ISO8601, $item['dc:date']);
                } elseif(array_key_exists("pubdate", $item)) {
                    $dateTime = DateTime::createFromFormat(DATE_RFC2822, $item['pubdate']);
                }
                $item['date'] = FALSE;
                if($dateTime) {
                    $item['date'] = $dateTime->format($rssFeed['dateFormat']);
                }
            }
            
            /* calculate the scroll speed for the carousel */
            if($rssFeed['type'] == 'carousel') {
                $rssFeed['scrollSpeed'] = 1000 *
                                          ($rssFeed['scrolledItems'] /
                                          $rssFeed['itemsPerPage']);
            }
        
            $interface->assign('rssFeed', $rssFeed);
            $interface->display('Search/rss.tpl');
        }
    }
}
