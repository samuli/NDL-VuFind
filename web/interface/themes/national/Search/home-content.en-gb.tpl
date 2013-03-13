<!-- START of: Search/home-content.en-gb.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="siteDescription">
        <h2>For seekers of information and inspiration</h2>
        <p>Finna is a new kind of information search service for all users of archives, libraries and museums.</p>
        <p>Finna is currently in test use. Try the search, <a href="{$path}/Feedback/Home">give feedback</a> or <a class="color-violet" href="{$path}/Content/about">read more</a> about the service!</p>
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
        <h2>10 most popular searches</h2>
        <div id="popularSearches" class="recent-searches"><div class="loading"></div></div>
        {include file="AJAX/loadPopularSearches.tpl"}
      </div>
    </div>
    <div class="grid_10 push_right">
      <div id="mapSearchHome">
        <h2>Try the map search</h2>
        <p>You can also refine your search to a specific area on the map. The map search function currently encompasses some 12,630 items.</p>
        <a class="button" href="{$url}/Search/Advanced#mapSearch">Map search</a>
      </div>
    </div>
  </div>
</div>
    
<!-- END of: Search/home-content.en-gb.tpl -->
