<!-- START of: PCI/searchbox.tpl -->

<div id="searchFormContainer" class="span12 searchform">

{if $searchType == 'PCIAdvanced'}
  <a href="{$path}/PCI/Advanced?edit={$searchId}" class="small">{translate text="Edit this Advanced PCI Search"}</a> |
  <a href="{$path}/PCI/Advanced" class="small">{translate text="Start a new Advanced PCI Search"}</a> |
  {if $dualResultsEnabled}
    <a href="{$path}/" class="small">{translate text="Start a new Basic Search"}</a>
  {else}
    <a href="{$path}/PCI/Home" class="small">{translate text="Start a new Basic PCI Search"}</a>
  {/if}
  <br/>{translate text="Your search terms"} : "<span class="strong">{$lookfor|escape:"html"}
  {foreach from=$orFilters item=values key=filter}
    AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}"</span>

{else}
  <script type="text/javascript">
  {literal}
      $(function(){
          $('.mainFocus').focus();
          $('.ui-autocomplete').addClass('dropdown-menu'); // TODO: remove and add this class where autocomplete is defined.
      });
  {/literal}
  </script>

  <form method="get" action="{$path}/PCI/Search" name="searchForm" id="searchForm" class="form-search text-center">
    <div {if !$showTopSearchBox}id="searchboxHome" {/if}class="row-fluid input-append searchbox">
      <input id="searchForm_input" type="text" name="lookfor" value="{$lookfor|escape}" class="search-query {if $autocomplete} autocomplete typeSelector:searchForm_type{/if} clearable mainFocus" placeholder='{translate text="Find"}&hellip;' onKeyPress="return submitenter(this,event)" />
      {if $prefilterList}
      <select id="searchForm_filter" class="selectpicker input-prepend text-left" name="prefilter">
      {foreach from=$prefilterList item=searchDesc key=searchVal}
        {if ($searchVal != "--")}
          <option value="{$searchVal|escape}"{if $searchVal == $activePrefilter || ($activePrefilter == null && $searchVal == "-") } selected="selected"{/if}{*if ($searchVal == "--")} data-divider="true"{/if *}>{$searchDesc|translate}</option>
        {else}
        <optgroup label="{translate text='Format'}">
        {/if}
      {/foreach}
        </optgroup>
      </select>
      {/if}
      <button id="searchForm_searchButton" type="submit" name="SearchForm_submit" class="btn btn-info"><i class="icon-search icon-white"></i>{*translate text="Find"*}</button>
    </div>

    <div class="searchContextHelp">
    {if isset($userLang)}
      {include file="Content/searchboxhelp.$userLang.tpl"}
    {/if}
    </div>

    <ul {if !$showTopSearchBox}id="advancedLinkHome" {/if}class="inline advanced-link-wrapper text-center hidden-phone">
      <li class="btn-mini"><a href="{$path}/Search/Advanced" class="advancedLink"><i class="icon-zoom-in"></i>&nbsp;{translate text="Advanced Search"}</a></li>
      <li class="btn-mini"><a href="{$path}/PCI/Advanced" class="small advancedLink"><i class="icon-zoom-in"></i>&nbsp;{translate text="Advanced PCI Search"}</a></li>
    {if $metalibEnabled}
      <li class="btn-mini"><a href="{$path}/MetaLib/Home" class="metalibLink"><i class="icon-search"></i>&nbsp;{translate text="MetaLib Search"}</a></li>
    {/if}
      <li class="btn-mini"><a href="{$path}/Search/History"><i class="icon-list-alt"></i>&nbsp;{translate text="Search History"}</a></li>
      <li class="btn-mini"><a href="{$path}/Browse/Home"><i class="icon-eye-open"></i>&nbsp;{translate text="Browse the Catalog"}</a></li>
      <li class="btn-mini"><a href="{$path}/Content/searchhelp" class="showSearchHelp"><i class="icon-info-sign"></i>&nbsp;{translate text="Search Tips"}</a></li>
    </ul>


<!--
<div class="searchform">
  {if $searchType == 'PCIAdvanced'}
    <a href="{$path}/PCI/Advanced?edit={$searchId}" class="small">{translate text="Edit this Advanced Search"}</a> |
    <a href="{$path}/PCI/Advanced" class="small">{translate text="Start a new Advanced Search"}</a> |
    <a href="{$path}/PCI/Home" class="small">{translate text="Start a new Basic Search"}</a>
    <br/>{translate text="Your search terms"} : "<strong>{$lookfor|escape:"html"}</strong>"
  {else}
    <form method="get" action="{$path}/PCI/Search" name="searchForm" id="searchForm" class="search">
      <label for="searchForm_lookfor" class="offscreen">{translate text="Search Terms"}</label>
      <input id="searchForm_lookfor" type="text" name="lookfor" size="40" value="{$lookfor|escape:"html"}"/>
      <label for="searchForm_type" class="offscreen">{translate text="Search Type"}</label>
      <select id="searchForm_type" name="type">
      {foreach from=$PCISearchTypes item=searchDesc key=searchVal}
        <option value="{$searchVal}"{if $searchIndex == $searchVal} selected="selected"{/if}>{translate text=$searchDesc}</option>
      {/foreach}
      </select>
      <input type="submit" name="submit" value="{translate text="Find"}"/>
      <a href="{$path}/PCI/Advanced" class="small">{translate text="Advanced"}</a>
-->

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
    <div class="alert alert-warning keepFilters">
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
{/if}

</div>


<!--

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
      {if $lastSort}<input type="hidden" name="sort" value="{$lastSort|escape}" />{/if}
    </form>
    <script type="text/javascript">$("#searchForm_lookfor").focus()</script>
  {/if}
</div>

-->

<!-- END of: PCI/searchbox.tpl -->
