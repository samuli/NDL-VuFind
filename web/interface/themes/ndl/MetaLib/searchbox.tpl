<!-- START of: MetaLib/searchbox.tpl -->

<div id="searchFormContainer" class="searchform searchformMetaLib last content"> 
    
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
    
      {* Do we have any checkbox filters? *}
      {assign var="hasCheckboxFilters" value="0"}
      {if isset($checkboxFilters) && count($checkboxFilters) > 0}
        {foreach from=$checkboxFilters item=current}
          {if $current.selected}
            {assign var="hasCheckboxFilters" value="1"}
          {/if}
        {/foreach}
      {/if}
      {if $filterList || $hasCheckboxFilters}
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
      
	    <div class="searchFormOuterWrapper">
	      <div class="advancedLinkWrapper{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
	      {if $pciEnabled && !$dualResultsEnabled}
	          <a href="{$path}/PCI/Home" class="small PCILink">{translate text="PCI Search"}</a>
	      {/if}
        <a href="{$path}" class="small metalibLink">{translate text="Local Search"}</a>
	      </div>
	    </div>
      
      {if $lastSort}<input type="hidden" name="sort" value="{$lastSort|escape}" />{/if}
    </form>
{/if}
</div>

<!-- END of: MetaLib/searchbox.tpl -->