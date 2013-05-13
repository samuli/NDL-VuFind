<!-- START of: Search/home-content.fi.tpl -->

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

{if $rssFeeds.carousel.active}
<div id="carouselContainer" class="section">
<div class="content">
{include file="AJAX/loadRSS.tpl" rssId="carousel"}
</div>
</div>
{/if}

<div id="popular-map" class="section clearfix{if !$rssFeeds.carousel.active} noCarousel{/if}">
  <div class="content">
    <div class="grid_14">
      <div id="topSearches">
        <h2>10 suosituinta hakua</h2>
        <div id="popularSearches" class="recent-searches"><div class="loading"></div></div>
        {include file="AJAX/loadPopularSearches.tpl"}
      </div>
    </div>
    <div class="grid_10 push_right">
      {if $rssFeeds.news.active}
      <h2>Uutisia</h2>
        {include file="AJAX/loadRSS.tpl" rssId="news"}
      {/if}
    </div>
  </div>
</div>
    
<!-- END of: Search/home-content.fi.tpl -->
