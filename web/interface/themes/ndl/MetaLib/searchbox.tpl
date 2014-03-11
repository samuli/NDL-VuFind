<!-- START of: MetaLib/searchbox.tpl -->

<div id="searchFormContainer" class="searchform searchformMetaLib last content"> 
{if in_array('searchMetaLib', $contextHelp)}
 <span id="contextHelp_searchMetaLib" class="showHelp">{translate text="Search Tips"}</span>
{/if}
    
{if $searchType != 'MetaLibAdvanced'}
  <form method="get" action="{$path}/MetaLib/Search" name="searchForm" id="searchForm" class="search">
    <div class="searchFormOuterWrapper">
	    <div class="searchFormWrapper">
	      <div class="overLabelWrapper">
	        <input id="searchForm_input" type="text" name="lookfor"  value="{$lookfor|escape}" autocomplete="off" class="last mainFocus clearable" placeholder='{translate text="Find"}&hellip;' />
	      </div>
	      <div class="styled_select">
	        <select id="searchForm_set" name="set" class="searchForm_styled">
	          {foreach from=$metalibSearchSets item=searchDesc key=searchVal name=loop}
	            <option value="{$searchVal}"{if $searchSet == $searchVal || (!$searchSet && $smarty.foreach.loop.first)} selected="selected"{/if}>{translate text=$searchDesc}</option>
	          {/foreach}
	        </select>
	      </div>
	      <input id="searchForm_searchButton" type="submit" name="submit" value="{translate text="Find"}"/>
	    </div>
	  </div>

    <div class="advancedLinkWrapper hide480mobile {if !$dualResultsEnabled}no-{/if}dual{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
      <a href="{$path}/MetaLib/Advanced" class="small advancedLink">{translate text="Advanced Nelli Metasearch"}</a>
    </div>
    
      {if $filterList || $activeCheckboxFilters}
        <div class="keepFilters">
          <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} id="searchFormKeepFilters"/> <label for="searchFormKeepFilters">{translate text="basic_search_keep_filters"}</label>
          <div class="offscreen">
            {foreach from=$filterList item=data key=field}
              {foreach from=$data item=value}
                <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="filter[]" value='{$value.field|escape}:"{$value.value|escape}"' />
              {/foreach}
            {/foreach}
            {foreach from=$checkboxFilters item=current}
              {if $current.selected}
                <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="filter[]" value="{$current.filter|escape}" />
              {/if}
            {/foreach}
          </div>
        </div>
      {/if}

     {* filters for other search types *}
     {if $filterListOthers}
      <div class="offscreen">
        {* include input for retainFilters -option if not already included above *}
        {if !$filterList && !$checkboxFilters}
          <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} id="searchFormKeepFilters"/> <label for="searchFormKeepFilters">{translate text="basic_search_keep_filters"}</label>
        {/if}

        {assign var="cnt" value=1} 
        {foreach from=$filterListOthers item=fields key=type name=typeLoop}
          {foreach from=$fields key=field item=filters name=filterLoop}
             {foreach from=$filters item=filter name=itemLoop}
                <input id="applied_filter_{$cnt++}" type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} name="{$type}[]" value="{$field|escape}:&quot;{$filter|escape}&quot;" />
             {/foreach}
           {/foreach}
        {/foreach}
      </div>
     {/if}
      
	    <div class="searchFormOuterWrapper">
	      <div class="advancedLinkWrapper{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
          <a href="{$path}/MetaLib/Advanced" class="small advancedLink show480mobile">{translate text="Advanced Nelli Metasearch"}</a>
      {if !$dualResultsEnabled}
	      {if $pciEnabled}
	        <a href="{$path}/PCI/Home" class="small PCILink">{translate text="PCI Search"}</a>
	      {/if}
          <a href="{$url}" class="small metalibLink">{translate text="Local Search"}</a>
      {/if}

	      </div>
	    </div>

      {if $spatialDateRangeType}<input type="hidden" name="search_sdaterange_mvtype" value="{$spatialDateRangeType|escape}" />{/if}

      {if $lastSort}<input type="hidden" name="sort" value="{$lastSort|escape}" />{/if}
    </form>
{/if}
</div>

<!-- END of: MetaLib/searchbox.tpl -->
