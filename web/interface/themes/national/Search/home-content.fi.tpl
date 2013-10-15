<!-- START of: Search/home-content.fi.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="siteDescription">
        <h2>Tietoa tarvitseville ja elämyksiä etsiville</h2>
        <p>Finna on tiedonhakupalvelu, joka kokoaa yhteen aineistoja arkistoista, kirjastoista ja museoista. Sisältö täydentyy jatkuvasti uusilla aineistoilla.
</p><p>Palvelun kautta pääset selaamaan ja lukemaan myös satoja tuhansia <a href='{$url}/Search/Results?lookfor=&type=AllFields&prefiltered=-&filter[]=online_boolean%3A"1"&view=list'>sähköisiä aineistoja.</a></p>
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
    <p><span class="large">Aikarajaushaulla löydät </span> kuvat, teokset, esineet, asiakirjat ja muut aineistot historiasta nykypäivään.
    <br />Rajaus kohdistuu valmistusvuoteen.
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
