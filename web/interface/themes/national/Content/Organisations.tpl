<!-- START of: Content/Organisations.fi.tpl -->

{assign var="title" value="organisations_topic"|translate"}
{capture append="sections"}

<p class="grid_18">{translate text="organisations_text"}</p>
<div class="grid_24 organisations">
<table class="organisationsTable">
<tr class="tableHeaders">
<td>{translate text="Archive_plural"} ({$cnt.arc})</td>
<td>{translate text="Library_plural"} ({$cnt.lib})</td>
<td>{translate text="Museum_plural"} ({$cnt.mus})</td>
</tr>
<tr>
<td  width="33%">
<ul class="organisations">
  {foreach from=$organisations.arc item=i}
  <li><div class="name">{$i[0]}</div><div class="link"><a title="{translate text="Find"}: {$i[0]}" href="{$i[1]}"></a></div></li>
  {/foreach}
</ul>
</td>
<td width="33%">
<ul class="organisations">
  {foreach from=$organisations.lib item=i}
  <li><div class="name">{$i[0]}</div><div class="link"><a title="{translate text="Find"}: {$i[0]}" href="{$i[1]}"></a></div></li>
  {/foreach}
</ul>
</td>
<td width="33%">
<ul class="organisations">
  {foreach from=$organisations.mus item=i}
  <li><div class="name">{$i[0]}</div><div class="link"><a title="{translate text="Find"}: {$i[0]}" href="{$i[1]}"></a></div></li> 
  {/foreach}
</ul>
</td>
</tr>
</table>

</div>

{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/Organisations.fi.tpl -->
