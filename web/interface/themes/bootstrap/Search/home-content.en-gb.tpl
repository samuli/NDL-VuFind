<!-- START of: Search/home-content.en-gb.tpl -->

<div class="span12 well-small homeContent">
<div class="row-fluid">
  <div class="span7 well-small">
    <h3>The Treasures of Finnish archives, libraries and museums with a single search</h3>
    <p class="">We gathered the collections of several Finnish archives, libraries and museums into one place. With a single search you can get results from all of the included collections.</p>
    <p class="big"><a href="{$path}/Content/about">Read more</a> or try the search!</p>
  </div>
  
  <div class="span5 well-small">
    <div class="row-fluid">
      <div class="span12">
        <h4>With the search you can find:</h4>
      </div>
    </div>
    <div class="row-fluid">
      <div class="span12">
        <ul class="unstyled pull-left">
          <li><span class="iconlabel formatbook">{*<i class="icon-book"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FBook"'>Books</a></span></li>
          <li><span class="iconlabel formatdatabase">{*<i class="icon-hdd"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FDatabase"'>Databases</a></span></li>
          <li><span class="iconlabel formatdocument">{*<i class="icon-file"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FDocument"'>Documents</a></span></li>
          <li><span class="iconlabel formatimage">{*<i class="icon-picture"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FImage"'>Images</a></span></li>
          <li><span class="iconlabel formatjournal">{*<i class="icon-list-alt"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FJournal"'>Journals, Articles</a></span></li>
          <li><span class="iconlabel formatmap">{*<i class="icon-globe"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FMap"'>Maps</a></span></li>
        </ul>
        <ul class="unstyled pull-right">
          <li><span class="iconlabel formatmusicalscore">{*<i class="icon-music"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FMusicalScore"'>Musical scores</a></span></li>
          <li><span class="iconlabel formatphysicalobject">{*<i class="icon-asterisk"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FPhysicalObject"'>Physical Objects</a></span></li>
          <li><span class="iconlabel formatsoundrecording">{*<i class="icon-volume-up"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FSound"'>Sound Recordings</a></span></li>
          <li><span class="iconlabel formatthesis">{*<i class="icon-bookmark"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FThesis"'>Theses</a></span></li>
          <li><span class="iconlabel formatvideo">{*<i class="icon-film"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FVideo"'>Videos</a></span></li>
          <li><span class="iconlabel formatworkofart">{*<i class="icon-camera"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FWorkOfArt"'>Works of Art</a></span></li>
        </ul>
      </div>
    </div>
  </div>
</div>
</div>

{if $rssFeeds.carousel.active}      
<div class="row-fluid hidden-phone">
  <div id="carouselContainer" class="span12 section">
    <div class="content">
      {include file="Search/rss.tpl" rssId="carousel"}
    </div>
  </div>
</div>
{/if}

<!-- END of: Search/home-content.en-gb.tpl -->
