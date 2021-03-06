<div class="browseHeader"><div class="content"><h1>{translate text='Choose a Column to Begin Browsing'}:</h1></div></div>
<div class="content">
<div class="grid_24 browseNav">
  {include file="Browse/top_list.tpl" currentAction="Topic"}
</div>

<div class="grid_24 browseNav" id="list2container">
  <ul class="browse" id="list2">
    <li><a href="{$url}/Browse/Topic" class="loadAlphabet query_field:topic_facet facet_field:topic_facet target:list3container">{translate text="By Alphabetical"}</a></li>
    {if $genreEnabled}<li><a href="{$url}/Browse/Topic" class="loadSubjects query_field:topic_facet facet_field:genre_facet target:list3container">{translate text="By Genre"}</a></li>{/if}
    {if $regionEnabled}<li><a href="{$url}/Browse/Topic" class="loadSubjects query_field:topic_facet facet_field:geographic_facet target:list3container">{translate text="By Region"}</a></li>{/if}
    {if $eraEnabled}<li><a href="{$url}/Browse/Topic" class="loadSubjects query_field:topic_facet facet_field:era_facet target:list3container">{translate text="By Era"}</a></li>{/if}
  </ul>
</div>

<div id="list3container" class="grid_12">
</div>

<div id="list4container" class="grid_12">
</div>

<div class="clear"></div>
</div>