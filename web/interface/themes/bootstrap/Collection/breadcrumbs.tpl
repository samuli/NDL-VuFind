<!-- START of: Collection/breadcrumbs.tpl -->

<a href="{$url}/Collection/Home">{translate text="Collections"}</a>&nbsp;<span class="divider">/</span>
{if $breadcrumbText}
<em>{$breadcrumbText|truncate:30:"..."|escape}</em>&nbsp;<span class="divider">/</span>
{/if}
{if $subpage!=""}
<em>{$subpage|replace:'view-':''|replace:'.tpl':''|replace:'Collection/':''|capitalize|replace:'HierarchyTree_JSTree':'hierarchy_tree'|translate}</em>
{/if}

<!-- END of: Collection/breadcrumbs.tpl -->
