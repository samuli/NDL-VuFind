<!-- START of: Content/Organisations.fi.tpl -->

{assign var="title" value="organisations_topic"|translate"}
{capture append="sections"}

<p class="grid_18">{translate text="organisations_text"}</p>
<div class="grid_24 organisationContainer">
<div class="grid_8 organisationWrapper">
<h4> {translate text="Archive_plural"} ({$cnt.arc})</h4>
<ul class="organisations">
  {foreach from=$organisations.arc item=i}
  <li><div class="name">{$i[0]}</div><div class="link"><a title="{translate text="Find"}: {$i[0]}" href="{$i[1]}"></a></div></li>
  {/foreach}
</ul>
</div>
<div class="grid_8 organisationWrapper">
 <h4> {translate text="Library_plural"} ({$cnt.lib})</h4>
<ul class="organisations">
{foreach from=$organisations.lib item=i}
  <li><div class="name">{$i[0]}</div><div class="link"><a title="{translate text="Find"}: {$i[0]}" href="{$i[1]}"></a></div></li>
  {/foreach}
</ul>
</div>
<div class="grid_8 organisationWrapper">
<h4> {translate text="Museum_plural"} ({$cnt.mus})</h4>
<ul class="organisations">
  {foreach from=$organisations.mus item=i}
  <li><div class="name">{$i[0]}</div><div class="link"><a title="{translate text="Find"}: {$i[0]}" href="{$i[1]}"></a></div></li> 
  {/foreach}
</ul>
</div>
</div>

{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/Organisations.fi.tpl -->
