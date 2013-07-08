<!-- START of: PCI/searchbox.tpl -->

{if $dualResultsEnabled}
  {include file='Search/searchbox.tpl'}
{else}

<div id="searchFormContainer" class="searchform searchformPCI last content">
  <form method="get" action="{$path}/PCI/Search" name="searchForm" id="searchForm" class="search">
    <div class="searchFormOuterWrapper">
	    <div class="searchFormWrapper">
	      <div class="overLabelWrapper">
	        <label for="searchForm_input" id="searchFormLabel" class="labelOver normal">{translate text="Find"}&hellip;</label>
	        <input id="searchForm_input" type="text" name="lookfor" size="22" value="{$lookfor|escape}" autocomplete="off" class="last clearable mainFocus" title='{translate text="Find"}&hellip;' />
	      </div>
	      <input id="searchForm_searchButton" type="submit" name="SearchForm_submit" value="{translate text="Find"}"/>
	      <div class="clear"></div>
	    </div>
	  </div>
    <div class="searchFormOuterWrapper">
	    <div class="advancedLinkWrapper{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
	      <a href="{$path}/PCI/Advanced" class="small advancedLink">{translate text="Advanced PCI Search"}</a>
	  {if $metalibEnabled}
	      <a href="{$path}/MetaLib/Home" class="small metalibLink">{translate text="MetaLib Search"}</a>
	  {/if}
	      <a href="{$path}" class="small metalibLink">{translate text="Local Search"}</a>
	    </div>
    </div>
    <div class="searchContextHelp">
    {if isset($userLang)}
      {include file="Content/searchboxhelp.$userLang.tpl"}
    {/if}
    </div>
    
  {* Do we have any checkbox filters? *}
  {assign var="hasCheckboxFilters" value="0"}
  {if isset($checkboxFilters) && count($checkboxFilters) > 0}
    {foreach from=$checkboxFilters item=current}
      {if $current.selected}
        {assign var="hasCheckboxFilters" value="1"}
      {/if}
    {/foreach}
  {/if}

  {if $shards}
    <br />
    {foreach from=$shards key=shard item=isSelected}
    <input type="checkbox" {if $isSelected}checked="checked" {/if}name="shard[]" value='{$shard|escape}' /> {$shard|translate}
    {/foreach}
  {/if}

  {if ($filterList || $hasCheckboxFilters) && !$disableKeepFilterControl}
    <div class="keepFilters">
      <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} id="searchFormKeepFilters"/>
      <label for="searchFormKeepFilters">{translate text="basic_search_keep_filters"}</label>

      <div class="offscreen">
    {foreach from=$filterList item=data key=field name=filterLoop}
      {foreach from=$data item=value}
        <input id="applied_filter_{$smarty.foreach.filterLoop.iteration}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="filter[]" value="{$value.field|escape}:&quot;{$value.value|escape}&quot;" />
        <label for="applied_filter_{$smarty.foreach.filterLoop.iteration}">{$value.field|escape}:&quot;{$value.value|escape}&quot;</label>
      {/foreach}
    {/foreach}

    {foreach from=$checkboxFilters item=current name=filterLoop}
      {if $current.selected}
        <input id="applied_checkbox_filter_{$smarty.foreach.filterLoop.iteration}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="filter[]" value="{$current.filter|escape}" />
        <label for="applied_checkbox_filter_{$smarty.foreach.filterLoop.iteration}">{$current.filter|escape}</label>
      {/if}
    {/foreach}
      </div>

    </div>
  {/if}

  {* Load hidden limit preference from Session *}
  {if $lastLimit}<input type="hidden" name="limit" value="{$lastLimit|escape}" />{/if}
  {if $lastSort}<input type="hidden" name="sort" value="{$lastSort|escape}" />{/if}

  </form>
</div>

{/if} {* $dualResultsEnabled *}

<!-- END of: PCI/searchbox.tpl -->
