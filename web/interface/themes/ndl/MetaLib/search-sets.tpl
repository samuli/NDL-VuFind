<h3 class="metalibSearchSets grid_5">{translate text='Searchsets'}{if in_array('metalibSets', $contextHelp)}
  <span id="contextHelp_metalibSets" class="showHelp">{translate text="Help"}</span>
{/if}</h3>
  
  <form class="searchSets">
    {assign var="cnt" value=0}
    {foreach from=$metalibSearchSets item=searchDesc key=searchVal name=loop}
    <input id="set_{$cnt}" name="searchSet" type="radio" value="{$searchVal}"{if $searchSet == $searchVal} checked="checked"{/if} /> <label for="set_{$cnt++}"><span></span>{translate text=$searchDesc}</label><br>
   {/foreach}
    
    <div id="recentMetalibDatabases" class="truncateField">
      {if $metalibRecentDatabases}
        <p>{translate text='Recently Used Databases'}</p>
      
        <div class="clear"></div>
      
        <div>
          {foreach from=$metalibRecentDatabases item=searchDesc key=searchVal name=loop}
          <input id="set_{$cnt}" name="searchSet" type="radio" value="{$searchVal}"{if $searchSet == $searchVal} checked="checked"{/if} /> <label for="set_{$cnt++}"><span></span>{translate text=$searchDesc}</label><br>
        {/foreach}
        </div>      
      {/if}
        

    </div>

    <div id="browseLink"><a href="{$browseDatabases}">{translate text="browse_extended_Database"}</a></div>

  </form>