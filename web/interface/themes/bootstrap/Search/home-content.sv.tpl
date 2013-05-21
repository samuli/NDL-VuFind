<!-- START of: Search/home-content.sv.tpl -->

<div class="span12 well-small homeContent">
<div class="row-fluid">
  <div class="span7 well-small">
    <h3>Arkivens, bibliotekens och museernas material tillgängligt i samma tjänst</h3>
    <p class="">Tack vare kundgränssnittet utgör bibliotekens, arkivens och museernas material en överskådlig helhet. Du kan hitta inte enbart den information du söker, utan också annan information som anknyter till området.</p>
    <p class="big"><a href="{$path}/Content/about">Läs mer</a> eller prova sökningen!</p>
  </div>
  
  <div class="span5 well-small">
    <div class="row-fluid">
      <div class="span12">
        <h4>Här kan du hitta:</h4>
      </div>
    </div>
    <div class="row-fluid">
      <div class="span12">
        <ul class="unstyled pull-left">
          <li><span class="iconlabel formatthesis">{*<i class="icon-bookmark"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FThesis"'>Avhandlingar</a></span></li>
          <li><span class="iconlabel formatimage">{*<i class="icon-picture"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FImage"'>Bilder</a></span></li>
          <li><span class="iconlabel formatbook">{*<i class="icon-book"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FBook"'>Böcker</a></span></li>
          <li><span class="iconlabel formatdatabase">{*<i class="icon-hdd"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FDatabase"'>Databaser</a></span></li>
          <li><span class="iconlabel formatdocument">{*<i class="icon-file"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FDocument"'>Dokument</a></span></li>
          <li><span class="iconlabel formatphysicalobject">{*<i class="icon-asterisk"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FPhysicalObject"'>Föremål</a></span></li>

        </ul>
        <ul class="unstyled pull-right">
          <li><span class="iconlabel formatmap">{*<i class="icon-globe"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FMap"'>Kartor</a></span></li>
          <li><span class="iconlabel formatworkofart">{*<i class="icon-camera"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FWorkOfArt"'>Konstverken</a></span></li>
          <li><span class="iconlabel formatsoundrecording">{*<i class="icon-volume-up"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FSound"'>Ljudinspelningar</a></span></li>
          <li><span class="iconlabel formatmusicalscore">{*<i class="icon-music"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FMusicalScore"'>Musikalier</a></span></li>
          <li><span class="iconlabel formatjournal">{*<i class="icon-list-alt"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FJournal"'>Tidskrifter&nbsp;&amp;&nbsp;artiklar</a></span></li>
          <li><span class="iconlabel formatvideo">{*<i class="icon-film"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FVideo"'>Videoklipp</a></span></li>
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

<!-- END of: Search/home-content.sv.tpl -->
