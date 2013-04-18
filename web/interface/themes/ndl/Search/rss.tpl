<!-- START of: Search/rss.tpl -->

<!-- requires XML_RSS (pear install XML_RSS) -->

{php}

$confArray = $this->get_template_vars('rssFeeds');
$feed = $confArray[$this->get_template_vars('rssId')];
$type = $feed['type'];
$items = $feed['items'];
$itemsPerPage = $feed['itemsPerPage'];

require_once "XML/RSS.php";
$rss =& new XML_RSS($feed['url']);
$rss->parse();

if ($items>0) {
    $rssItems = array_slice($rss->getItems(), 0, $items);
} else {
    $rssItems = $rss->getItems();
}

if(($type == "carousel") ||
   ($type == "carousel-small") ||
   ($type == "carousel-notext")) {
    echo "<ul id=\"NDLCarousel\"";

    $classes = "";
    if($type == "carousel-notext") {
        $classes .= "noText ";
    } elseif($type == "carousel") {
        $classes .= "includeDescription ";
        $includeDescription = true;
    }

    if($classes != "") {
        echo " class=\"" . trim($classes) . "\"";
    }

    echo ">\n";

    foreach ($rssItems as $item) {
        $title = $item['title'];
        $content = strip_tags($item['description']);
        preg_match("/src=\"([^\"]*)/", $item['description'], $matches);
        $imageUrl = $matches[1];
        $url   = $item['link'];
        echo "<li>";
        echo "<img src=\"$imageUrl\" alt=\"\" />";
        echo "<h4><a href=\"$url\">$title</a></h4>";
        if($includeDescription) {
            echo "<p>" . $content . "</p>";
        }
        echo "</li>\n";
    }
    echo "</ul>";

    $this->assign("itemsPerPage", $itemsPerPage);

    {/php}
    
    <ul id="NDLCarouselNavi"><li id="prev" /><li id="next" /></ul>

    {literal}

    <script>
        $(document).ready(function(){
            $('#NDLCarousel').carouFredSel({
                responsive: true,
                auto: 8000,
                width: "100%",
                items: {/literal}{$itemsPerPage}{literal},
                height: 200,
                prev: "#NDLCarouselNavi #prev",
                next: "#NDLCarouselNavi #next",
                scroll: {
                  items: 1,
                  duration: 300,
                  swipe: true,
                  fx: "directscroll"
                }
            });
    
            $(window).resize(function() {
                var containerWidth = $('#NDLCarousel.includeDescription li').width();
                var containerHeight = $('#NDLCarousel.includeDescription li').height();
                var containerRatio = containerWidth / containerHeight;

                $('#NDLCarousel.includeDescription img').each(function(){

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

                    $(this).css("height", newHeight + "px");
                    $(this).css("width", newWidth + "px");
                    $(this).css(
                        "left",
                        "50%"
                    );
                    $(this).css(
                        "top",
                        "50%"
                    );
                    $(this).css(
                        "margin-left",
                        "-" + parseInt($(this).width()) / 2 + "px"
                    );
                    $(this).css(
                        "margin-top",
                        "-" + parseInt($(this).height()) / 2 + "px"
                    );
                });
            });
              
            $(window).resize();

            $('#NDLCarouselNavi').css(
                "display",
                "block"
            );
            $('#NDLCarousel').css(
                "visibility",
                "visible"
            );

            $('#NDLCarousel li').click(function() {
                var href = $(this).find('a').attr('href');
                window.location.href = href;
            })

        });
    </script>
    {/literal}{php}
} else {
    echo "<ul>";
    foreach ($rssItems as $item ) {
            $title = $item['title'];
            $url   = $item['link'];
            echo "<li><a href=\"$url\">$title</a></li>\n";
    }
    echo "</ul>";
}

{/php}


<!-- END of: Search/rss.tpl -->
