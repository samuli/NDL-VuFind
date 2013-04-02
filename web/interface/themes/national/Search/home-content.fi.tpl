<!-- START of: Search/home-content.fi.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="siteDescription">
        <h2>Tietoa tarvitseville ja elämyksiä etsiville</h2>
        <p>Finna on uudenlainen tiedonhakupalvelu kaikille arkistojen, kirjastojen ja museoiden palveluiden käyttäjille.</p>
        <p>Finna on nyt testikäytössä. Kokeile hakua, <a href="{$path}/Feedback/Home">anna palautetta</a> tai <a class="color-violet" href="{$path}/Content/about">lue lisää</a> palvelusta!</p>
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
        <h2>10 suosituinta hakua</h2>
        <div id="popularSearches" class="recent-searches"><div class="loading"></div></div>
        {include file="AJAX/loadPopularSearches.tpl"}
      </div>
    </div>
    <div class="grid_10 push_right">
      <div id="mapSearchHome">
        <h2>Kokeile karttahakua</h2>
        <p>Voit rajata hakuasi myös kartalla. Karttarajauksen piirissä on tällä hetkellä noin 12 630 aineistotietoa.</p>
        <a class="button" href="{$url}/Search/Advanced#mapSearch">Karttahakuun</a>
      </div>
    </div>
  </div>
</div>
    
<!-- END of: Search/home-content.fi.tpl -->
