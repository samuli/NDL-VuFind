<!-- START of: PCI/list.tpl -->

{* Listing Options *}
<div class="resultHeader">
  <div class="resultTerms">
    <div class="content">
      {* if $searchType == 'PCIAdvanced'}
      <div class="advancedOptions grid_24">
        <a href="{$path}/PCI/Advanced?edit={$searchId}">{translate text="Edit this Advanced PCI Search"}</a> |
        <a href="{$path}/PCI/Advanced">{translate text="Start a new Advanced PCI Search"}</a> |
        {if $dualResultsEnabled}
        <a href="{$path}/">{translate text="Start a new Basic Search"}</a>
        {else}
        <a href="{$path}/PCI/Home">{translate text="Start a new Basic PCI Search"}</a>
        {/if}
      </div>
      {/if *}
      {if $dualResultsEnabled && $searchType != 'PCIAdvanced'}
      <div class="headerLeft">
        <h3 class="searchTerms grid_12">
      {else}
      <h3 class="searchTerms grid_18">
      {/if}
      {if $lookfor == ''}{translate text="history_empty_search"}
      {else}
        {if $searchType == 'PCI'}{translate text="Search"}: {$lookfor|escape:"html"}
        {elseif $searchType == 'PCIAdvanced'}{translate text="Your search terms"} : "{$lookfor|escape:"html"}
        {elseif ($searchType == 'PCIAdvanced') || ($searchType != 'PCIAdvanced' && $orFilters)}
          {foreach from=$orFilters item=values key=filter}
          AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}
        {/if}
        {if $searchType == 'PCIAdvanced'}"{/if}
      {/if}
      </h3>
      {if $spellingSuggestions}
      <div class="correction">
        {translate text="spell_suggest"}:
        {foreach from=$spellingSuggestions item=details key=term name=termLoop}
          <span class="correctionTerms">{foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a class="expandSearch" title="{translate text="spell_expand_alt"}" {* alt="{translate text="spell_expand_alt"}" NOT VALID ATTRIBUTE *} href="{$data.expand_url|escape}"></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}
          </span>
        {/foreach}
      </div>
      {/if}
      {if $dualResultsEnabled && $searchType != 'PCIAdvanced'}
      </div>
{* Replaced by tabbed navigation
      <div class="headerRight">
        <a class="button buttonFinna" href="{$smarty.server.REQUEST_URI|escape|replace:"/PCI/Search":"/Search/DualResults"|replace:"prefilter=":"prefiltered="}">{translate text="All Results"}</a>
        <a class="button buttonFinna" href="{$searchWithoutFilters|escape|replace:"/PCI/Search":"/Search/Results"|replace:"prefilter=":"prefiltered="}">{translate text="Books etc."}</a>
        <a class="button buttonFinna buttonSelected" href="{$smarty.server.REQUEST_URI|escape}">{translate text="Articles, e-Books etc."}</a>
      </div>
*}
      {/if}

      {if $searchType == 'PCIAdvanced'}
      <div class="advancedOptions grid_6">
        <p class="advancedEdit">
          <a href="{$path}/PCI/Advanced?edit={$searchId}">{translate text="Edit this Advanced PCI Search"}</a>
        </p>
        <p class="advancedNewSearch">
          <a href="{$path}/PCI/Advanced">{translate text="Start a new Advanced PCI Search"}</a>
        </p>
        <p class="advancedBasic">
        {if $dualResultsEnabled}
          <a href="{$path}/">{translate text="Start a new Basic Search"}</a>
        {else}
          <a href="{$path}/PCI/Home">{translate text="Start a new Basic PCI Search"}</a>
        {/if}
        </p>
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

  {* tabNavi *}
  {if $searchType != 'PCIAdvanced'}
    {include file="Search/tabnavi.tpl"}
  {/if}

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
  <div id="resultList" class="{if ($sidebarOnLeft && !empty($sideFacetSet))}sidebarOnLeft last{/if} grid_17">

  {if $subpage}
    {include file=$subpage}
  {else}
    {$pageContent}
  {/if}
  </div>
  {if !empty($sideFacetSet)}
    <div id="sidebarFacets" class="{if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if} grid_6">
      {if $sideRecommendations}
        {foreach from=$sideRecommendations item="recommendations"}
          {include file=$recommendations}
        {/foreach}
        {if $recordCount > 0}<h4 class="jumpToFacets">{translate text=$sideFacetLabel}</h4>{/if}
      {/if}
    </div>
  {/if}
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
