<!-- START of: MetaLib/browse.tpl -->
{if $metalibEnabled}
{js filename="metalib_links.js"}
{/if}

<div id="metaLibBrowse">
  <div class="resultHeader">
    <div class="resultViewOptions">
      <div class="content">
        <div class="resultNumbers">
          {if !empty($pageLinks.pages)}<span class="paginationMove paginationBack {if !empty($pageLinks.back)}visible{/if}">{$pageLinks.back}<span>&#9668;</span></span>{/if}
          <span class="currentPage"><span>{translate text="Search For Databases"}</span> {$recordStart|number_format:0:".":" "|replace:" ":"&#x2006;"}&#8201;-&#8201;{$recordEnd|number_format:0:".":" "|replace:" ":"&#x2006;"} / </span>
          <span class="resultTotals">{$recordCount|number_format:0:".":" "|replace:" ":"&#x2006;"}</span>
          {if !empty($pageLinks.pages)}<span class="paginationMove paginationNext {if !empty($pageLinks.next)}visible{/if}">{$pageLinks.next}<span>&#9654;</span></span>{/if}
        </div>
        
      </div>
    </div>
  </div>  

  <div class="resultListContainer">
    <div class="content">
      <div id="resultList" class="{if ($sidebarOnLeft && !empty($sideFacetSet))}sidebarOnLeft last{/if} grid_17">
        <ul class="recordSet listView">
          {foreach from=$recordSet item=record name="recordLoop"}
          <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 1} alt{/if}">
            <span class="recordNumber">{$recordStart+$smarty.foreach.recordLoop.iteration-1}</span>
            {* This is raw HTML -- do not escape it: *}
            {$record}
          </li>
          {/foreach}
        </ul>      
      </div>
      <div id="sidebarFacets" class="{if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if} grid_6">
      {if $backToMetaLib}
        <div class="backToMetaLib">
          <a href="{$backToMetaLib|escape}"><div class="button buttonFinna icon"><span class="icon">&laquo;</span></div>{$backToMetaLibLabel}</a>
        </div>
    {/if}
        {* Recommendations *}
        {if $sideRecommendations}
        {foreach from=$sideRecommendations item="recommendations"}
        {include file=$recommendations}
        {/foreach}
        {/if}
        {* End Recommendations *}
      </div>
    </div>
  </div>

  {include file="Search/paging.tpl" position="Bottom"}
  {js filename="metalib_browse.js"}

</div>
<!-- END of: MetaLib/browse.tpl -->
