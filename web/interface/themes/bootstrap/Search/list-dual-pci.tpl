<!-- START of: Search/list-dual-pci.tpl -->

{js filename="openurl.js"}
{if $showPreviews}
{js filename="preview.js"}
{/if}

{include file="Search/openurl_autocheck.tpl"}

<div class="resultHeader">
  <h3>{if $recordCount}<a href="{$more|escape}">{translate text="Articles, e-Books etc."}</a>{else}{translate text="Articles, e-Books etc."}{/if}</h3>
  <i>{translate text="pci_results_description"}</i><br/><br/>
  {if $recordCount}
  <div class="well well-small resultViewOptions clearfix">
    <div class="resultNumbers pull-left">
      <span class="currentPage"><span class="badge">{translate text="Search Results"}</span> <strong>{$recordStart}&#8201;-&#8201;{$recordEnd} / </strong></span>
      <span class="resultTotals">{$recordCount}</span>
    </div>
    <div class="resultOptions pull-right">
      {if $recordCount}<a href="{$more|escape}">{translate text="More Results"} &raquo;</a>{/if}
    </div>
  </div>
  {else}
    <div class="resultViewOptions noResultHeader clearfix">
      <div class="resultNumbers">
        {translate text="nohit_heading"}
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

<!-- END of: Search/list-dual-pci.tpl -->
