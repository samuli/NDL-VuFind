<!-- START of: MetaLib/advanced.tpl -->

<div id="advancedSearchWrapper">
<form method="get" action="{$url}/MetaLib/Search" id="advSearchForm" name="searchForm" class="search">
  <input name="join" type="hidden" value="AND" />
  <div class="advSearchHeader">
    <div class="content">
      <h1>{translate text='Advanced Search'}</h1>{if in_array('searchMetaLibAdvanced', $contextHelp)}<span id="contextHelp_searchMetaLibAdvanced" class="showHelp">{translate text="Search Tips"}</span>{/if}
    </div>
  </div> {* advSearchHeader *}
  {* tabNavi *}
  {include file="Search/tabnavi.tpl"}

  <div class="content">
    <div class="advSearchContent">
      <div class="advSearchSection first grid_24">
      {if $editErr}
      {assign var=error value="advSearchError_$editErr"}
        <div class="error">{translate text=$error}</div>
      {/if}

        <div id="searchHolder" class="clearfix">
        {assign var=numGroups value=1}
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
            {if $numRows < 2}{assign var=numRows value=2}{/if}
            {section name=rows loop=$numRows}
              {assign var=rowIndex value=$smarty.section.rows.index}
              {if $searchDetails}{assign var=currRow value=$searchDetails.$groupIndex.group.$rowIndex}{/if}
              <div class="advRow{if $rowIndex == $numGroups} last{/if}">
                <div class="label">
                  <label for="search_lookfor{$groupIndex}_{$rowIndex}">{translate text="adv_search_label"}:</label>&nbsp;
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
        </div> {* searchHolder *}

        <div class="searchForm_setWrapper">
          <label for="searchForm_set">{translate text="Search In Set"}:</label>
          <div id="searchForm_set">
          {foreach from=$metalibSearchSets item=searchDesc key=searchVal}
              <input id="{$searchVal}" type="radio" name="set" value="{$searchVal}"{if $set == $searchVal} checked="checked"{/if}/>
              <label for="{$searchVal}"><span></span></label>{translate text=$searchDesc} &nbsp;&nbsp;&nbsp;
          {/foreach}
          </div>

          <div class="clear"></div>
        </div>
      </div> {* advSearchSection *}
      <input type="submit" class="button buttonFinna searchButton right" name="submit" value="{translate text="Find"}" />

    </div> {* advSearchContent *}

  {if $lastSort}<input type="hidden" name="sort" value="{$lastSort|escape}" />{/if}
  </div> {* content *}
  <div class="clear"></div>
</form>
</div> {* advancedSearchWrapper *}
<!-- START of: MetaLib/advanced.tpl -->
