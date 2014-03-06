<!-- START of: MetaLib/list.tpl -->

{* Listing Options *}
<div class="resultHeader">
  <div class="resultTerms">
    <div class="content">
      {*if $searchType == 'MetaLibAdvanced'}
      <div class="advancedOptions grid_24">
        <a href="{$path}/MetaLib/Advanced?edit={$searchId}&set={$searchSet|escape}" class="small">{translate text="Edit this Advanced Search"}</a> |
        <a href="{$path}/MetaLib/Advanced?set={$searchSet|escape}" class="small">{translate text="Start a new Advanced Search"}</a> |
        <a href="{$path}/MetaLib/Home?set={$searchSet|escape}" class="small">{translate text="Start a new Basic Search"}</a>
      </div>
      {/if*}
      <h3 class="searchTerms grid_18">
      {if $lookfor == ''}{translate text="history_empty_search"}
      {else}
        {if $searchType == 'MetaLib'}{translate text="Search"}: {$lookfor|escape:"html"}
        {elseif $searchType == 'MetaLibAdvanced'}{translate text="Your search terms"} : "{$lookfor|escape:"html"}
        {elseif ($searchType == 'MetaLibAdvanced') || ($searchType != 'MetaLibAdvanced' && $orFilters)}
          {foreach from=$orFilters item=values key=filter}
          AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}
        {/if}
        {if $searchType == 'MetaLibAdvanced'}"{/if}
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

      {if $searchType == 'MetaLibAdvanced'}
      <div class="advancedOptions grid_6">
        <p class="advancedEdit">
          <a href="{$path}/MetaLib/Advanced?edit={$searchId}&set={$searchSet|escape}"{* class="small"*}>{translate text="Edit this Advanced MetaLib Search"}</a>
        </p>
        <p class="advancedNewSearch">
          <a href="{$path}/MetaLib/Advanced?set={$searchSet|escape}"{* class="small"*}>{translate text="Start a new Advanced MetaLib Search"}</a>
        </p>
        <p class="advancedBasic">
          <a href="{$path}/MetaLib/Home?set={$searchSet|escape}"{* class="small"*}>{translate text="Start a new Basic MetaLib Search"}</a>
        </p>
      </div>
      {/if}
    </div> {* content *}
  </div> {* resultTerms *}

  {* tabNavi *}
  {if $searchType != 'MetaLibAdvanced'}
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
        {foreach from=$sideRecommendations item="recommendations"}
          {include file=$recommendations}
        {/foreach}
        {if $recordCount > 0}<h4 class="jumpToFacets">{translate text=$sideFacetLabel}</h4>{/if}
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

<!-- END of: MetaLib/list.tpl -->
