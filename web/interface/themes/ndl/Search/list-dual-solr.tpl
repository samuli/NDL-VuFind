<!-- START of: Search/list-dual-solr.tpl -->

{* Listing Options *}
<div class="resultHeader">
  {if $recordCount}
  <div class="resultViewOptions resultListTop clearfix">
    <div class="resultNumbers">
      <span class="currentPage"><span>{translate text="Search Results"}</span> {$recordStart}&#8201;-&#8201;{$recordEnd} / </span>
      <span class="resultTotals">{$recordCount|number_format:0:".":" "|replace:" ":"&#x2006;"}</span>
    </div>
	  <div class="resultOptions">
	    {if $recordCount}<a href="{$more|escape}">{translate text="More"} &raquo;</a>{/if}
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

{if $recordCount}
<div class="resultViewOptions resultListBottom clearfix">
  <div class="resultNumbers">
    <span class="currentPage"><span>{translate text="Search Results"}</span> {$recordStart}&#8201;-&#8201;{$recordEnd} / </span>
    <span class="resultTotals">{$recordCount|number_format:0:".":" "|replace:" ":"&#x2006;"}</span>
  </div>
  <div class="resultOptions">
    {if $recordCount}<a href="{$more|escape}">{translate text="More"} &raquo;</a>{/if}
  </div>
</div>
{/if}


<!-- END of: Search/list-dual-solr.tpl -->
