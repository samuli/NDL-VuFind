<!-- START of: Search/searchbox.tpl -->
<div id="searchFormContainer" class="searchform last content">
{if $searchType != 'advanced'}
  {if in_array('search', $contextHelp)}
  <span id="contextHelp_search" class="showHelp">{translate text="Search Tips"}</span>
  {/if}


 {if $module == 'Browse'}
   {assign var='formModule' value='Browse'}
   {assign var='formAction' value=$action}
 {else}
  {assign var='formModule' value='Search'}
  {assign var='formAction' value='Results'}
 {/if}


  <form method="get" action="{$path}/{$formModule}/{$formAction}" name="searchForm" id="searchForm" class="search">
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

    <div id="480mobileFirst" class="advancedLinkWrapper {if !$dualResultsEnabled}no-{/if}dual{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
      <a id="move480mobile" href="{$path}/Search/Advanced" class="small advancedLink">{translate text="Advanced Search"}</a>
    </div>

    
  {if $shards}
    <br />
    {foreach from=$shards key=shard item=isSelected}
    <input type="checkbox" {if $isSelected}checked="checked" {/if}name="shard[]" value='{$shard|escape}' /> {$shard|translate}
    {/foreach}
  {/if}

  {if ($filterList || $activeCheckboxFilters || $filterListOthers) && !$disableKeepFilterControl}
    <div class="keepFilters">
      <div class="checkboxFilter">
        <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} id="searchFormKeepFilters" />
        <label for="searchFormKeepFilters">{translate text="basic_search_keep_filters"}</label>
      </div>     
      <div class="offscreen">

     {assign var="cnt" value=1} 
     {foreach from=$filterList item=data key=field name=filterLoop}
        {foreach from=$data item=value}
        <input id="applied_filter_{$cnt++}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="{$filterUrlParam}[]" value="{$value.field|escape}:&quot;{$value.value|escape}&quot;" />
        {/foreach}
     {/foreach}
        
    {foreach from=$checkboxFilters item=current name=filterLoop}
      {if $current.selected}
        <input id="applied_filter_{$cnt++}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="{$filterUrlParam}[]" value="{$current.filter|escape}" />
      {/if}
    {/foreach}

    {* filters for other search types *}
    {foreach from=$filterListOthers item=fields key=type name=typeLoop}
       {foreach from=$fields key=field item=filters name=filterLoop}
          {foreach from=$filters item=filter name=itemLoop}
              <input id="applied_filter_{$cnt++}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="{$type}[]" value="{$field|escape}:&quot;{$filter|escape}&quot;" />
          {/foreach}
      {/foreach}
    {/foreach}
      </div>
    </div>
  {/if}

    <div class="searchFormOuterWrapper">
      <div id="480mobileSecond" class="advancedLinkWrapper{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
      {if ($module == 'Search' && $action == 'Home') || $module == 'Browse' }
        {if $module == 'Browse'}
            <a href="{$path}/Search/Home" class="small homeLink">{translate text="Local Search"}</a>
         {/if}

        {if $pciEnabled}
            <a href="{$path}/PCI/Home" class="small PCILink">{translate text="PCI Search"}</a>
         {/if}
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

  {* Set followup module & action if search is started from record page *} 
  {if $followupSearchModule}<input type="hidden" name="followupSearchModule" value="{$followupSearchModule|escape}" />{/if}
  {if $followupSearchAction}<input type="hidden" name="followupSearchAction" value="{$followupSearchAction|escape}" />{/if}
  
  </form>
{/if}

</div>

{* Need to move the Advanced search link in narrow screens *}
<script type="text/javascript">
    $(window).resize(init480Mobile);     // Check if move is triggered
</script>

<!-- END of: Search/searchbox.tpl -->
