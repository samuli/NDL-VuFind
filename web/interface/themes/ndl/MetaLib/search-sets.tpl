<h3 class="metalibSearchSets grid_5">{translate text='Searchsets'}{if in_array('metalibSets', $contextHelp)}
 <span id="contextHelp_metalibSets" class="showHelp">{translate text="Help"}</span>
{/if}</h3>
  <form id="searchSets">
  {foreach from=$metalibSearchSets item=searchDesc key=searchVal name=loop}
    <input id="set_{$smarty.foreach.loop.iteration}" name="searchSet" type="radio" value="{$searchVal}"{if $searchSet == $searchVal || (!$searchSet && $smarty.foreach.loop.first)} checked="checked"{/if} /> <label for="set_{$smarty.foreach.loop.iteration}"><span></span>{translate text=$searchDesc}</label><br>
  {/foreach}
  </form>
