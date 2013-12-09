<!-- START of: Collection/breadcrumbs.tpl -->

{if $lastsearch}
<a href="{$lastsearch|escape}#record{$id|escape:"url"}">{translate text="Search"}{if $lastsearchdisplayquery}: {$lastsearchdisplayquery|truncate:20:'...':FALSE|escape:"html"}{/if}</a> <span>&gt;</span>
{/if} 
{if $breadcrumbText}
<em>{$breadcrumbText|truncate:30:"..."|escape}</em> <span>&gt;</span>
{/if}
{if $subpage!=""}
<em>{$subpage|replace:'view-':''|replace:'.tpl':''|replace:'Collection/':''|capitalize|replace:'HierarchyTree_JSTree':'hierarchy_tree'|translate}</em>
{/if}

<!-- END of: Collection/breadcrumbs.tpl -->
