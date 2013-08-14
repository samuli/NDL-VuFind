<!-- START of: Browse/lcc.tpl -->

<div id="list1container" class="span3 browseNav">
  {include file="Browse/top_list.tpl" currentAction="LCC"}
</div>

<div id="list2container" class="span3 browseNav">
  <ul class="browse" id="list2">
  {foreach from=$defaultList item=area}
    <li><a href="{$url}/Browse/LCC" title="&quot;{$area.0|escape}&quot;" class="btn loadOptions query_field:callnumber-first facet_field:callnumber-subject target:list3container">{$area.0|escape} ({$area.1})</a></li>
  {/foreach}  
  </ul>
</div>

<div id="list3container" class="span3"></div>

<div id="list4container" class="span3"></div>

{*
<div class="clear"></div>
*}

<!-- END of: Browse/lcc.tpl -->
