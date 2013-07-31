<div class="browseHeader"><div class="content"><h1>{translate text='Choose a Column to Begin Browsing'}:</h1></div></div>
<div class="content">
<div id="list1container" class="grid_24 browseNav">
  {include file="Browse/top_list.tpl" currentAction="LCC"}
</div>

<div id="list2container" class="grid_24 browseNav">
  <ul class="browse" id="list2">
  {foreach from=$defaultList item=area}
    <li><a href="{$url}/Browse/LCC" title="&quot;{$area.0|escape}&quot;" class="loadOptions query_field:callnumber-first facet_field:callnumber-subject target:list3container">{$area.0|escape} ({$area.1})</a></li>
  {/foreach}  
  </ul>
</div>

<div id="list3container" class="grid_12"></div>

<div id="list4container" class="grid_12"></div>

<div class="clear"></div>
</div>
