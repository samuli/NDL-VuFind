<!-- START of: Collection/browse.tpl -->

{capture name=pagelinks}
  <div class="alphaBrowsePageLinks">
    {if isset ($prevpage)}
      <div class="alphaBrowsePrevLink"><a href="{$path}/Collection/Home?source={$source|escape:"url"}&amp;from={$from|escape:"url"}&amp;page={$prevpage|escape:"url"}{if $filtersString}{$filtersString}{/if}">&laquo; Prev</a></div>
    {/if}

    {if isset ($nextpage)}
      <div class="alphaBrowseNextLink"><a href="{$path}/Collection/Home?source={$source|escape:"url"}&amp;from={$from|escape:"url"}&amp;page={$nextpage|escape:"url"}{if $filtersString}{$filtersString}{/if}">Next &raquo;</a></div>
    {/if}
    <div class="clear"></div>
  </div>
{/capture}
{if $filterList}
    <strong>{translate text='Remove Filters'}</strong>
    <ul class="filters">
    {foreach from=$filterList item=filters key=field}
      {foreach from=$filters item=filter}
        <li>
          <a href="{$filter.removalUrl|escape}"><img src="{$path}/images/silk/delete.png" alt="Delete"/></a>
          <a href="{$filter.removalUrl|escape}">{$filter.display|escape}</a>
        </li>
      {/foreach}
    {/foreach}
    </ul>
{/if}
<div class="browseAlphabetSelector">
  {foreach from=$letters item=letter}
   <div class="browseAlphabetSelectorItem"><a href="{$path}/Collection/Home?from={$letter}{if $filtersString}{$filtersString}{/if}">{$letter}</a></div>
  {/foreach}
</div>

<div class="browseJumpTo">
<form method="GET" action="{$path}/Collection/Home" class="browseForm">
  <input class="btn btn-info" type="submit" value="{translate text='Jump to'}" />
  <input type="text" name="from" value="{$from|escape:"html"}" />
</form>
</div>

<div class="clearfix"></div>

<h3>{translate text="Collection Browse"}</h3>

<div class="collectionBrowseResult">
  {$smarty.capture.pagelinks}
  	{include file=$browseView}
  <div class="clearfix"></div>
  {$smarty.capture.pagelinks}
</div>

<!-- END of: Collection/browse.tpl -->
