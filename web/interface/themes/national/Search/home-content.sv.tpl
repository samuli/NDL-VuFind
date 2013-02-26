<!-- START of: Search/home-content.sv.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="siteDescription">
        <h2>För dig som söker information och intressanta upplevelser</h2>
        <p class="big">Finna är en ny sökportal för alla som använder arkivens, bibliotekens och museernas tjänster. </p>
        <p class="big">Testa sökfunktionen, <a href="{$path}/Feedback/Home">ge respons</a> eller <a class="color-violet" href="{$path}/Content/about">läs mer</a> om tjänsten i testversionen av Finna!</p>
      </div>
    </div>
    <div class="grid_10 push_right">
      <div>
        <h2>Du kan söka efter...</h2>
        <ul class="first grid_4 suffix_1">
          <li><span class="iconlabel formatthesis"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FThesis"'>Avhandlingar</a></span></li>
          <li><span class="iconlabel formatimage"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FImage"'>Bilder</a></span></li>
          <li><span class="iconlabel formatbook"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FBook"'>Böcker</a></span></li>
          <li><span class="iconlabel formatdocument"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FDocument"'>Dokument</a></span></li>
          <li><span class="iconlabel formatdatabase"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FDatabase"'>Databaser</a></span></li>
          <li><span class="iconlabel formatphysicalobject"><a href='{$url}/Search/Results?filter[]=format%3A"0%2FPhysicalObject"'>Föremål</a></span></li>
        </ul>
        <ul class="grid_3">
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
</div>
<div id="content-carousel" class="section clearfix">
  <div class="content">
    <div id="carousel">
      {include file="Search/home-carousel.$userLang.tpl"}
    </div>
  </div>
</div>
<div id="popular-map" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="topSearches">
        <h2>De 10 populäraste sökningarna</h2>
        <div id="popularSearches" class="recent-searches"><div class="loading"></div></div>
        {include file="AJAX/loadPopularSearches.tpl"}
      </div>
    </div>
    <div class="grid_10 push_right">
      <div id="mapSearchHome">
        <h2>Pröva kartsökningen</h2>
        <p>Du kan också begränsa sökningen på kartan. För närvarande ingår ca 12630 poster i kartsökningen.</p>
        <a class="button" href="{$url}/Search/Advanced">Till kartsökningen</a>
      </div>
    </div>
  </div>
</div>
    
<!-- END of: Search/home-content.sv.tpl -->
