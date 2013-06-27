<!-- START of: PCI/advanced.tpl -->

<div id="advancedSearchWrapper" class="">

  <div class="row-fluid">
    <div class="span8 well-small">
      <h4>{translate text='pci_advanced_search_description'}</h4>
    </div>
    <div class="span4 alert alert-info sidegroup">
      <p><span class="infohelp pull-left" style="height: 13px; padding-top: 0; padding-right: 0; background-position: -48px 2px;"></span><a href="{$url}/Content/searchhelp">{translate text="Search Tips"}</a></p>
    </div>
  </div>
{*
  {if $searchFilters}
  <div class="row-fluid">
    <div class="span4 offset8 alert alert-warning">
      <div class="filterList">
        <h4>{translate text="adv_search_filters"}<br/><span>({translate text="adv_search_select_all"} <input type="checkbox" checked="checked" onclick="filterAll(this, 'advSearchForm');" />)</span></h4>
        {foreach from=$searchFilters item=data key=field}
        <div>
          <h5>{translate text=$field}</h5>
          <ul>
            {foreach from=$data item=value}
            <li><input type="checkbox" checked="checked" name="filter[]" value='{$value.field|escape}:"{$value.value|escape}"' /> {$value.display|escape}</li>
            {/foreach}
          </ul>
        </div>
        {/foreach}
      </div>
    </div>
  </div>
  {/if}
*}
  <form method="get" action="{$url}/PCI/Search" id="advSearchForm" name="searchForm" class="form-inline search">
    <div class="span12 well well-small">
      <div class="advSearchContent">
        {if $editErr}
          {assign var=error value="advSearchError_$editErr"}
          <div class="span12 alert alert-error">{translate text=$error}</div>
        {/if}

          <div id="groupJoin" class="row-fluid searchGroups">
            <div class="well well-small pull-right searchGroupDetails">
              <div class="pull-left well-small">
                <label for="groupJoinOptions"><strong>{translate text="search_match"}:</strong></label>
              </div>
              <select id="groupJoinOptions" class="selectpicker" name="join">
                <option value="AND">{translate text="group_AND"}</option>
                <option value="OR"{if $searchDetails and $searchDetails.0.join == 'OR'} selected="selected"{/if}>{translate text="group_OR"}</option>
              </select>
            </div>
            <div class="pull-left well-small">
              <strong>{translate text="search_groups"}:</strong>
            </div>
          </div>

        <input type="hidden" name="join" value="AND" />
        {* An empty div. This is the target for the javascript that builds this screen *}
        <div id="searchHolder" class="last">
          {* fallback to a fixed set of search groups/fields if JavaScript is turned off *}
          <noscript>
          {if $searchDetails}
            {assign var=numGroups value=$searchDetails|@count}
          {/if}
          {if $numGroups < 3}{assign var=numGroups value=3}{/if}
          {section name=groups loop=$numGroups}
            {assign var=groupIndex value=$smarty.section.groups.index}
            <div class="text-right well well-small group group{$groupIndex%2}" id="group{$groupIndex}">
              <div class="groupSearchDetails">
                <div class="join">
                  <label for="search_bool{$groupIndex}" class="label"><strong>{translate text="search_match"}:</strong></label>
                  <select id="search_bool{$groupIndex}" name="bool{$groupIndex}[]">
                    <option value="AND"{if $searchDetails and $searchDetails.$groupIndex.group.0.bool == 'AND'} selected="selected"{/if}>{translate text="search_AND"}</option>
                    <option value="OR"{if $searchDetails and $searchDetails.$groupIndex.group.0.bool == 'OR'} selected="selected"{/if}>{translate text="search_OR"}</option>
                    <option value="NOT"{if $searchDetails and $searchDetails.$groupIndex.group.0.bool == 'NOT'} selected="selected"{/if}>{translate text="search_NOT"}</option>
                  </select>
                </div>
              </div>
              <div class="groupSearchHolder" id="group{$groupIndex}SearchHolder">
              {if $searchDetails}
                {assign var=numRows value=$searchDetails.$groupIndex.group|@count}
              {/if}
              {if $numRows < 3}{assign var=numRows value=3}{/if}
              {section name=rows loop=$numRows}
                {assign var=rowIndex value=$smarty.section.rows.index}
                {if $searchDetails}{assign var=currRow value=$searchDetails.$groupIndex.group.$rowIndex}{/if}
                <ul class="inline advRow">
                  <li class="label">
                    <label {if $rowIndex > 0}class="offscreen" {/if}for="search_lookfor{$groupIndex}_{$rowIndex}">{translate text="adv_search_label"}:</label>&nbsp;
                  </li>
                  <li class="terms">
                    <input id="search_lookfor{$groupIndex}_{$rowIndex}" type="text" value="{if $currRow}{$currRow.lookfor|escape}{/if}" size="50" name="lookfor{$groupIndex}[]"/>
                  </li>
                  <li class="field">
                    <label for="search_type{$groupIndex}_{$rowIndex}">{translate text="in"}</label>
                    <select id="search_type{$groupIndex}_{$rowIndex}" name="type{$groupIndex}[]">
                    {foreach from=$advSearchTypes item=searchDesc key=searchVal}
                      <option value="{$searchVal}"{if $currRow and $currRow.field == $searchVal} selected="selected"{/if}>{translate text=$searchDesc}</option>
                    {/foreach}
                    </select>
                  </li>
                  <!--{* <span class="clearer"></span> *}-->
                </ul>
              {/section}
              </div>
            </div>
          {/section}
          </noscript>
        </div> {* searchHolder *}

      </div> {* advSearchContent *}

    </div> {* span12 *}
    <div class="row-fluid">
      <div class="well-small pull-right">
        <button id="advancedSearchButton" type="submit" class="btn btn-large btn-info" name="submit">{translate text="Find"}&nbsp;<i class="icon-zoom-in icon-white"></i></button>
      </div>
    </div>
  </form>
  <br />
  <br />

{literal}
<script type="text/html" id="new_search_tmpl">
<ul class="inline advRow">
    <li class="">
        <label class="label pull-left <%=(groupSearches[group] > 0 ? "{*hide*}" : "")%>" for="search_lookfor<%=group%>_<%=groupSearches[group]%>"><strong><%=searchLabel%>:</strong></label>&nbsp;
    </li>
    <li class="terms">
        <input type="text" id="search_lookfor<%=group%>_<%=groupSearches[group]%>" name="lookfor<%=group%>[]" size="50" value="<%=jsEntityEncode(term)%>" />
    </li>
    <li class="field">
        <label for="search_type<%=group%>_<%=groupSearches[group]%>"><strong><%=searchFieldLabel%></strong>&nbsp;&nbsp;</label>
        <select id="search_type<%=group%>_<%=groupSearches[group]%>" name="type<%=group%>[]" class="selectpicker">
        <% for ( key in searchFields ) { %>
            <option value="<%=key%>"<%=key == field ? ' selected="selected"' : ""%>"><%=searchFields[key]%></option>
        <% } %>
        </select>
    </li>
  </ul>
</script>

<script type="text/html" id="new_group_tmpl">
    <div id="group<%=nextGroupNumber%>" class="text-right group group<%=nextGroupNumber % 2%>">
      <div class="pull-left">
        <a href="#" class="btn btn-mini btn-danger delete" id="delete_link_<%=nextGroupNumber%>" onclick="deleteGroupJS(this); return false;"><i class="icon-remove icon-white delete"></i>&nbsp;<%=deleteSearchGroupString%></a>
      </div>
        <div class="groupSearchDetails">
            <div class="join">
                <label for="search_bool<%=nextGroupNumber%>"><strong><%=searchMatch%>:</strong></label>
                <select class="selectpicker" id="search_bool<%=nextGroupNumber%>" name="bool<%=nextGroupNumber%>[]">
                    <% for ( key in searchJoins ) { %>
                        <option value="<%=key%>"<%=key == join ? ' selected="selected"' : ""%>"><%=searchJoins[key]%></option>
                    <% } %>
                </select>
            </div>
        </div>

        <div id="group<%=nextGroupNumber%>SearchHolder" class="text-left groupSearchHolder"></div>
        <div class="span2 offset1 text-left addSearch"><a href="#" class="btn btn-mini btn-success" id="add_search_link_<%=nextGroupNumber%>" onclick="addSearchJS(this); return false;"><i class="icon-plus-sign icon-white"></i>&nbsp;<%=addSearchString%></a></div>
    </div>
</script>
{/literal}
{* Step 1: Define our search arrays so they are usuable in the javascript *}
<script type="text/javascript">
//<![CDATA[
    var searchFields = new Array();
    {foreach from=$advSearchTypes item=searchDesc key=searchVal}
    searchFields["{$searchVal}"] = "{translate text=$searchDesc}";
    {/foreach}
    var searchJoins = new Array();
    searchJoins["AND"]  = "{translate text="search_AND"}";
    searchJoins["OR"]   = "{translate text="search_OR"}";
    searchJoins["NOT"]  = "{translate text="search_NOT"}";
    var addSearchString = "{translate text="add_search"}";
    var searchLabel     = "{translate text="adv_search_label"}";
    var searchFieldLabel = "{translate text="in"}";
    var deleteSearchGroupString = "{translate text="del_search"}";
    var searchMatch     = "{translate text="search_match"}";
    var searchFormId    = 'advSearchForm';
//]]>
</script>
{* Step 2: Call the javascript to make use of the above *}
{js filename="advanced_search.js"}
{* Step 3: Build the page *}
<script type="text/javascript">
//<![CDATA[
  {if $searchDetails}
    {foreach from=$searchDetails item=searchGroup}
      {foreach from=$searchGroup.group item=search name=groupLoop}
        {if $smarty.foreach.groupLoop.iteration == 1}
    var new_group = addGroup('{$search.lookfor|escape:"javascript"}', '{$search.field|escape:"javascript"}', '{$search.bool}');
        {else}
    addSearch(new_group, '{$search.lookfor|escape:"javascript"}', '{$search.field|escape:"javascript"}');
        {/if}
      {/foreach}
    {/foreach}
  {else}
    var new_group = addGroup();
    addSearch(new_group);
    addSearch(new_group);
  {/if}
  // show the add group link
  $("#addGroupLink").removeClass("offscreen");
//]]>
</script>
</div>
{* Apply selectpicker style to added fields *}
<script type="text/javascript">
{literal}
  $("[id^=add_search_link_]").click(function() {
    $('select').selectpicker();
  });
{/literal}
</script>

<!-- END of: Search/advanced.tpl -->
