<!-- START of: Search/home-content.sv.tpl -->

<div id="introduction" class="section clearfix">
  <div class="content">
    <div class="grid_14">
      <div id="siteDescription">
        {include file="Search/site-description.$userLang.tpl"}
      </div>
    </div>
    <div class="grid_10 push_right">
      <div>
        {include file="Search/document-type-list.tpl"}
      </div>
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
      {include file="Search/fourth-box.$userLang.tpl"}
    </div>
  </div>
</div>
    
<!-- END of: Search/home-content.sv.tpl -->
