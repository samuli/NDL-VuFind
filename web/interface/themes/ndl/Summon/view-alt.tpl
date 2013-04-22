<!-- START of: Summon/view-alt.tpl -->

<div class="record">
  <a href="{$url}/Summon/Record?id={$id|escape:"url"}" class="backtosearch">&laquo; {translate text="Back to Record"}</a>

  {if $shortTitle}<h1>{$shortTitle}</h1>{/if}
  {include file="Summon/$subTemplate"}
</div>

<!-- END of: Summon/view-alt.tpl -->