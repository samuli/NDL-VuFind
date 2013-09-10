<!-- START of: Record/breadcrumbs.tpl -->

{if $lastsearch}
  {if $lastsearch|strstr:'Search/NewItem'}
<a href="{$lastsearch|escape}#record{$id|escape:"url"}">{translate text="New Items"}</a>
  {else}
<a href="{$lastsearch|escape}#record{$id|escape:"url"}">{translate text="Search"}{if $lastsearchdisplayquery}: {$lastsearchdisplayquery|truncate:20:'...':FALSE|escape:"html"}{/if}</a>
  {/if}
{/if}
<span>&gt;</span>
{if $breadcrumbText}
  {if is_array($recordFormat)}
    {assign var=mainFormat value=$recordFormat.0} 
    {assign var=displayFormat value=$recordFormat|@end} 
  {else}
    {assign var=mainFormat value=$recordFormat} 
    {assign var=displayFormat value=$recordFormat} 
  {/if}
<span class="iconlabel format{$mainFormat|lower|regex_replace:"/[^a-z0-9]/":""} format{$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}"></span><em>{$breadcrumbText|truncate:30:"..."|escape}</em> 
{/if}
{if $subTemplate && !$dynamicTabs}
<span>&gt;</span><em>{$subTemplate|replace:'view-':''|replace:'.tpl':''|replace:'../MyResearch/':''|capitalize|translate}</em> 
{/if}

<!-- END of: Record/breadcrumbs.tpl -->
