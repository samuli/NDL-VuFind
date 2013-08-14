<!-- START of: Search/list.tpl -->

{* Listing Options *}
<div class="resultHeader">
  <div class="resultTerms">
    <div class="content">
      {if $searchType == 'advanced'}
      <div class="advancedOptions grid_24">
        <a href="{$path}/Search/Advanced?edit={$searchId}">{translate text="Edit this Advanced Search"}</a> |
        <a href="{$path}/Search/Advanced">{translate text="Start a new Advanced Search"}</a> |
        <a href="{$path}/">{translate text="Start a new Basic Search"}</a>
      </div>
      {/if}
      {if $dualResultsEnabled && $searchType != 'advanced'}
      <div class="headerLeft">
        <h2 class="searchTerms grid_12">
      {else}
      <h2 class="searchTerms grid_24">
      {/if}
      {if $isEmptySearch}
        {if $searchType == 'advanced'}
          {translate text="Advanced Search"}: {translate text="history_empty_search_adv"}
        {else}
          {translate text="history_empty_search"}
        {/if}
      {else}
        {if $searchType == 'basic'}
           {translate text="Search"}: {$lookfor|escape:"html"}
        {elseif ($searchType == 'advanced' && !$orFilters)}
           {translate text="Advanced Search"}: "{$lookfor|escape:"html"}"
        {elseif ($searchType != 'advanced' && $orFilters)}
          {foreach from=$orFilters item=values key=filter}
          AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}
        {elseif ($searchType == 'advanced' && $orFilters)}
          {translate text="Advanced Search"}: "{$lookfor|escape:"html"}
          {foreach from=$orFilters item=values key=filter}
          AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}"
        {/if}
      {/if}
      </h2>
      {if $spellingSuggestions}
      {if $dualResultsEnabled && $searchType != 'advanced'}
      <div class="correction grid_12">
      {else}
      <div class="correction grid_24">
      {/if}
        {translate text="spell_suggest"}:
        {foreach from=$spellingSuggestions item=details key=term name=termLoop}
          <span class="correctionTerms">{foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a class="expandSearch" title="{translate text="spell_expand_alt"}" {* alt="{translate text="spell_expand_alt"}" NOT VALID ATTRIBUTE *} href="{$data.expand_url|escape}"></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}
          </span>
        {/foreach}
      </div>
      {/if}
      {if $dualResultsEnabled && $searchType != 'advanced'}
      </div>
      <div class="headerRight">
        <a class="button buttonFinna" href="{$smarty.server.REQUEST_URI|escape|replace:"/Search/Results":"/Search/DualResults"|replace:"prefilter=":"prefiltered="}">{translate text="All Results"}</a>
        <a class="button buttonFinna buttonSelected" href="{$smarty.server.REQUEST_URI|escape}">{translate text="Books etc."}</a>
        <a class="button buttonFinna" href="{$smarty.server.REQUEST_URI|escape|replace:"/Search/Results":"/PCI/Search"|replace:"prefilter=":"prefiltered="}">{translate text="Articles, e-Books etc."}</a>
      </div>
      {/if}
    </div> {* content *}
  </div> {* resultTerms *}
  
  <div class="resultRecommendations">
    <div class="content">
      <div class="grid_24">
        {* Recommendations *}
        {if $topRecommendations}
          {foreach from=$topRecommendations item="recommendations"}
             
            {include file=$recommendations}
          {/foreach}
        {/if}
      </div>
    </div>
  </div>
  <div class="resultDatesHeader {if !empty($visFacets.main_date_str[0])}expanded{/if}">
    <div class="content">
      <span class="dateVisHandle">{translate text='Results timeline'}<span class="dateVisHelp {if !empty($visFacets.main_date_str[0])}visible{/if}"><span class="infoIndicator">i</span>{translate text='You can narrow the search by selecting a period on the timeline'}</span></span>
      <div class="dateVisHandle dateVisOpen {if empty($visFacets.main_date_str[0])}visible{/if}"></div>
      <div class="dateVisHandle dateVisClose {if !empty($visFacets.main_date_str[0])}visible{/if}"></div>
    </div>
  </div>
<div class="resultViewOptions">
    <div class="content">
      <div class="resultNumbers">
        {if !empty($pageLinks.pages)}<span class="paginationMove paginationBack {if !empty($pageLinks.back)}visible{/if}">{$pageLinks.back}<span>&#9668;</span></span>{/if}
        <span class="currentPage"><span>{translate text="Search Results"}</span> {$recordStart}&#8201;-&#8201;{$recordEnd} / </span>
        <span class="resultTotals">{$recordCount}</span>
         {if !empty($pageLinks.pages)}<span class="paginationMove paginationNext {if !empty($pageLinks.next)}visible{/if}">{$pageLinks.next}<span>&#9654;</span></span>{/if}
      </div>
      <div class="resultOptions">
        <!--
        <div class="viewButtons">
          {if $viewList|@count gt 1}
            {foreach from=$viewList item=viewData key=viewLabel}
              {if !$viewData.selected}<a href="{$viewData.viewUrl|escape}" title="{translate text='Switch view to'} {translate text=$viewData.desc}" >{/if}<img src="{$path}/images/view_{$viewData.viewType}.png" {if $viewData.selected}title="{translate text=$viewData.desc} {translate text="view already selected"}"{/if}/>{if !$viewData.selected}</a>{/if}
            {/foreach}
          {/if}
        </div>
        -->
        <div class="resultOptionSort">
          <form action="{$path}/Search/SortResults" method="post">
            <label for="sort_options_1">{translate text='Sort'}</label>
            <select id="sort_options_1" name="sort" class="jumpMenu">
              {foreach from=$sortList item=sortData key=sortLabel}
                <option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
              {/foreach}
            </select>
            <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
          </form>
        </div>

        <div class="resultOptionLimit"> 
          {if $limitList|@count gt 1}
            <form action="{$path}/Search/LimitResults" method="post">
              <label for="limit">{translate text='Results per page'}</label>
              <select class="jumpMenu" id="limit" name="limit">
                {foreach from=$limitList item=limitData key=limitLabel}
                  <option value="{$limitData.limitUrl|escape}"{if $limitData.selected} selected="selected"{/if}>{$limitData.desc|escape}</option>
                {/foreach}
              </select>
              <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
            </form>
          {/if}
        </div>

      </div> {* resultOptions *}
    </div> {* content *}
  </div> {* resultViewOptions *}
</div> {* resultHeader *}
{* End Listing Options *}
{* Fancybox for images *}
{js filename="init_fancybox.js"}
{* Main Listing *}
<div class="resultListContainer">
  <div class="content">
    <div id="resultList" class="{if $sidebarOnLeft}sidebarOnLeft last{/if} grid_17">
      {if $subpage}
        {include file=$subpage}
      {else}
        {$pageContent}
      {/if}
    </div>
    <div id="sidebarFacets" class="{if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if} grid_6">
      {if $sideRecommendations}
        {foreach from=$sideRecommendations item="recommendations"}
          {include file=$recommendations}
        {/foreach}
        {if $recordCount > 0}<h4 class="jumpToFacets">{translate text=$sideFacetLabel}</h4>{/if}
      {/if}
    </div>
  </div>
</div>
          
{include file="Search/paging.tpl" position="Bottom"}
<div class="resultSearchTools">
  <div class="content">
    <div class="searchtools">
      <ul>
        <li class="toolSavedSearch">
          {if $savedSearch}
            <span class="searchtoolsHeader"><a href="{$url}/MyResearch/SaveSearch?delete={$searchId}">{translate text='save_search_remove'}</a></span>
          {else}
            <span class="searchtoolsHeader"><a href="{$url}/MyResearch/SaveSearch?save={$searchId}">{translate text="save_search"}</a></span>
            <span class="searchtoolsText">
            </span>
          {/if}
        </li>
        <li class="toolRssLink">
          <span class="searchtoolsHeader"><a href="{$rssLink|escape}">{translate text="Get RSS Feed"}</a></span>
          <span class="searchtoolsText">
          </span>
        </li>
        <li class="toolMailSearch">
          <span class="searchtoolsHeader"><a href="{$url}/Search/Email" class="mailSearch mail" id="mailSearch{$searchId|escape}" title="{translate text='Email this Search'}">{translate text="Email this Search"}</a></span>
          <span class="searchtoolsText">
          </span>
        </li>
      </ul>  
    </div>
  </div>
</div>
  {* End Main Listing *}
  {* Narrow Search Options *}
  {* End Narrow Search Options *}
  
<div class="clear"></div>

{literal}
  <script type="text/javascript">
    $(function() {
        initSearchInputListener();
    });
  </script>
{/literal}

<!-- END of: Search/list.tpl -->
