<!-- START of: Search/home-content.sv.tpl -->

<div class="home-section first columns clearfix">
  <div class="container_24">
    <div>

    </div>
    <div>
      <h2>Du kan söka efter...</h2>
    <ul>
      <li><span class="iconlabel formatthesis"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FThesis"'>Avhandlingar</a></span></li>
      <li><span class="iconlabel formatimage"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FImage"'>Bilder</a></span></li>
      <li><span class="iconlabel formatbook"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FBook"'>Böcker</a></span></li>
      <li><span class="iconlabel formatdocument"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FDocument"'>Dokument</a></span></li>
      <li><span class="iconlabel formatdatabase"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FDatabase"'>Databaser</a></span></li>
      <li><span class="iconlabel formatphysicalobject"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FPhysicalObject"'>Föremål</a></span></li>
    </ul>
    <ul>
      <li><span class="iconlabel formatmap"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FMap"'>Kartor</a></span></li>
      <li><span class="iconlabel formatworkofart"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FWorkOfArt"'>Konstverken</a></span></li>
      <li><span class="iconlabel formatsound"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FSound"'>Ljudinspelningar</a></span></li>
      <li><span class="iconlabel formatmusicalscore"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FMusicalScore"'>Musikalier</a></span></li>
      <li><span class="iconlabel formatjournal"><a class="twoLiner" href='{$url}/Search/Results?filter[]=format%3A"0%2FJournal"'>Tidskrifter och artiklar</a></span></li>
      <li><span class="iconlabel formatvideo"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FVideo"'>Videoklipp</a></span></li>
    </ul>
    </div>
  </div>
</div>
<div class="home-section second clearfix">
  <div class="container_24">

  </div>
</div>
<div class="home-section third columns clearfix">
  <div class="container_24">
    <div class="popularSearchesWrap">
      <h2>De 10 populäraste sökningarna</h2>
      <div id="popularSearches" class="recent-searches"><div class="loading"></div></div>
      {include file="AJAX/loadPopularSearches.tpl"}
    </div>
    <div>
      <div class="mapSearchHome">
        <h2>Pröva kartsökningen</h2>
        <p>Du kan också begränsa sökningen på kartan. För närvarande ingår ca 12630 poster i kartsökningen.</p>
        <a class="button" href="{$url}/Search/Advanced">Till kartsökningen</a>
      </div>
    </div>
  </div>
</div>
    
<!-- END of: Search/home-content.sv.tpl -->
