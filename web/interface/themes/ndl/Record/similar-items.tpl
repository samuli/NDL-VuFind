{assign var=levelOfCollapse value="3"}

<div class="sidegroup">
  <h4>{translate text="Similar Items"}</h4>
  {if is_array($similarRecords)}
  <ul class="similar">
    {assign var=title value="similar"}
    {foreach from=$similarRecords item=similar name="similarLoop"}
        {if $smarty.foreach.similarLoop.iteration == $levelOfCollapse && is_array($editions)}
          <li class="morelink" id="more{$title}"><a href="#" onclick="moreFacets('{$title}'); return false;">{translate text='more'}&hellip;</a></dd>
        </ul>
        <ul class="similar narrowList navmenu offscreen" id="narrowGroupHidden_{$title}">
        {/if}
    <li>
      {*{if is_array($similar.format)}
      <span class="icon format{$similar.format[0]|lower|regex_replace:"/[^a-z]/":""}">
      {else}
      <span class="icon format{$similar.format|lower|regex_replace:"/[^a-z]/":""}">
      {/if}*}
        <a href="{$url}/Record/{$similar.id|escape:"url"}" title="{$similar.title|escape}">{$similar.title|truncate:70:"..."|escape}</a>{if $similar.publishDate}&nbsp;{$similar.publishDate.0|escape}{elseif $similar.summYearRange}&nbsp;{$similar.summYearRange|escape}{/if}
        {if $similar.author}<div class="author">{$similar.author|escape}</div>{/if}
    </li>
    {/foreach}
    {if $smarty.foreach.similarLoop.total > ($levelOfCollapse - 1) && is_array($editions)}<li class="lesslink"><a href="#" onclick="lessFacets('{$title}'); return false;">{translate text='less'}&hellip;</a></li>{/if}
  </ul>
  {else}
    <p>{translate text='Cannot find similar records'}</p>
  {/if}
</div>

{if is_array($editions)}
<div class="sidegroup">
  <h4>{translate text="Other Editions"}</h4>
  <ul class="similar">
    {assign var=title value="edition"}
    {foreach from=$editions item=edition name="editionLoop"}
        {if $smarty.foreach.editionLoop.iteration == $levelOfCollapse && is_array($similarRecords)}
          <li class="morelink" id="more{$title}"><a href="#" onclick="moreFacets('{$title}'); return false;">{translate text='more'}&hellip;</a></dd>
        </ul>
        <ul class="similar narrowList navmenu offscreen" id="narrowGroupHidden_{$title}">
        {/if}
    <li>
      {*{if is_array($edition.format)}
        <span class="{$edition.format[0]|lower|regex_replace:"/[^a-z0-9]/":""}">
      {else}
        <span class="{$edition.format|lower|regex_replace:"/[^a-z0-9]/":""}">
      {/if}*}
      <a href="{$url}/Record/{$edition.id|escape:"url"}" title="{$edition.title|escape}">{$edition.title|truncate:70:"..."|escape}</a>
      {*</span>*}
      <br/>
      {$edition.edition|escape}
      {if $edition.publishDate}{$edition.publishDate.0|escape}{/if}
    </li>
    {/foreach}
    {if $smarty.foreach.editionLoop.total > ($levelOfCollapse - 1) && is_array($similarRecords)}<li class="lesslink"><a href="#" onclick="lessFacets('{$title}'); return false;">{translate text='less'}&hellip;</a></li>{/if}
  </ul>
</div>
{/if}
