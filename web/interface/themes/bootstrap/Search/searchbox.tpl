<!-- START of: Search/searchbox.tpl -->

<div id="searchFormContainer" class="span12 searchform">

{if $searchType != 'advanced'}
  <script type="text/javascript">
    {literal}
      $(function(){
    {/literal}
        {if $module != 'MyResearch'}
    {literal}
          initSearchInputListener();
    {/literal}
        {/if}
    {literal}
          $('.ui-autocomplete').addClass('dropdown-menu'); // TODO: remove and add this class where autocomplete is defined.
      });
    {/literal}
  </script>
{*
     Without this script + onKeyPress in searchForm_input the pressing of ENTER 
     always just selects the dropdown list which is not the wanted behaviour.
     TODO: A more simple solution/fix most welcome. Feel free to implement ;)
     UPDATE: Seems to be fixed with bootstrap-select update 

  <script type="text/javascript">
  {literal}
      function submitenter(myfield,e) {
          var keycode;
          if (window.event) keycode = window.event.keyCode;
          else if (e) keycode = e.which;
          else return true;

          if (keycode == 13) {
              myfield.form.submit();
              return false;
          }
          else
              return true;
      }
  {/literal}
  </script>
*}
  <form method="get" action="{$path}/Search/Results" name="searchForm" id="searchForm" class="form-search text-center">
{if $pageTemplate != 'advanced.tpl'}
    <div {if !$showTopSearchBox}id="searchboxHome" {/if}class="row-fluid input-append searchbox">
      <input id="searchForm_input" type="text" name="lookfor" value="{$lookfor|escape}" class="search-query {if $autocomplete} autocomplete typeSelector:searchForm_type{/if} clearable mainFocus" placeholder='{translate text="Find"}&hellip;' />
    {if $prefilterList}
      <select id="searchForm_filter" class="selectpicker input-prepend text-left" name="prefilter">
      {foreach from=$prefilterList item=searchDesc key=searchVal}
        {*if ($searchVal != "--")*}
          <option value="{$searchVal|escape}"{if $searchVal == $activePrefilter || ($activePrefilter == null && $searchVal == "-") } selected="selected"{/if}{if ($searchVal == "--")} data-divider="true"{/if}>{$searchDesc|translate}</option>
        {*else}
        <optgroup label="{translate text='Format'}">
        {/if*}
      {/foreach}
        {*</optgroup>*}
      </select>
    {/if}
      <button id="searchForm_searchButton" type="submit" name="SearchForm_submit" title="{translate text="Find"}" class="btn btn-info"><i class="icon-search icon-white"></i>{*translate text="Find"*}</button>
    </div>
{/if}
    <div class="searchContextHelp">
    {if isset($userLang)}
      {include file="Content/searchboxhelp.$userLang.tpl"}
    {/if}
    </div>
{if $pageTemplate != 'advanced.tpl'}
    <ul {if !$showTopSearchBox}id="advancedLinkHome" {/if}class="inline advanced-link-wrapper text-center hidden-phone">
      <li><a href="{$path}/Search/Advanced" class="badge advancedLink" title="{translate text="Advanced Search"}"><i class="icon-zoom-in"></i>&nbsp;{translate text="Advanced Search"}</a></li>
    {if $pciEnabled}
      {if $dualResultsEnabled}
        <li><a href="{$path}/PCI/Advanced" class="badge pciLink" title="{translate text="Advanced PCI Search"}"><i class="icon-zoom-in"></i>&nbsp;{translate text="Advanced PCI Search"}</a></li>
      {else}
        <li><a href="{$path}/PCI/Home" class="badge pciLink" title="{translate text="PCI Search"}"><i class="icon-search"></i>&nbsp;{translate text="PCI Search"}</a></li>
      {/if}
    {/if}
    {if $metalibEnabled}
      <li><a href="{$path}/MetaLib/Home" class="badge metalibLink" title="{translate text="MetaLib Search"}"><i class="icon-search"></i>&nbsp;{translate text="MetaLib Search"}</a></li>
    {/if}
      <li><a href="{$path}/Search/History" class="badge browseLink" title="{translate text="Search History"}"><i class="icon-list-alt"></i>&nbsp;{translate text="Search History"}</a></li>
      <li class=""><a href="{$path}/Browse/Home" class="badge browseLink" title="{translate text="Browse the Catalog"}"><i class="icon-eye-open"></i>&nbsp;{translate text="Browse the Catalog"}</a></li>
    </ul>
{/if}

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

<!-- END of: Search/searchbox.tpl -->
