<!-- START of: MetaLib/searchbox.tpl -->

<div class="searchform last">
  {if $searchType == 'MetaLibAdvanced'}
    <a href="{$path}/MetaLib/Advanced?edit={$searchId}&set={$searchSet|escape}" class="small">{translate text="Edit this Advanced Search"}</a> |
    <a href="{$path}/MetaLib/Advanced?set={$searchSet|escape}" class="small">{translate text="Start a new Advanced Search"}</a> |
    <a href="{$path}/MetaLib/Home?set={$searchSet|escape}" class="small">{translate text="Start a new Basic Search"}</a>
    <br/>{translate text="Your search terms"} : "<strong>{$lookfor|escape:"html"}</strong>"
  {else}

    <script type="text/javascript">
    {literal}
        $(function(){
            $('.mainFocus').focus();
        });
    {/literal}
    </script>

    <form method="get" action="{$path}/MetaLib/Search" name="searchForm" id="searchForm" class="form-search text-center">
      <div class="row-fluid input-append searchbox">
{*
        <label for="searchForm_input" class="offscreen">{translate text="Search Terms"}</label>
*}
        <input id="searchForm_input" class="search-query MetaLib clearable mainFocus" type="text" name="lookfor"{* size="40" style="width:200px;"*} value="{$lookfor|escape:"html"}" autocomplete="off" placeholder='{translate text="Find"}&hellip;'/>
{*
        <div class="styled_select">
          <label for="searchForm_set" class="offscreen">{translate text="Search In"}</label>
*}
          <select id="searchForm_set" name="set" class="selectpicker input-prepend text-left searchForm_styled">
          {foreach from=$metalibSearchSets item=searchDesc key=searchVal name=loop}
            <option value="{$searchVal}"{if $searchSet == $searchVal || (!$searchSet && $smarty.foreach.loop.first)} selected="selected"{/if}>{translate text=$searchDesc}</option>
          {/foreach}
          </select>
      <button id="searchForm_searchButton" type="submit" name="SearchForm_submit" class="btn btn-info"><i class="icon-search icon-white"></i>{*translate text="Find"*}</button>
{*
        </div>
        <input id="searchForm_searchButton" type="submit" name="submit" value="{translate text="Find"}"/>
*}
      </div>

      <ul {if !$showTopSearchBox}id="advancedLinkHome" {/if}class="inline advanced-link-wrapper text-center hidden-phone">
        <li class=""><a href="{$path}/" class="badge localLink" title="{translate text="Local Search"}"><i class="icon-search"></i>&nbsp;{translate text="Local Search"}</a></li>
{*
      {if $pciEnabled}
        <li><a href="{$path}/PCI/Advanced" class="small pciLink" title="{translate text="Advanced PCI Search"}"><i class="icon-zoom-in"></i>&nbsp;{translate text="Advanced PCI Search"}</a></li>
      {/if}
*}
        <li class=""><a href="{$path}/Search/History" class="badge browseLink" title="{translate text="Search History"}"><i class="icon-list-alt"></i>&nbsp;{translate text="Search History"}</a></li>
{*
        <li class=""><a href="{$path}/Browse/Home" class="browseLink" title="{translate text="Browse the Catalog"}"><i class="icon-eye-open"></i>&nbsp;{translate text="Browse the Catalog"}</a></li>
*}
{*
        <li class=""><a href="{$path}/Content/searchhelp" class="showSearchHelp"><i class="icon-info-sign"></i>&nbsp;{translate text="Search Tips"}</a></li>
*}
      </ul>

{*
      <div class="advanced-link-wrapper clear">
        <a href="{$path}/MetaLib/Advanced?set={$searchSet|escape}" class="small advancedLink">{translate text="Advanced Search"}</a>
        <a href="{$path}/" class="small last metalibLink">{translate text="Local search"}</a>
      </div>
*}
      {* js filename="dropdown.js" *}
    
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

{* quick script to compensate for the Nelli-logo *}
<script type="text/javascript">
{literal}
$(document).ready(function() {
      $("#searchForm_input").css({width:'151px'});
      $("a.clear_input").css({left:'209px'});
});
{/literal}
</script>

<!-- END of: MetaLib/searchbox.tpl -->
