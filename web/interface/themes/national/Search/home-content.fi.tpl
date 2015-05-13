<!-- START of: Search/home-content.fi.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14 finnafifrontpage">
      <div id="siteDescription">
        <h2>Tietoa tarvitseville ja elämyksiä etsiville</h2>
        <p>Finna.fi:stä löydät jo {$indexRecordCount} aineistotietoa.<br />
        <a href="{$path}/Content/Organisations">Kenen aineistoja on finna.fi:ssä?</a></p>
        <p>Finnassa voit katsella verkossa saatavilla olevia sisältöjä, uusia lainoja, tilata aineistoja, ja paljon muuta.<br />
        <a href="{$path}/Content/about">{translate text="navigation_about_finna"}</a></p>
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
    <p class="grid_18"><span class="large">Aikarajaushaulla löydät </span> kuvat, teokset, esineet, asiakirjat ja muut aineistot historiasta nykypäivään.
    Rajaus kohdistuu valmistusvuoteen.
    </p>
  </div>
  {include file="Search/Recommend/DateRangeVisAjax.tpl"}
</div>
{* <!--
<div id="popular-map" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="topSearches">
        <h2>10 suosituinta hakua</h2>
        <div id="popularSearches" class="recent-searches"><div class="loading"></div></div>
        {include file="AJAX/loadPopularSearches.tpl"}
      </div>
    </div>
    <div class="grid_10 push_right">
      <div id="mapSearchHome">
        <h2>Kokeile maantieteellistä hakua</h2>
        <p>Voit rajata hakuasi myös kartalla. Maantieteellisen haun piirissä on tällä hetkellä noin 12 630 aineistotietoa.</p>
        <a class="button" href="{$url}/Search/Advanced#mapSearch">Maantieteelliseen hakuun</a>
      </div>
    </div>
  </div>
</div>
--> *}
    
<!-- END of: Search/home-content.fi.tpl -->
