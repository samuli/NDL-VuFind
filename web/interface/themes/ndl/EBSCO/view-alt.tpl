<div class="record">
  <a href="{$url}/EBSCO/Record?id={$id|escape:"url"}" class="backtosearch">&laquo; {translate text="Back to Record"}</a>

  {if $shortTitle}<h1>{$shortTitle}</h1>{/if}
  {include file="EBSCO/$subTemplate"}
</div>
