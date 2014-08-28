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
require_once 'XML/RSS.php';

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
        $rssFeed['id'] = $id;
        $rssFeed['type'] = $feed['type'];
        $rssFeed['numberOfItems'] = isset($feed['items']) ?
            $feed['items'] : 0;
        $rssFeed['itemsPerPage'] = isset($feed['itemsPerPage']) ?
            $feed['itemsPerPage'] : 4;
        $rssFeed['scrolledItems'] = isset($feed['scrolledItems']) ?
            $feed['scrolledItems'] : $rssFeed['itemsPerPage'];
        $rssFeed['useChannelTitle'] = isset($feed['useChannelTitle']) ?
            $feed['useChannelTitle'] : false;
        $rssFeed['direction'] = isset($feed['direction']) ?
            $feed['direction'] : 'left';
        $rssFeed['height'] = (!isset($feed['height']) ||
            $feed['height'] == 0) ? false : $feed['height'];
        $rssFeed['dateFormat'] = isset($feed['dateFormat']) ?
            $feed['dateFormat'] : "j.n.";
        $rssFeed['images'] = isset($feed['images']) ?
            $feed['images'] : false;
        $rssFeed['moreLink'] = isset($feed['moreLink']) ?
            $feed['moreLink'] : true;
        $rssFeed['title'] = isset($feed['title']) ?
            $feed['title'] : false;
        $rssFeed['itemTitleTrunc'] = isset($feed['itemTitleTrunc']) ?
            $feed['itemTitleTrunc'] : 0;
        $rssFeed['height'] = isset($feed['height']) ?
            str_replace('px', '', $rssFeed['height']) : 0;

        if (strlen(trim($rssFeed['dateFormat'])) == 0) {
            $rssFeed['date'] = false;
        } else {
            $rssFeed['date'] = true;
        }

        /*
         * first we look for a feed for the language we are in; if that fails we look
         * for url[*]; if that fails we set the url as false
         */
        $language = $interface->get_template_vars('userLang');
        if ($language) {
            $rssFeed['url'] = isset($feed['url'][$language]) ?
                   $feed['url'][$language] : false;
        }
        if (!$rssFeed['url']) {
            $rssFeed['url'] = isset($feed['url']['*']) ?
                   $feed['url']['*'] : false;
        }
        if (!$rssFeed['url']) {
            $rssFeed['url'] = false;
        }

        if ($rssFeed['url']) {
          
            $ch = curl_init($rssFeed['url']);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/4.0');
            $rssString = curl_exec($ch);
            curl_close($ch);
            
            if (!$rssString) {
                return;
            }
            
            $rss =& new XML_RSS($rssString);
            
            $rss->parse();

            $channelInfo = $rss->getChannelInfo();
            $rssFeed['channelURL']
                = isset($channelInfo['link']) ? $channelInfo['link'] : null;

            if ($rssFeed['numberOfItems']>0) {
                $rssFeed['items']
                    = array_slice($rss->getItems(), 0, $rssFeed['numberOfItems']);
            } else {
                $rssFeed['items'] = $rss->getItems();
            }

            if (isset($feed['title']) && trim($feed['title']) == 'rss') {
                $rssFeed['title']
                    = isset($rss->channel['title']) ? $rss->channel['title'] : false;
            }

            // Truncate titles longer than itemTitleTrunc if > 0
            $truncValue = $rssFeed['itemTitleTrunc'];
            if ($truncValue > 0) {
                foreach ($rssFeed['items'] as &$item) {
                    $itemTitle = $item['title'];
                    if (strlen($itemTitle) > $truncValue) {
                        $item['title'] = trim(
                            mb_substr($itemTitle, 0, $truncValue, 'UTF-8')
                        ) . '&hellip;';
                    }
                }
            }


            /* process the raw data in the array before passing it on to the
             * template */
            foreach ($rssFeed['items'] as &$item) {
                /* to find the item image, first we look for
                enclosure elements in the  feed item... */
                if (array_key_exists("enclosures", $item)) {
                    if (count($item['enclosures']) > 0) {
                        foreach ($item['enclosures'] as $enclosure) {
                            if (is_int(stripos($enclosure['type'], "image"))) {
                                $item['imageUrl'] = $enclosure['url'];
                                break;
                            }
                        }
                    }
                }
                /* ...and if that fails, we try to extract the image url from the
                 * content:encoded element... */
                if (!array_key_exists("imageUrl", $item)
                    && array_key_exists('content:encoded', $item)
                ) {
                    // let's load the HTML
                    $dom = new DOMDocument;
                    $dom->loadHTML($item['content:encoded']);

                    /*
                     * first, let's see if there are <a> elements with <img>
                     * children; they are likely links to full-size images
                     */
                    $anchors = $dom->getElementsByTagName('a');
                    foreach ($anchors as $anchor) {
                        foreach ($anchor->childNodes as $anchorChild) {
                            $imageChild = false;
                            if ($anchorChild->nodeName == "img") {
                                $imageChild = true;
                                break;
                            }
                        }
                        if ($imageChild) {
                            $href = $anchor->getAttribute('href');
                            if ($href) {
                                if ((substr($href, -4) == '.jpg')
                                    || (substr($href, -4) == '.gif')
                                    || (substr($href, -4) == '.png')
                                    || (substr($href, -5) == '.jpeg')
                                ) {
                                    $item['imageUrl'] = $href;
                                    break;
                                }
                            }
                        }
                    }

                    /*
                     * if there are no <a> elements with <img> children, let's
                     * settle for an <img> element with no <a> parent
                     */
                    if (!array_key_exists("imageUrl", $item)) {
                        $images = $dom->getElementsByTagName('img');
                        if ($images
                            && $images->item(0)
                            && $images->item(0)->getAttribute('src')
                        ) {
                            $item['imageUrl']
                                = $images->item(0)->getAttribute('src');
                        }
                    }
                }
                /* ...and if that fails, we try to extract the image url from the
                 * description element */
                if (!array_key_exists("imageUrl", $item)
                    && array_key_exists('description', $item)
                ) {
                    preg_match("/src=\"([^\"]*)/", $item['description'], $matches);
                    if ($matches) {
                        $item['imageUrl'] = $matches[1];
                    }
                }

                /* remove all HTML tags */
                if (array_key_exists('description', $item)) {
                    $item['description'] = strip_tags($item['description']);
                }

                /* process and format the date */
                if (array_key_exists("dc:date", $item)) {
                    $dateTime
                        = DateTime::createFromFormat(DATE_ISO8601, $item['dc:date']);
                } elseif (array_key_exists("pubdate", $item)) {
                    $dateTime
                        = DateTime::createFromFormat(DATE_RFC2822, $item['pubdate']);
                }
                $item['date'] = false;
                if (isset($dateTime) && $dateTime) {
                    $item['date'] = $dateTime->format($rssFeed['dateFormat']);
                }
            }

            /* calculate the scroll speed for the carousel */
                $rssFeed['scrollSpeed'] = 1000 *
                                          ($rssFeed['scrolledItems'] /
                                          $rssFeed['itemsPerPage']);

            $interface->assign('rssFeed', $rssFeed);
            $interface->display('Search/rss.tpl');
        }
    }
}
