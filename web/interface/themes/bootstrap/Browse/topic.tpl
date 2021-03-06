<!-- START of: Browse/topic.tpl -->

<div class="span3 browseNav">
  {include file="Browse/top_list.tpl" currentAction="Topic"}
</div>

<div class="span3 browseNav">
  <ul class="browse" id="list2">
    <li><a href="{$url}/Browse/Topic" class="btn loadAlphabet query_field:topic_facet facet_field:topic_facet target:list3container">{translate text="By Alphabetical"}</a></li>
    {if $genreEnabled}<li><a href="{$url}/Browse/Topic" class="btn loadSubjects query_field:topic_facet facet_field:genre_facet target:list3container">{translate text="By Genre"}</a></li>{/if}
    {if $regionEnabled}<li><a href="{$url}/Browse/Topic" class="btn loadSubjects query_field:topic_facet facet_field:geographic_facet target:list3container">{translate text="By Region"}</a></li>{/if}
    {if $eraEnabled}<li><a href="{$url}/Browse/Topic" class="btn loadSubjects query_field:topic_facet facet_field:era_facet target:list3container">{translate text="By Era"}</a></li>{/if}
  </ul>
</div>

<div id="list3container" class="span3">
</div>

<div id="list4container" class="span3">
</div>

{*
<div class="clear"></div>
*}

<!-- END of: Browse/topic.tpl -->
