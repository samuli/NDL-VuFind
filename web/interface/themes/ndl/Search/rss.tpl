<!-- START of: Search/rss.tpl -->

{* requires XML_RSS (pear install XML_RSS) *}

{php}

$feed = $this->get_template_vars('rssFeed');

if(($feed['type'] == "carousel") ||
   ($feed['type'] == "carousel-small") ||
   ($feed['type'] == "carousel-notext")) {
    echo "<div class=\"carousel-direction-" . $feed['direction'] . "\">";
    echo "<ul id=\"NDLCarousel\"";

    $classes = "";
    if($feed['type'] == "carousel-notext") {
        $classes .= "noText ";
    } elseif($feed['type'] == "carousel-small") {
        $classes .= "small ";
    } elseif($feed['type'] == "carousel") {
        $classes .= "includeDescription ";
        $includeDescription = true;
    }

    if($classes != "") {
        echo " class=\"" . trim($classes) . "\"";
    }

    echo ">\n";

    foreach ($feed['items'] as $item) {
        $title = $item['title'];
        $content = strip_tags($item['description']);

        /* to find the item image, first we look for enclosure elements in the
         * feed item... */
        $imageUrl = false;
        if(count($item['enclosures'])>0) {
            foreach($item['enclosures'] as $enclosure) {
                if(is_int(stripos($enclosure['type'], "image"))) {
                    $imageUrl = $enclosure['url'];
                    break;
                }
            }
        }
        /* ...and if that fails, we try to extract the image url from the
         * description element */
        if(!$imageUrl) {
            preg_match("/src=\"([^\"]*)/", $item['description'], $matches);
            $imageUrl = $matches[1];
        }
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

    $this->assign("scrollSpeed", 1000 * ($feed['scrolledItems'] / $feed['itemsPerPage']));

    {/php}
    
    <ul id="NDLCarouselNavi"><li id="prev" /><li id="next" /></ul>

    {literal}

    <script>
        $(document).ready(function(){
            
            // Determine height if it is not set
            {/literal}{php}
                if (!$rssFeed['height']) :
            {/php}{literal}
            var carouselContainer = $('#carouselContainer .content');
            var carouselWidth = carouselContainer.width();
            var carouselHeight = 
                Math.floor((carouselWidth - ({/literal}{$rssFeed.itemsPerPage}{literal} * 10))  / 
                {/literal}{$rssFeed.itemsPerPage}{literal} * 1.36);
                    
            // If height is set
            {/literal}{php}
                else : 
            {/php}{literal}
                var carouselHeight = {/literal}{$rssFeed.height}{literal};
            {/literal}{php}
                endif;
            {/php}{literal} 
            
            $('#NDLCarousel').carouFredSel({
                responsive: true,
                direction:{/literal}'{$rssFeed.direction}'{literal},
                auto: 8000,
                width: "100%",
                items: {/literal}{$rssFeed.itemsPerPage}{literal},
                height: carouselHeight,
                prev: "#NDLCarouselNavi #prev",
                next: "#NDLCarouselNavi #next",
                swipe: {
                    onTouch: true,
                    onMouse: false
                },
                scroll: {
                  items: {/literal}{$rssFeed.scrolledItems}{literal},
                  duration: {/literal}{$scrollSpeed}{literal},
                  fx: "directscroll",
                  pauseOnHover: true
                }
            });
            
            // Also set height to individual list items
            $('#NDLCarousel li').css({
                'height': carouselHeight,
                'line-height' : carouselHeight + 'px'
            });
                
            // Function to refresh carousel when layout changes
            prevWidth = carouselWidth;
            refreshCarousel = function() {
                if(carouselContainer.width()!=prevWidth){
                    prevWidth = carouselContainer.width();
                    calculateCarouselDimensions();
                }
            }
            $(window).resize(refreshCarousel());
            
            
            calculateCarouselDimensions = function() {
                
                var containerWidth = $('#NDLCarousel.includeDescription li').width();
                var containerHeight = $('#NDLCarousel.includeDescription li').height();
                var containerRatio = containerWidth / containerHeight;
                  
                $('#NDLCarouselNavi li').css({
                    'top'         : -(containerHeight / 2) - $('#NDLCarouselNavi #prev').height() / 2
                });

                $('#NDLCarousel.includeDescription img').each(function(){
                    $(this).imagesLoaded(function() {
                        var imgWidth = $(this).width();
                        var imgHeight = $(this).height();

                        var imgRatio = imgWidth / imgHeight;
                        var newWidth = 0;
                        var newHeight = 0;

                        if(containerRatio < imgRatio) {
                            newWidth = containerHeight * imgRatio;
                            newHeight = containerHeight;
                        } else {
                            newWidth = containerWidth;
                            newHeight = containerWidth / imgRatio;
                        }

                        var verticalPosition = (newHeight - containerHeight) / 2;
                        var horizontalPosition = (newWidth - containerWidth) / 2;

                        $(this).css({
                            'height'      : newHeight,
                            'width'       : newWidth,
                            'position'    : 'absolute',
                            'left'        : - horizontalPosition,
                            'top'         : - verticalPosition,
                            'display'     : 'none',
                            'visibility'  : 'visible'
                        });

                       $(this).fadeIn(300);
                    });
                });
            };
                
            calculateCarouselDimensions();
              

            $('#NDLCarousel').css(
                "visibility",
                "visible"
            );

                    // Make individual pick-ups clickable
            $('#NDLCarousel li').click(function() {
                        var href = $(this).find('a').attr('href');
                        window.location.href = href;
            });
            
            // Set title and text position
            $('#NDLCarousel.includeDescription h4').each(function() {
                var thisHeight = $(this).find('a').height() + 12; // 6px + 6px padding
                var topPosition = carouselHeight - thisHeight;

                $(this).css('top', topPosition);
                $(this).siblings('p').css('top', thisHeight);
                
            });
            
            $('#NDLCarousel.includeDescription li').mouseenter(function() {
                 $(this).children('h4').stop().animate({
                    top: 0
                    }, 50, function() {
                        $(this).siblings('p').stop(true,true).delay(50).fadeIn(200);
                        });
            });
             
            $('#NDLCarousel.includeDescription li').mouseleave(function() {
                h4Height = $(this).find('a').height() + 12;
                 $(this).children('h4').stop().animate({
                    top: carouselHeight - h4Height
                }, 100);
                $(this).children('p').stop(true, true).fadeOut(200);
            });
         });
    </script>
    {/literal}{php}
} else {
    if($feed['useChannelTitle']) {
        echo "<h2>" . $feed['channelInfo']['title'] . "</h2>\n";
    }
    echo "<ul class=\"NDLNews\">";
    foreach ($feed['items'] as $item ) {
            if($item['dc:date']) {
                $dateTime = DateTime::createFromFormat(DATE_ISO8601, $item['dc:date']);
            } elseif($item['pubdate']) {
                $dateTime = DateTime::createFromFormat(DATE_RFC2822, $item['pubdate']);
            }
            $date = FALSE;
            if($dateTime && $feed['dateFormat']) {
                $date = $dateTime->format($feed['dateFormat']);
            }
            $title = $item['title'];
            $url   = $item['link'];
            echo "<li>";
            if($date) {
                echo "<span class=\"date\">$date</span> ";
            }
            echo "<a href=\"$url\">$title</a></li>\n";
    }
    {/php}
    <li><a href="{$rssFeed.channelURL}">{translate text="More"}&hellip;</a></li>
    </ul></div>
    {php}

}

{/php}


<!-- END of: Search/rss.tpl -->
