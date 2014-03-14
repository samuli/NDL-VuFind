<!-- START of: Search/list-dual-pci.tpl -->

{js filename="openurl.js"}
{if $showPreviews}
{js filename="preview.js"}
{/if}

{include file="Search/openurl_autocheck.tpl"}

<div class="resultHeader">
  {if $recordCount}
  <div class="resultViewOptions resultListTop clearfix">
    <div class="resultNumbers">
      <span class="currentPage"><span>{translate text="Search Results"}</span> {$recordStart}&#8201;-&#8201;{$recordEnd} / </span>
      <span class="resultTotals">{$recordCount|number_format:0:".":" "|replace:" ":"&#x2006;"}</span>
    </div>
    <div class="resultOptions">
      {if $recordCount}<a href="{$more|escape}">{translate text="More"} &raquo;</a>{/if}
    </div>
  </div>
     {if $showLocalFiltersNote}
     <div class="localFiltersNote">
       <a href="{$searchWithoutLocalFilters|escape}" title="{translate text="Remove Filters"}"><span class="roundButton deleteButtonSmall"></span></a>
       <a href="{$more|escape}">{translate text="local_filters_note"}</a>
     </div>
     {/if}
  {else}
     {if $showLocalFiltersNote}
     <div class="localFiltersNote">
        <a href="{$searchWithoutLocalFilters|escape}" title="{translate text="Remove Filters"}"><span class="roundButton deleteButtonSmall"></span></a>
        <a href="{$more|escape}">{translate text="local_filters_note"}</a>
     </div>
     {/if}
     <div class="resultViewOptions clearfix {if $noQuery}emptySearchNote{else}noResultHeader{/if}">
      <div class="resultNumbers">
        {if $noQuery}
           {translate text="pci_no_query"}
        {else}
           {translate text="nohit_heading"}
        {/if}
      </div>
    </div>
  {/if}
  {if $spellingSuggestions}
    <br /><br />
    <div class="correction"><strong>{translate text='spell_suggest'}</strong>:<br/>
    {foreach from=$spellingSuggestions item=details key=term name=termLoop}
      {$term|escape} &raquo; {foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a href="{$data.expand_url|escape}"><img src="{$path}/images/silk/expand.png" alt="{translate text='spell_expand_alt'}"/></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}{if !$smarty.foreach.termLoop.last}<br/>{/if}
    {/foreach}
    </div>
  {/if}
</div>
{* End Listing Options *}

{include file='PCI/list-list.tpl'}

{if $recordCount}
<div class="resultViewOptions resultListBottom clearfix">
  <div class="resultNumbers">
    <span class="currentPage"><span>{translate text="Search Results"}</span> {$recordStart}&#8201;-&#8201;{$recordEnd} / </span>
    <span class="resultTotals">{$recordCount|number_format:0:".":" "|replace:" ":"&#x2006;"}</span>
  </div>
  <div class="resultOptions">
    {if $recordCount}<a href="{$more|escape}">{translate text="More"} &raquo;</a>{/if}
  </div>
</div>
{/if}

<!-- END of: Search/list-dual-pci.tpl -->
