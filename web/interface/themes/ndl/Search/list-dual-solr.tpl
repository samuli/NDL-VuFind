<!-- START of: Search/list-dual-solr.tpl -->

{* Listing Options *}
<div class="resultHeader">
  <h3>{if $recordCount}<a href="{$more|escape}">{translate text="Books etc."}</a>{else}{translate text="Books etc."}{/if}</h3>
  <i>{translate text="local_results_description"}</i><br/><br/>
  {if $recordCount}
  <div class="resultViewOptions clearfix">
    <div class="resultNumbers">
      <span class="currentPage"><span>{translate text="Search Results"}</span> {$recordStart}&#8201;-&#8201;{$recordEnd} / </span>
      <span class="resultTotals">{$recordCount}</span>
    </div>
	  <div class="resultOptions">
	    {if $recordCount}<a href="{$more|escape}">{translate text="More Results"} &raquo;</a>{/if}
	  </div>
	</div>
  {else}
  <div class="resultViewOptions noResultHeader clearfix">
    <div class="resultNumbers">
      {translate text="nohit_heading"}
    </div>
  </div>
  {/if}
</div>
{* End Listing Options *}

{include file='Search/list-list.tpl'}

<!-- END of: Search/list-dual-solr.tpl -->
