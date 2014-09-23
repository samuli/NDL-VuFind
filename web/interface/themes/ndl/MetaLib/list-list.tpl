
<div class="resultNumbers">
  {if !empty($pageLinks.pages)}<span class="paginationMove paginationBack {if !empty($pageLinks.back)}visible{/if}">{$pageLinks.back}<span>&#9668;</span></span>{/if}
   <span class="currentPage"><span>{translate text="Search Results"}</span> {$recordStart}&#8201;-&#8201;{$recordEnd} / </span>
   <span class="resultTotals">{$recordCount}</span>
   {if !empty($pageLinks.pages)}<span class="paginationMove paginationNext {if !empty($pageLinks.next)}visible{/if}">{$pageLinks.next}<span>&#9654;</span></span>{/if}
</div>
      
{* check save statuses via AJAX *}
{js filename="check_save_statuses.js"}
{js filename="jquery.cookie.js"}
{js filename="openurl.js"}
{include file="Search/rsi.tpl"}
{include file="Search/openurl_autocheck.tpl"}

<form method="post" name="addForm" action="{$url}/Cart/Home">
  <ul class="recordSet">
  {if $setNotification|@count}    
   <div class="loginNotification">
   <p>{$setNotification}</p>
   </div>
  {/if}
  {foreach from=$recordSet item=record name="recordLoop"}
    <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
      <span class="recordNumber">{$recordStart+$smarty.foreach.recordLoop.iteration-1}</span>
      {include file="MetaLib/result-list.tpl"}
    </li>
  {/foreach}
  </ul>
</form>


<script type="text/javascript">
   var metalibSearchId = {$searchId};
   var metalibSavedSearch = {if $savedSearch}true{else}false{/if};
</script>

{include file="MetaLib/database-statuses.tpl"}


{include file="Search/paging.tpl" position="Bottom"}

{include file="piwik.tpl"}
