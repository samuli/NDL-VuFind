<!-- START of: Search/home-content.sv.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="siteDescription">
        <h2>För alla som söker information och upplevelser</h2>
        <p>Finna är en sökportal som samlar material från olika arkiv, bibliotek och museer. Innehållet utökas kontinuerligt.
</p><p>I Finna kan du också bläddra och läsa i flera hundratusen<a href='{$url}/Search/Results?lookfor=&type=AllFields&prefiltered=-&filter[]=online_boolean%3A"1"&view=list'> e-resurser.</a></p>
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
<div id="home-timeline" class="section clearfix">
  <div class="content">
    <p class="grid_18"><span class="large">Genom att begränsa sökningen </span> till en viss tidsintervall kan du hitta bilder, verk, föremål, dokument eller
    annat material från en viss tid. Sökningen begränsas enligt framställningsår.
    </p>
  </div>
  {include file="Search/Recommend/DateRangeVisAjax.tpl"}
</div>
{* <!--
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
        <h2>Pröva geografisk sökningen</h2>
        <p>Du kan också begränsa sökningen på kartan. För närvarande ingår ca 12 630 poster i geografisk sökningen.</p>
        <a class="button" href="{$url}/Search/Advanced#mapSearch">Till geografisk sökningen</a>
      </div>
    </div>
  </div>
</div>
--> *}

<!-- END of: Search/home-content.sv.tpl -->
