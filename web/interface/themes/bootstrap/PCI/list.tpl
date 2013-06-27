<!-- START of: PCI/list.tpl -->

<!--
<div class="span12 well well-small authorbox">
  <div id="topFacets" class="row-fluid">

    <div class="well-small">
    {* Recommendations *}
    {if $topRecommendations}
      {foreach from=$topRecommendations item="recommendations"}
        {include file=$recommendations}
      {/foreach}
    {/if}
    </div>
   <div class="clear"></div>
  </div>
</div>
-->

<div class="row-fluid">

{* Main Listing *}
  <div id="resultList" class="span9{if $sidebarOnLeft} sidebarOnLeft last{/if}">
    {* Listing Options *}
    <div class="resulthead row-fluid">
    {if $recordCount}
      <div class="span12 alert alert-success well-small resultTerm">
        {if $searchType == 'PCIAdvanced'}
        <a href="{$path}/PCI/Advanced?edit={$searchId}">{translate text="Edit this Advanced PCI Search"}</a> |
        <a href="{$path}/PCI/Advanced">{translate text="Start a new Advanced PCI Search"}</a> |
        {if $dualResultsEnabled}
        <a href="{$path}/">{translate text="Start a new Basic Search"}</a>
        {else}
        <a href="{$path}/PCI/Home">{translate text="Start a new Basic PCI Search"}</a>
        {/if}
        {/if}

        {if $lookfor == ''}
        <h4{if $dualResultsEnabled && $searchType != 'PCIAdvanced'} class="pull-left dual"{/if}>{translate text="history_empty_search"}</h4>
      {else}
        <h4{if $dualResultsEnabled && $searchType != 'PCIAdvanced'} class="pull-left dual"{/if}>{if $searchType == 'PCI'}{translate text="Search"}: {$lookfor|escape:"html"}{elseif $searchType == 'PCIAdvanced'}{translate text="Your search terms"}: "{$lookfor|escape:"html"}"{/if}</h4>
      {/if}

      {if $dualResultsEnabled && $searchType != 'PCIAdvanced'}
        <div class="row-fluid">
          <div class="pull-right dualButtons">
            <a class="btn btn-small" href="{$smarty.server.REQUEST_URI|escape|replace:"/PCI/Search":"/Search/DualResults"|replace:"prefilter=":"prefiltered="}">{translate text="All Results"}</a>
            <a class="btn btn-small" href="{$smarty.server.REQUEST_URI|escape|replace:"/PCI/Search":"/Search/Results"|replace:"prefilter=":"prefiltered="}">{translate text="Books etc."}</a>
            <a class="btn btn-small buttonSelected" href="{$smarty.server.REQUEST_URI|escape}">{translate text="Articles, e-Books etc."}</a>
          </div>
        </div>
      {/if}
      </div>

      {if $searchType != 'PCIAdvanced' && $orFilters}
        {foreach from=$orFilters item=values key=filter}
      AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}
      {/if}
    {/if}

      <div class="row-fluid">
        {if $spellingSuggestions}
        <div class="alert alert-info correction well-small">
          <span class="label label-info">{translate text="spell_suggest"}</span>&nbsp;
          {foreach from=$spellingSuggestions item=details key=term name=termLoop}
            <span class="correctionTerms">
            {$term|escape} &raquo;
            {foreach from=$details.suggestions item=data key=word name=suggestLoop}
              <a href="{$data.replace_url|escape}">{$word|escape}</a>
              {if $data.expand_url}
              <a href="{$data.expand_url|escape}">{*<img src="{$path}/images/silk/expand.png" alt="{translate text="spell_expand_alt"}" title="{translate text="spell_expand_alt"}"/>*}<i class="icon-zoom-in"></i></a>
              {/if}
              {if !$smarty.foreach.suggestLoop.last},
              {/if}
            {/foreach}
            </span>
          {/foreach}
        </div>
        {/if}
      </div>

      {include file="Search/paging.tpl" position="Top"}

    </div> {* End Listing Options *}

    {if $subpage}
      {include file=$subpage}
    {else}
      {$pageContent}
    {/if}

    <div>
      {include file="Search/paging.tpl"}
    </div>  

  </div> {* End Main Listing *}

  {* Narrow Search Options *}
  {*if !$dualResultsEnabled && $searchType != 'advanced'*}
  <div id="sidebarFacets" class="span3 well well-small {if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if}">
    {if $sideRecommendations}
      {foreach from=$sideRecommendations item="recommendations"}
        {include file=$recommendations}
      {/foreach}
    {/if}
  </div>
  {*/if*}
  {* End Narrow Search Options *}


  <div class="row-fluid searchtools">
    <ul class="span12 unstyled inline well well-small">
      <li><strong>{translate text='Search Tools'}:</strong></li>
  {if $savedSearch}<li><a href="{$url}/MyResearch/SaveSearch?delete={$searchId}" class="delete">{translate text='save_search_remove'}</a></li>{else}<li><a href="{$url}/MyResearch/SaveSearch?save={$searchId}" class="add">{translate text="save_search"}</a></li>{/if}
    {* <li><a href="{$rssLink|escape}" class="feed">{translate text="Get RSS Feed"}</a></li> *} {* No RSS for PCI *}
      <li><a href="{$url}/Search/Email" class="mailSearch mail" id="mailSearch{$searchId|escape}" title="{translate text='Email this Search'}">{translate text="Email this Search"}</a></li>
      
    </ul>
  </div>

</div>

{* Fancybox for images *}
{js filename="init_fancybox.js"}

<!-- END of: Search/list.tpl -->
