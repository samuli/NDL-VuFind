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
     {if $prefilterList}
        <div class="styled_select">
          <select id="searchForm_filter" class="searchForm_styled" name="prefilter">
          {foreach from=$prefilterList item=searchDesc key=searchVal}    
            <option value="{$searchVal|escape}"{if $searchVal == $activePrefilter || ($activePrefilter == null && $searchVal == "-") } selected="selected"{/if}>{$searchDesc|translate}</option>
          {/foreach}
          </select>
        </div>
     {/if}

        <input type="hidden" name="set" id="searchForm_set" value="{$searchSet}">
        <input id="searchForm_searchButton" type="submit" name="submit" value="{translate text="Find"}"/>
      </div>
    </div>

    <div id="480mobileFirst" class="advancedLinkWrapper {if !$dualResultsEnabled}no-{/if}dual{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
      <a id="move480mobile" href="{$path}/MetaLib/Advanced" class="small advancedLink">{translate text="Advanced Nelli Metasearch"}</a>
    </div>
    
     {if ($filterList || $activeCheckboxFilters || $filterListOthers) && !$disableKeepFilterControl}
    <div class="keepFilters">
      <div class="checkboxFilter">
       <input type="checkbox" {if $retainFiltersByDefault}checked="checked" {/if} id="searchFormKeepFilters"/>
        <label for="searchFormKeepFilters">{translate text="basic_search_keep_filters"}</label>
      </div>
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
     {/if}
      
      <div class="searchFormOuterWrapper">
        <div id="480mobileSecond" class="advancedLinkWrapper{if $pciEnabled} PCIEnabled{/if}{if $metalibEnabled} MetaLibEnabled{/if}">
        {if $action == 'Home'}
          <a href="{$path}/Search/Home" class="small PCILink">{translate text="Local Search"}</a>
          {if $pciEnabled}
          <a href="{$path}/PCI/Home" class="small PCILink">{translate text="PCI Search"}</a>
          {/if}
        {/if}
        </div>
      </div>
      {if $spatialDateRangeType}<input type="hidden" name="search_sdaterange_mvtype" value="{$spatialDateRangeType|escape}" />{/if}

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

<!-- END of: MetaLib/searchbox.tpl -->
