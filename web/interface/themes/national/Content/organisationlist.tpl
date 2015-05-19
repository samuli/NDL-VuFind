<!-- START of: Content/organisationlist.tpl -->

<div class="grid_24">
<h2>{translate text="organisations_topic"}</h2>
</div>
<div class="grid_24 bodytextwrapper"><p>{translate text="organisations_text"}</p></div>
<div class="grid_24 grid_24_inner organisationContainer">
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

<!-- END of: Content/organisationlist.tpl -->
