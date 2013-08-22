<!-- START of: Search/newitem-list.tpl -->

<div class="newItem">
<div class="header">
  <div class="content">
    <div class="grid_24">
      <h1>{translate text='New Items'} ({if $range == 1}{translate text='Yesterday'}{else}{translate text='Past'} {$range|escape} {translate text='Days'}{/if})</h1>
      <div></div>
    </div>
  </div>
</div>

{* Main Listing *}
{* removed, probably unnecessary
<div id="topFacets" class="authorbox">
  {if $topRecommendations}
    {foreach from=$topRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}
 <div class="clear"></div>
</div>
{js filename="init_fancybox.js"} *}

  {if $errorMsg || $infoMsg}
    <div class="messages">
      {if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
      {if $infoMsg}<div class="info">{$infoMsg|translate}</div>{/if}
    </div>
  {/if}
  {if empty($recordSet)}
        <p>{translate text="nohit_prefix"} {translate text="nohit_suffix"}</p>
  {else}
    {* Listing Options *}

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

    {* End Listing Options *}
<div class="resultListContainer">
  <div class="content">
    <div id="resultList" class="{if $sidebarOnLeft && !empty($sideFacetSet)}sidebarOnLeft last{/if} grid_17">
      {if $subpage}
        {include file=$subpage}
      {else}
        {$pageContent}
      {/if}
    </div>
    {* Narrow Search Options *}
    {if !empty($sideFacetSet)}
    <div id="sidebarFacets" class="{if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if} grid_6">
      {if $sideRecommendations}
        {foreach from=$sideRecommendations item="recommendations"}
          {include file=$recommendations}
        {/foreach}
      {/if}
    </div>
    {/if}
  {* End Narrow Search Options *}

  </div>
</div>

    {include file="Search/paging.tpl" position="Bottom"}
    {include file="Search/result-search-tools.tpl"}
  {/if}

{* End Main Listing *}

</div>
<div class="clear"></div>

<!-- END of: Search/newitem-list.tpl -->
