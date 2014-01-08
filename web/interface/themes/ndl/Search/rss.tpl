<!-- START of: Search/rss.tpl -->

{* requires XML_RSS (pear install XML_RSS) *}

{php}

$feed = $this->get_template_vars('rssFeed');

if(($feed['type'] == "carousel") ||
   ($feed['type'] == "carousel-small") ||
   ($feed['type'] == "carousel-notext")) {
    echo "<div class=\"carousel-direction-" . $feed['direction'] . "\">";
    if ($feed['title']) {
        $feedTitle = ($feed['title'] == 'custom') ? translate('feed_title_'.$feed['id']) : $feed['title'];
        echo "<h2>" . $feedTitle . "</h2>\n";
   }
    echo "<ul id=\"NDLCarousel-" . $feed['id'] . "\"";

    $classes = "";
    if($feed['type'] == "carousel-notext") {
        $classes .= "noText ";
    } elseif($feed['type'] == "carousel-small") {
        $classes .= "small ";
    } elseif($feed['type'] == "carousel") {
        $classes .= "includeDescription ";
        $includeDescription = true;
    }

    echo " class=\"NDLCarousel " . trim($classes) . "\"";

    echo ">\n";

    foreach ($feed['items'] as $item) {
        $title = $item['title'];
        $content = $item['description'];
        $imageUrl = $item['imageUrl'];
        $url   = $item['link'];
        echo "<li>";
        echo "<img src=\"$imageUrl\" alt=\"\" />";
        echo "<h4><a href=\"$url\">$title&nbsp;&raquo;</a></h4>";
        if($includeDescription) {
            echo "<p>" . $content . "</p>";
        }
        echo "</li>\n";
    }
    echo "</ul>";

    {/php}
    
    <ul class="NDLCarouselNavi" id="NDLCarouselNavi-{$rssFeed.id}"><li class="prev carousel-control"/><li class="next carousel-control right"/></ul>

    {literal}

    <script>
        $(document).ready(function(){
            c{/literal}{$rssFeed.id}{literal} = new NDLCarousel(
                '{/literal}{$rssFeed.id}',
                {$rssFeed.itemsPerPage},
                {$rssFeed.scrolledItems},
                {$rssFeed.scrollSpeed},
                {$rssFeed.height}
                {literal});
         });
    </script>
    {/literal}{php}
} else {
    if($feed['useChannelTitle']) {
        echo "<h2>" . $feed['channelInfo']['title'] . "</h2>\n";
    }
    echo "<ul class=\"NDLNews\">";
    foreach ($feed['items'] as $item ) {
            $title = $item['title'];
            if(array_key_exists('imageUrl', $item)) {
	       	$imageUrl = $item['imageUrl'];
            }
	    $url   = $item['link'];
            $date  = $item['date'];
            echo "<li>";

            /*
             * render date if it is set in the feed item and is not disabled
             * for the whole feed
             */
            if($feed['date'] && $date) {
                echo "<span class=\"date\">$date</span> ";
            }

            /*
             * render image if an image exists for the item and if images
             * are not disabled for the whole feed
             */
            echo "<a href=\"$url\">";
            if($feed['images'] && $imageUrl) {
                echo "<img src=\"$imageUrl\" alt=\"\" />";
            }

            echo "<span class=\"title\">$title</span></a></li>\n";
    }
    {/php}
    {if $rssFeed.moreLink}
      <li class="moreLink"><a href="{$rssFeed.channelURL}">{translate text="More"}&hellip;</a></li>
    {/if}
    </ul></div>
    {php}

}

{/php}


<!-- END of: Search/rss.tpl -->
