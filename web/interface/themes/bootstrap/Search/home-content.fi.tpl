<!-- START of: Search/home-content.fi.tpl -->

<div class="span12 well-small homeContent">
<div class="row-fluid">
  <div id="siteDescription" class="span7">
    {include file="Search/site-description.$userLang.tpl"}
  </div>
  
  <div class="span5">
    {include file="Search/document-type-list.tpl"}
  </div>
</div>
</div>

{if $rssFeeds.carousel.active}      
<div class="row-fluid hidden-phone">
  <div id="carouselContainer" class="span12 section">
    <div class="content">
      {include file="AJAX/loadRSS.tpl" rssId="carousel"}
    </div>
  </div>
</div>
{/if}

<div class="">
  <div id="homeRuler" class="span12">
    <hr />
  </div>
</div>

<div id="popular-map" class="row-fluid section clearfix{if !$rssFeeds.carousel.active} noCarousel{/if}">
  <div class="span12 well-small">
    <div class="row-fluid content">
      <div class="span7">
        <div id="topSearches">
          <h4>10 suosituinta hakua</h4>
          <div id="popularSearches" class="recent-searches"><div class="loading"></div></div>
          {include file="AJAX/loadPopularSearches.tpl"}
        </div>
      </div>
      <div class="span5">
        {if $rssFeeds.news.active}
        <h4>Uutisia</h4>
          {include file="AJAX/loadRSS.tpl" rssId="news"}
        {/if}
      </div>
    </div>
  </div>
</div>

<!-- END of: Search/home-content.fi.tpl -->
