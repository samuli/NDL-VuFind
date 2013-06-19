<!-- START of: MyResearch/breadcrumbs.tpl -->

<a href="{$url}/MyResearch/Home">{translate text='Your Account'}</a>&nbsp;<span class="divider">/</span>
{if $pageTemplate == 'view-alt.tpl'}
<em>{$shortTitle}</em>
{else}
<em>{$pageTemplate|replace:'.tpl':''|capitalize|translate}</em>
{/if}

<!-- END of: MyResearch/breadcrumbs.tpl -->
