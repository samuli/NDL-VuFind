<!-- START of: Search/list-dual-solr.tpl -->

{* Listing Options *}
<div class="resultHeader">
  <h4>{if $recordCount}<a href="{$more|escape}">{translate text="Books etc."}</a>{else}{translate text="Books etc."}{/if}</h4>
  <i>{translate text="local_results_description"}</i><br/><br/>
  {if $recordCount}
  <div class="well well-small resultViewOptions clearfix">
    <div class="resultNumbers pull-left">
      <span class="currentPage"><span class="badge">{translate text="Search Results"}</span> <strong>{$recordStart}&#8201;-&#8201;{$recordEnd} / </strong></span>
      <span class="resultTotals">{$recordCount}</span>
    </div>
	  <div class="resultOptions pull-right">
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
