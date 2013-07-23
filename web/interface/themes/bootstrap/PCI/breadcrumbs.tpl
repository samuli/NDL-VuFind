<!-- START of: PCI/breadcrumbs.tpl -->
{*
<a href="{if $lastsearch}{$lastsearch|escape}{else}{$url}/PCI/Search{/if}">{translate text="Search"}{if $lookfor}: {$lookfor|escape}{/if}</a> 
<span>&gt;</span>
{if $id}
<em>{$record.Title.0|escape}</em>
{/if}
*}
{if $dualResultsEnabled}
  {assign var='searchName' value='Search'}
{else}
  {assign var='searchName' value='PCI Search'}
{/if}
{if $searchId}
  <a href="{if $lastsearch}{$lastsearch|escape}{else}{$url}/PCI/Search{/if}">{translate text=$searchName}{if $lookfor}: {$lookfor|escape:"html"}{/if}
{elseif $record}
  {if $lastsearch}
  <a href="{$lastsearch|escape}#record{$id|escape:"url"}">{translate text=$searchName}{if $lastsearchdisplayquery}: {$lastsearchdisplayquery|truncate:20:'...':FALSE|escape:"html"}{/if}</a>
  <span>&gt;</span>
  {/if}
<em>{$record.title|truncate:30:"..."|escape}</em>
{elseif $pageTemplate!=""}
 <em>{translate text="PCI Search"}: {translate text=$pageTemplate|replace:'.tpl':''|capitalize|translate}</em>
{/if}

<!-- END of: PCI/breadcrumbs.tpl -->
