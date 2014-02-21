<!-- START of: Search/searchbox.tpl -->
<div id="searchFormContainer" class="searchform last content">
{if in_array('search', $contextHelp)}
 <span id="contextHelp_search" class="showHelp">{translate text="Search Tips"}</span>
{/if}
{if $searchType != 'advanced'}
  <form method="get" action="{$path}/Search/Results" name="searchForm" id="searchForm" class="search">
    <div class="searchFormOuterWrapper">
      <div class="searchFormWrapper">
	      <div class="overLabelWrapper">
	        <input id="searchForm_input" type="text" name="lookfor" value="{$lookfor|escape}" class="last{if $autocomplete} autocomplete typeSelector:searchForm_type{/if} mainFocus clearable" placeholder="{translate text='Find'}&hellip;" role="textbox" aria-autocomplete="list" aria-haspopup="true" />
	      </div>
	        {if $prefilterList}
	      <div class="styled_select">
	        <select id="searchForm_filter" class="searchForm_styled" name="prefilter">
	    {foreach from=$prefilterList item=searchDesc key=searchVal}    
	          <option value="{$searchVal|escape}"{if $searchVal == $activePrefilter || ($activePrefilter == null && $searchVal == "-") } selected="selected"{/if}>{$searchDesc|translate}</option>
	    {/foreach}
	        </select>
	      </div>
	
	  {/if}
	      <input id="searchForm_searchButton" type="submit" name="SearchForm_submit" value="{translate text="Find"}"/>
	      <div class="clear"></div>
	    </div>
    </div>

    <div class="advancedLinkWrapper {if !$dualResultsEnabled}no-{/if}dual{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
      <a href="{$path}/Search/Advanced" class="small advancedLink">{translate text="Advanced Search"}</a>
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
      <div class="checkboxFilter">
        <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} id="searchFormKeepFilters" />
        <label for="searchFormKeepFilters">{translate text="basic_search_keep_filters"}</label>
      </div>     
      <div class="offscreen">
    {foreach from=$filterList item=data key=field name=filterLoop}
      {foreach from=$data item=value}
        <input id="applied_filter_{$smarty.foreach.filterLoop.iteration}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="filter[]" value="{$value.field|escape}:&quot;{$value.value|escape}&quot;" />
      {/foreach}
    {/foreach}

    {foreach from=$checkboxFilters item=current name=filterLoop}
      {if $current.selected}
        <input id="applied_checkbox_filter_{$smarty.foreach.filterLoop.iteration}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="filter[]" value="{$current.filter|escape}" />
      {/if}
    {/foreach}
      </div>

    </div>
  {/if}

    <div class="searchFormOuterWrapper">
      <div class="advancedLinkWrapper{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
{*
        <a href="{$path}/Search/Advanced" class="small advancedLink">{translate text="Advanced Search"}</a>
*}
      {if $pciEnabled}
        {if $dualResultsEnabled}
{* Advanced PCI and Advanced MetaLib commented out for now
          <a href="{$path}/PCI/Advanced" class="small advancedLink PCILink">{translate text="Advanced PCI Search"}</a>
*}
        {else}
          <a href="{$path}/PCI/Home" class="small PCILink">{translate text="PCI Search"}</a>
        {/if}
      {/if}
      {if !$dualResultsEnabled}
        {if $metalibEnabled}
            <a href="{$path}/MetaLib/Home" class="small metalibLink">{translate text="MetaLib Search"}</a>
        {/if}
      {/if}
      </div>
    </div>

  {if $spatialDateRangeType}<input type="hidden" name="search_sdaterange_mvtype" value="{$spatialDateRangeType|escape}" />{/if}

  {* Load hidden limit preference from Session *}  
  {if $lastLimit}<input type="hidden" name="limit" value="{$lastLimit|escape}" />{/if}
  {if $lastSort}<input type="hidden" name="sort" value="{$lastSort|escape}" />{/if}

  </form>
{/if}

</div>

<!-- END of: Search/searchbox.tpl -->
