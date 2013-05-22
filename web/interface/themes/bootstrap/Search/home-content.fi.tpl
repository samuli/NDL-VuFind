<!-- START of: Search/home-content.fi.tpl -->

<div class="span12 well-small homeContent">
<div class="row-fluid">
  <div class="span7 well-small">
    <h3>Suomen arkistojen, kirjastojen ja museoiden aarteet yhdellä haulla</h3>
    <p class="">Keräsimme aineistotiedot useista Suomen arkistoista, kirjastoista ja museoista yhteen paikkaan. Yhdellä haulla saat tuloksia kaikista mukana olevista kokoelmista.</p>
    <p class="big"><a href="{$path}/Content/about">Lue lisää</a> tai kokeile hakua!</p>
  </div>
  
  <div class="span5 well-small">
    <div class="row-fluid">
      <div class="span12">
        <h4>Haulla löydät:</h4>
      </div>
    </div>
    <div class="row-fluid">
      <div class="span12">
        <ul class="unstyled pull-left">
          <li><span class="iconlabel formatdocument">{*<i class="icon-file"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FDocument"'>Asiakirjoja</a></span></li>
          <li><span class="iconlabel formatphysicalobject">{*<i class="icon-asterisk"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FPhysicalObject"'>Esineitä</a></span></li>
          <li><span class="iconlabel formatmap">{*<i class="icon-globe"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FMap"'>Karttoja</a></span></li>
          <li><span class="iconlabel formatbook">{*<i class="icon-book"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FBook"'>Kirjoja</a></span></li>
          <li><span class="iconlabel formatimage">{*<i class="icon-picture"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FImage"'>Kuvia</a></span></li>
          <li><span class="iconlabel formatjournal">{*<i class="icon-list-alt"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FJournal"'>Lehtiä&nbsp;&amp;&nbsp;artikkeleita</a></span></li>
        </ul>
        <ul class="unstyled pull-right">
          <li><span class="iconlabel formatmusicalscore">{*<i class="icon-music"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FMusicalScore"'>Nuotteja</a></span></li>
          <li><span class="iconlabel formatthesis">{*<i class="icon-bookmark"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FThesis"'>Opinnäytteitä</a></span></li>
          <li><span class="iconlabel formatworkofart">{*<i class="icon-camera"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FWorkOfArt"'>Taideteoksia</a></span></li>
          <li><span class="iconlabel formatdatabase">{*<i class="icon-hdd"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FDatabase"'>Tietokantoja</a></span></li>
          <li><span class="iconlabel formatvideo">{*<i class="icon-film"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FVideo"'>Videoita</a></span></li>
          <li><span class="iconlabel formatsoundrecording">{*<i class="icon-volume-up"></i>&nbsp;*}<a href='{$url}/Search/Results?filter[]=format%3A"0%2FSound"'>Äänitteitä</a></span></li>
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

<!-- END of: Search/home-content.fi.tpl -->
