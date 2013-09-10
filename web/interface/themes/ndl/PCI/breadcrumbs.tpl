<!-- START of: PCI/breadcrumbs.tpl -->

{if $dualResultsEnabled}
  {assign var='searchName' value='Search'}
{else}
  {assign var='searchName' value='PCI Search'}
{/if} 
{if $searchId}
<em>
  {translate text=$searchName}{if $lookfor}: {$lookfor|escape:"html"}{/if}</em>
{elseif $record}
  {if $lastsearch}
  <a href="{$lastsearch|escape}#record{$id|escape:"url"}">{translate text=$searchName}{if $lastsearchdisplayquery}: {$lastsearchdisplayquery|truncate:20:'...':FALSE|escape:"html"}{/if}</a>
  <span>&gt;</span>
  {/if}
<span class="iconlabel format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""} format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""}"></span>  
<em>{$record.title|truncate:30:"..."|escape}</em>
{elseif $pageTemplate!=""}
<em>{translate text=$pageTemplate|replace:'.tpl':''|capitalize|translate}</em>
{/if}

<!-- END of: PCI/breadcrumbs.tpl -->
