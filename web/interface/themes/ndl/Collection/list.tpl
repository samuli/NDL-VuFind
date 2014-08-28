<!-- START of: Collection/list.tpl -->

{js filename="search_hierarchyTree.js}
{if $recordCount}
  {* Recommendations *}
  {if $topRecommendations}
    {foreach from=$topRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}
  <div class="collectionViewOptions">
  <form class="collectionSortSelector" action="{$path}/Search/SortResults" method="post">
      <label for="sort_options_1">{translate text='Sort'}</label>
      <select id="sort_options_1" name="sort" class="jumpMenu">
        {foreach from=$sortList item=sortData key=sortLabel}
          <option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
        {/foreach}
      </select>
      <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
  </form>
 {if $viewList|@count gt 1}
    <div class="collectionViewSelection viewButtons">
      {foreach from=$viewList item=viewData key=viewLabel}
        <a href="{$viewData.viewUrl|escape}" class="view-{$viewData.viewType} {if $viewData.selected}active{/if}" title="{translate text='Switch view to'} {translate text=$viewData.desc}"></a>
      {/foreach}
    </div>
 {/if}
 </div>
  <div class="clearer"></div>
{/if} 
{if $recordSet}
  {include file= $searchPage }
{else}
  {translate text='collection_empty'}<br/><a href="{$url}/Record/{$collectionID|urlencode}">{translate text='collection_empty_link'}</a>
{/if}

<!-- END of: Collection/list.tpl -->
