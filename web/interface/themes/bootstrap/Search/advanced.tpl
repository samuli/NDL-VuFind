<!-- START of: Search/advanced.tpl -->

<div id="advancedSearchWrapper" class="">

  <div class="row-fluid">
    <div class="span8 well-small">
      <h4>{translate text='Advanced Search'}</h4>
    </div>
    <div class="span4 sidegroup advancedSearchHelp">
      <p class="alert alert-info"><span class="infohelp pull-left" style="height: 13px; padding-top: 0; padding-right: 0; background-position: -48px 2px;"></span><a href="{$url}/Content/searchhelp">{translate text="Search Tips"}</a></p>
    </div>
  </div>

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

<form method="get" action="{$url}/Search/Results" id="advSearchForm" name="searchForm" class="form-inline search">
  <div class="span12">
    <div class="row-fluid">
      <div class="advSearchContent">
        {if $editErr}
          {assign var=error value="advSearchError_$editErr"}
          <div class="span12 alert alert-error">{translate text=$error}</div>
        {/if}
    
        <div id="groupJoin" class="well well-small searchGroups">
          <div class="pull-right searchGroupDetails">
            <div class="pull-left">
              <label for="groupJoinOptions"><strong>{translate text="search_match"}:&nbsp;</strong></label>
            </div>
            <select id="groupJoinOptions" class="selectpicker" name="join">
              <option value="AND">{translate text="group_AND"}</option>
              <option value="OR"{if $searchDetails and $searchDetails.0.join == 'OR'} selected="selected"{/if}>{translate text="group_OR"}</option>
            </select>
          </div>
          <div class="pull-left">
            <strong>{translate text="search_groups"}:</strong>
          </div>
        </div>
    
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
                {if $searchDetails}
                  {assign var=currRow value=$searchDetails.$groupIndex.group.$rowIndex}
                {/if}
                <ul class="inline advRow">
                  <li class="label">
                    <label {if $rowIndex > 0}class="offscreen" {/if}for="search_lookfor{$groupIndex}_{$rowIndex}"><strong>{translate text="adv_search_label"}:</strong></label>&nbsp;
                  </li>
                  <li class="terms">
                    <input id="search_lookfor{$groupIndex}_{$rowIndex}" type="text" value="{if $currRow}{$currRow.lookfor|escape}{/if}" size="50" name="lookfor{$groupIndex}[]"/>
                  </li>
                  <li class="field">
                    <label for="search_type{$groupIndex}_{$rowIndex}"><strong>{translate text="in"}&nbsp;&nbsp;</strong></label>
                    <select id="search_type{$groupIndex}_{$rowIndex}" name="type{$groupIndex}[]">
                    {foreach from=$advSearchTypes item=searchDesc key=searchVal}
                      <option value="{$searchVal}"{if $currRow and $currRow.field == $searchVal} selected="selected"{/if}>{translate text=$searchDesc}</option>
                    {/foreach}
                    </select>
                  </li>
                  <!--span class="clearer"></span-->
                </ul>
              {/section}
              </div>
            </div>
          {/section}
          </noscript>
        </div>
      </div>

    </div>
    <div class="pull-left">
      <a id="addGroupLink" href="#" class="btn btn-success offscreen" onclick="addGroup(); return false;"><i class="icon-plus-sign icon-white"></i>&nbsp;{translate text="add_search_group"}</a><br /><br />
    </div>

{* <!--
  {if $illustratedLimit}
    <div class="span8 offset1 well well-small pull-right">
      <div class="pull-left">
        <fieldset>
          {translate text="Illustrated"}:
          {foreach from=$illustratedLimit item="current"}
            <input id="illustrated_{$current.value|escape}" type="radio" name="illustration" value="{$current.value|escape}"{if $current.selected} checked="checked"{/if}/>
            <label for="illustrated_{$current.value|escape}">{translate text=$current.text}</label><br/>
          {/foreach}
        </fieldset>
      </div>
      <div class="span4 pull-right">
  {else}
    <div class="span4 well well-small pull-right">
  {/if}

  {if $limitList|@count gt 1}
      <fieldset class="offset4">
        {translate text='Results per page'}:
        <select id="limit" name="limit" class="selectpicker">
          {foreach from=$limitList item=limitData key=limitLabel}
*}
            {* If a previous limit was used, make that the default; otherwise, use the "default default" *}
{*
            {if $lastLimit}
              <option value="{$limitData.desc|escape}"{if $limitData.desc == $lastLimit} selected="selected"{/if}>{$limitData.desc|escape}</option>
            {else}
              <option value="{$limitData.desc|escape}"{if $limitData.selected} selected="selected"{/if}>{$limitData.desc|escape}</option>
            {/if}
          {/foreach}
        </select>
      </fieldset>
  {/if}
    </div>
  {if $illustratedLimit}

    </div>
  {/if}
--> *}
  </div>

  <!--div class="clearfix">&nbsp;</div-->

  <hr style="clear: both;" />
  
  <div class="row-fluid">   
  {if $dateRangeLimit}
    <div id="sliderWrapper" class="span7 well-small">
  {* Load the jslider UI widget *}
    {js filename="pubdate_slider.js"}
    {js filename="jshashtable-2.1_src.js"}
    {js filename="jquery.numberformatter-1.2.3.js"}
    {js filename="jquery.dependClass-0.1.js"}
    {js filename="draggable-0.1.js"}
    {js filename="jslider/jquery.slider.js"}
      <input type="hidden" name="daterange[]" value="main_date_str"/>
      <label class="label" for="publishDatefrom" id="pubDateLegend">{translate text='Main Year'}</label>
      <input type="text" size="4" maxlength="4" class="yearbox" name="main_date_strfrom" id="publishDatefrom" value="{if $dateRangeLimit.0}{$dateRangeLimit.0|escape}{/if}" /> - 
      <input type="text" size="4" maxlength="4" class="yearbox" name="main_date_strto" id="publishDateto" value="{if $dateRangeLimit.1}{$dateRangeLimit.1|escape}{/if}" />
      <br/>
      <div class="well-small" id="sliderContainer">
        <input id="publishDateSlider" class="dateSlider span-10" type="slider" name="sliderContainer" value="0000;2012" />
      </div>
      <div class="clearfix">&nbsp;</div>
    </div>
  {/if}
  
  {if $facetList}
    {js filename="chosen/chosen.jquery.js"}
    {js filename="chosen_multiselects.js"}
    {foreach from=$facetList item="list" key="label"}
      <div class="span4 offset1 well-small facetsContainer">
        <label class="label displayBlock" for="limit_{$label|replace:' ':''|escape}">{translate text=$label}:</label><br />
        <select class="chzn-select span12" data-placeholder="{translate text="No Preference"}" id="limit_{$label|replace:' ':''|escape}" name="orfilter[]" multiple="multiple" size="10">
        {foreach from=$list item="value" key="display"}
          <option value="{$value.filter|escape}"{if $value.selected} selected="selected"{/if}>{if $value.level > 0}&nbsp;&nbsp;&nbsp;{/if}{if $value.level > 1}&nbsp;&nbsp;&nbsp;{/if}{$value.translated|escape}</option>
        {/foreach}
        </select>
      </div>
    {/foreach}
  {/if}
  </div>

  <hr />  

  <div class="row-fluid">

    <div class="span12 mapContainer">
      {js filename="jquery.geo.min.js"}
      {js filename="selection_map.js"}
    {* help text, currently not included 
      <span class="small">Valitse kartalta tai syötä käsin muodossa: vasen yläkulma lat, vasen yläkulma lon, oikea alakulma lat, oikea alakulma lon</span>
    *}
      <div class="row-fluid">

        <div class="span7">
          <label class="label displayBlock" for="coordinates">{translate text='Coordinates:'}</label>
          <input id="coordinates" name="coordinates" />
        <div id="selectionMapTools">
          <label for="mapPan" class="radio inline">
            <input id="mapPan" type="radio" name="tool" value="pan" checked="checked" />
            {translate text='Move Map'}
          </label>
          <label for="mapPolygon" class="radio inline">
            <input id="mapPolygon" type="radio" name="tool" value="drawPolygon" />
            {translate text='Select Polygon'}
          </label>
          <label for="mapRectangle" class="radio inline">
            <input id="mapRectangle" type="radio" name="tool" value="dragBox" />
            {translate text='Select Rectangle'}
          </label>
        </div>
        </div>
        <div class="span5 alert alert-info">
          <span class="infohelp pull-left" style="height: 48px; padding-top: 0; padding-right: 0; background-position: -48px 2px;"></span>
          <span id="selectionMapHelp">            
            <span id="selectionMapHelpPan">{translate text="adv_search_map_pan_help"}</span>
            <span id="selectionMapHelpPolygon" class="hide">{translate text="adv_search_map_polygon_help"}</span>
            <span id="selectionMapHelpRectangle" class="hide">{translate text="adv_search_map_rectangle_help"}</span>
          </span>
        </div>
      </div>
      <div id="selectionMapContainer">
        <div id="zoomSlider">
          <div id="zoomControlPlus" class="ui-state-default ui-corner-all ui-icon ui-icon-plus">
          </div>
          <div id="zoomRange">
            <div id="zoomPath"></div>
          </div>
          <div id="zoomControlMinus" class="ui-state-default ui-corner-all ui-icon ui-icon-minus">
          </div>
        </div>
<!--
        <div id="selectionMapTools">
          <label for="mapPan" class="radio inline">
            <input id="mapPan" type="radio" name="tool" value="pan" checked="checked" />
            {translate text='Move Map'}
          </label>
          <label for="mapPolygon" class="radio inline">
            <input id="mapPolygon" type="radio" name="tool" value="drawPolygon" />
            {translate text='Select Polygon'}
          </label>
          <label for="mapRectangle" class="radio inline">
            <input id="mapRectangle" type="radio" name="tool" value="dragBox" />
            {translate text='Select Rectangle'}
          </label>
        </div>
-->
        <div id="selectionMap">              
        </div>
      </div>
<!--
      <span id="selectionMapHelp">
        <span id="selectionMapHelpPan">{translate text="adv_search_map_pan_help"}</span>
        <span id="selectionMapHelpPolygon" class="hide">{translate text="adv_search_map_polygon_help"}</span>
        <span id="selectionMapHelpRectangle" class="hide">{translate text="adv_search_map_rectangle_help"}</span>
      </span>
-->
    </div>
    {if $lastSort}
      <input type="hidden" name="sort" value="{$lastSort|escape}" />
    {/if}
    <div class="clearfix">&nbsp;</div>
  </div>

  <div class="row-fluid">
    <div class="pull-right">
      {*<input type="submit" class="btn btn-info btn-large button searchButton right" name="submit" value="{translate text="Find"}"/> *}
      <button id="advancedSearchButton" type="submit" class="btn btn-large btn-info" name="submit">{translate text="Find"}&nbsp;<i class="icon-zoom-in icon-white"></i></button>
    </div>
  </div>

</form>
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
        <select id="search_type<%=group%>_<%=groupSearches[group]%>" name="type<%=group%>[]" class="selectpicker" data-style="btn-normal">
        <% for ( key in searchFields ) { %>
            <option value="<%=key%>"<%=key == field ? ' selected="selected"' : ""%>"><%=searchFields[key]%></option>
        <% } %>
        </select>
    </li>

</ul>
</script>
<script type="text/html" id="new_group_tmpl">
    <div id="group<%=nextGroupNumber%>" class="text-right well well-small group group<%=nextGroupNumber % 2%>">
      <div class="pull-left">
        <a href="#" class="btn btn-small btn-danger delete" id="delete_link_<%=nextGroupNumber%>" onclick="deleteGroupJS(this); return false;"><i class="icon-remove icon-white delete"></i>&nbsp;<%=deleteSearchGroupString%></a>
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
        <div class="text-left addSearch"><a href="#" class="btn btn-small btn-success" id="add_search_link_<%=nextGroupNumber%>" onclick="addSearchJS(this); return false;"><i class="icon-plus-sign icon-white"></i>&nbsp;<%=addSearchString%></a></div>
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
  $(document).on('click', 'a[id^="add"]', function() {
    $('select').not('.chzn-select').selectpicker();
  });
{/literal}
</script>

<!-- END of: Search/advanced.tpl -->
