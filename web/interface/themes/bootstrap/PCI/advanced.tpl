<!-- START of: PCI/advanced.tpl -->

<div id="advancedSearchWrapper">
<form method="get" action="{$url}/PCI/Search" id="advSearchForm" name="searchForm" class="search">
  <div class="{*span-10*}">
    <h3>{translate text='Advanced Search'}</h3>
    <div class="advSearchContent">
      {if $editErr}
      {assign var=error value="advSearchError_$editErr"}
        <div class="error">{translate text=$error}</div>
      {/if}
      <input type="hidden" name="join" value="AND" />
      {* An empty div. This is the target for the javascript that builds this screen *}
      <div id="searchHolder" class="{*span-10*} last">
        {* fallback to a fixed set of search groups/fields if JavaScript is turned off *}
        <noscript>
        {if $searchDetails}
          {assign var=numGroups value=$searchDetails|@count}
        {/if}
        {if $numGroups < 3}{assign var=numGroups value=3}{/if}
        {section name=groups loop=$numGroups}
          {assign var=groupIndex value=$smarty.section.groups.index}
          <div class="group group{$groupIndex%2}" id="group{$groupIndex}">
            <div class="groupSearchDetails">
              <div class="join">
                <label for="search_bool{$groupIndex}">{translate text="search_match"}:</label>
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
              <div class="advRow">
                <div class="label">
                  <label {if $rowIndex > 0}class="offscreen" {/if}for="search_lookfor{$groupIndex}_{$rowIndex}">{translate text="adv_search_label"}:</label>&nbsp;
                </div>
                <div class="terms">
                  <input id="search_lookfor{$groupIndex}_{$rowIndex}" type="text" value="{if $currRow}{$currRow.lookfor|escape}{/if}" size="50" name="lookfor{$groupIndex}[]"/>
                </div>
                <div class="field">
                  <label for="search_type{$groupIndex}_{$rowIndex}">{translate text="in"}</label>
                  <select id="search_type{$groupIndex}_{$rowIndex}" name="type{$groupIndex}[]">
                  {foreach from=$advSearchTypes item=searchDesc key=searchVal}
                    <option value="{$searchVal}"{if $currRow and $currRow.field == $searchVal} selected="selected"{/if}>{translate text=$searchDesc}</option>
                  {/foreach}
                  </select>
                </div>
                <span class="clearer"></span>
              </div>
            {/section}
            </div>
          </div>
        {/section}
        </noscript>
      </div>
      <div class="clear"></div>
      <input type="submit" class="button searchButton right" name="submit" value="{translate text="Find"}"/>
    </div>
  </div>
    <div class="sidegroup">
      <p><a href="{$url}/Content/searchhelp">{translate text="Search Tips"}</a></p>
    </div>
  </div>

  <div class="clear"></div>
</form>
<br />
<br />
{literal}
<script type="text/html" id="new_search_tmpl">
<div class="advRow">
    <div class="label">
        <label class="<%=(groupSearches[group] > 0 ? "hide" : "")%>" for="search_lookfor<%=group%>_<%=groupSearches[group]%>"><%=searchLabel%>:</label>&nbsp;
    </div>
    <div class="terms">
        <input type="text" id="search_lookfor<%=group%>_<%=groupSearches[group]%>" name="lookfor<%=group%>[]" size="50" value="<%=jsEntityEncode(term)%>" />
    </div>
    <div class="field">
        <label for="search_type<%=group%>_<%=groupSearches[group]%>"><%=searchFieldLabel%></label>
        <select id="search_type<%=group%>_<%=groupSearches[group]%>" name="type<%=group%>[]">
        <% for ( key in searchFields ) { %>
            <option value="<%=key%>"<%=key == field ? ' selected="selected"' : ""%>"><%=searchFields[key]%></option>
        <% } %>
        </select>
    </div>
<span class="clearer"></span>
</div>
</script>
<script type="text/html" id="new_group_tmpl">
    <div id="group<%=nextGroupNumber%>" class="group group<%=nextGroupNumber % 2%>">
        <div class="groupSearchDetails">
            <div class="join">
                <label for="search_bool<%=nextGroupNumber%>"><%=searchMatch%>:</label>
                <select id="search_bool<%=nextGroupNumber%>" name="bool<%=nextGroupNumber%>[]">
                    <% for ( key in searchJoins ) { %>
                        <option value="<%=key%>"<%=key == join ? ' selected="selected"' : ""%>"><%=searchJoins[key]%></option>
                    <% } %>
                </select>
            </div>
            <a href="#" class="delete" id="delete_link_<%=nextGroupNumber%>" onclick="deleteGroupJS(this); return false;"><%=deleteSearchGroupString%></a>
        </div>
        <div id="group<%=nextGroupNumber%>SearchHolder" class="groupSearchHolder"></div>
        <div class="addSearch"><a href="#" class="add" id="add_search_link_<%=nextGroupNumber%>" onclick="addSearchJS(this); return false;"><%=addSearchString%></a></div>
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

<!-- END of: Search/advanced.tpl -->
