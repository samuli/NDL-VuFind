<!-- START of: List/home.tpl -->
{js filename="init_fancybox.js"}


<div id="listHeader">
    <div class="content"><h2>{translate text='Shared List'}: {if $list->title == 'My Favorites'}{translate text=$list->title}{else}{$list->title|escape:"html"}{/if}</h2></div>
</div>

<div id="listContent">
  <div class="content">
    <div class="grid_24">
      <div class="listDesc grid_15">{$list->description}</div>  
      <div class="listInfo grid_8">
        {if $listUsername}
          <div>{translate text="Collection Author"}:</div>
          <div class="listUsername">{$listUsername}</div>
        {/if}
        {if $listModified}
           <div>{translate text="Last Edited"}: {$listModified}</div>
        {/if}
      </div>
    </div>

    <div class="clear"></div>


    <div class="resultViewOptions">
      <div class="content">
        <div class="resultNumbers">
          {if !empty($pageLinks.pages)}<span class="paginationMove paginationBack {if !empty($pageLinks.back)}visible{/if}">{$pageLinks.back}<span>&#9668;</span></span>{/if}
          <span class="currentPage"><span>{translate text="List Items"}</span> {$recordStart|number_format:0:".":" "|replace:" ":"&#x2006;"}&#8201;-&#8201;{$recordEnd|number_format:0:".":" "|replace:" ":"&#x2006;"} / </span>
          <span class="resultTotals">{$recordCount|number_format:0:".":" "|replace:" ":"&#x2006;"}</span>
          {if !empty($pageLinks.pages)}<span class="paginationMove paginationNext {if !empty($pageLinks.next)}visible{/if}">{$pageLinks.next}<span>&#9654;</span></span>{/if}
        </div>
        <div class="resultOptions">
          {if $viewList|@count gt 1}
          <div class="viewButtons">
            {foreach from=$viewList item=viewData key=viewLabel}
            <a href="{$viewData.viewUrl|escape}" class="view-{$viewData.viewType} {if $viewData.selected}active{/if}" title="{translate text='Switch view to'} {translate text=$viewData.desc}"></a>
          {/foreach}
          </div>
        {/if}
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

    <div class="grid_24">
      <div id="resultList">
        {include file=$subpage}
      </div>      
    </div>
  </div>
</div>
    
{include file="Search/paging.tpl" position="Bottom"}

<div class="clear"></div>


<!-- END of: List/home.tpl -->
