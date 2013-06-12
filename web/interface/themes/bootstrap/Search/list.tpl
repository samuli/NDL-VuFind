<!-- START of: Search/list.tpl -->

<div class="span12 well well-small authorbox">
  <div id="topFacets" class="row-fluid">
    {* Recommendations *}
    {if $topRecommendations}
      {foreach from=$topRecommendations item="recommendations"}
        {include file=$recommendations}
      {/foreach}
    {/if}
   <div class="clear"></div>
  </div>
</div>

<div class="row-fluid">

{* Main Listing *}
{*if $dualResultsEnabled && $searchType != 'advanced'}
  <div id="resultList" class="span12">      

{else*}
  <div id="resultList" class="span9{if $sidebarOnLeft} sidebarOnLeft last{/if}">
{*/if*}
    {* Listing Options *}
    <div class="resulthead row-fluid">

    {if $recordCount}
      <div class="span12 alert alert-success well-small resultTerm">
      {if $lookfor == ''}
        <h4{if $dualResultsEnabled && $searchType != 'advanced'} class="pull-left"{/if}>{translate text="history_empty_search"}</h4>
      {else}
        <h4{if $dualResultsEnabled && $searchType != 'advanced'} class="pull-left"{/if}>{if $searchType == 'basic'}{$lookfor|escape:"html"}{/if}</h4>
      {/if}

      {if $dualResultsEnabled && $searchType != 'advanced'}
        <div class="pull-right">
          <a class="btn btn-small" href="{$smarty.server.REQUEST_URI|escape|replace:"/Search/Results":"/Search/DualResults"|replace:"prefilter=":"prefiltered="}">{translate text="All Results"}</a>
          <a class="btn btn-small buttonSelected" href=".">{translate text="Books etc."}</a>
          <a class="btn btn-small" href="{$smarty.server.REQUEST_URI|escape|replace:"/Search/Results":"/PCI/Search"|replace:"prefilter=":"prefiltered="}">{translate text="Articles, e-Books etc."}</a>
        </div>
      {/if}
      </div>

      {if $searchType != 'advanced' && $orFilters}
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

      <div class="well well-small clearfix">
        <div class="row-fluid">
          <ul class="resultOptions inline">
            <li class="pull-left"><label class="badge">{translate text="Search Results"}:</label>&nbsp;&nbsp;<strong>{$recordStart}-{$recordEnd}&nbsp;/&nbsp;{$recordCount}</strong></li>
            <li class="pull-right">
              <ul class="listResultSelect inline">
                <li>
                  <div class="limitSelect pull-left"> 
                    {if $limitList|@count gt 1}
                      <form class="form-inline" action="{$path}/Search/LimitResults" method="post">
                        <label for="limit">{translate text='Results per page'}</label>
                        <select id="limit" name="limit" class="selectpicker" data-style="btn-mini" onChange="document.location.href = this.options[this.selectedIndex].value;">
                          {foreach from=$limitList item=limitData key=limitLabel}
                            <option value="{$limitData.limitUrl|escape}"{if $limitData.selected} selected="selected"{/if}>{$limitData.desc|escape}</option>
                          {/foreach}
                        </select>
                        <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
                      </form>
                    {/if}
                  </div>
                </li>
                <li>
                  <div class="viewButtons">
                  {if $viewList|@count gt 1}
                    {foreach from=$viewList item=viewData key=viewLabel}
                      {if !$viewData.selected}<a href="{$viewData.viewUrl|escape}" title="{translate text='Switch view to'} {translate text=$viewData.desc}" >{/if}<img src="{$path}/images/view_{$viewData.viewType}.png" {if $viewData.selected}title="{translate text=$viewData.desc} {translate text="view already selected"}"{/if}/>{if !$viewData.selected}</a>{/if}
                    {/foreach}
                  {/if}
                  </div>
                </li>
                <li>
                  <div class="sortSelect pull-left">
                    <form class="form-inline" action="{$path}/Search/SortResults" method="post">
                      <label for="sort_options_1">{translate text='Sort'}</label>
                      <select id="sort_options_1" name="sort" class="jumpMenu selectpicker" data-style="btn-mini">
                      {foreach from=$sortList item=sortData key=sortLabel}
                        <option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
                      {/foreach}
                      </select>
                      <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
                    </form>
                  </div>
                </li>
              </ul>

            </li>
          </ul>
        </div>
  {*
        <div class="row-fluid paging text-centered">
          <ul class="pager span12">
            <li class="{if !$pageLinks.back} disabled{/if}">{if $pageLinks.back}{$pageLinks.back}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.prevImg}</span>{/if}</li>
                          <li class="{if !$pageLinks.next} disabled{/if}">{if $pageLinks.next}{$pageLinks.next}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.nextImg}</span>{/if}</li>
          </ul>
        </div>
  *}
      </div>

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
      <li><a href="{$rssLink|escape}" class="feed">{translate text="Get RSS Feed"}</a></li>
      <li><a href="{$url}/Search/Email" class="mailSearch mail" id="mailSearch{$searchId|escape}" title="{translate text='Email this Search'}">{translate text="Email this Search"}</a></li>
      
    </ul>
  </div>

</div>

{* Fancybox for images *}
{js filename="init_fancybox.js"}

<!-- END of: Search/list.tpl -->
