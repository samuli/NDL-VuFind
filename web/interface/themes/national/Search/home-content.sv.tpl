<!-- START of: Search/home-content.sv.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="siteDescription">
        <h2>För dig som söker information och intressanta upplevelser</h2>
        <p>Finna är en ny sökportal för alla som använder arkivens, bibliotekens och museernas tjänster. </p>
        <p>Testa sökfunktionen, <a href="{$path}/Feedback/Home">ge respons</a> eller <a class="color-violet" href="{$path}/Content/about">läs mer</a> om tjänsten i testversionen av Finna!</p>
      </div>
    </div>
    <div class="grid_10 push_right">
      <div>
        {include file="Search/document-type-list.tpl"}
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
        <a class="button" href="{$url}/Search/Advanced#mapSearch">Till kartsökningen</a>
      </div>
    </div>
  </div>
</div>
    
<!-- END of: Search/home-content.sv.tpl -->
