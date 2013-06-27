<!-- START of: Record/view-alt.tpl -->

<div class="record">
  <a href="{$url}/Record/{$id|escape:"url"}/Home" class="backtosearch">&laquo; {translate text="Back to Record"}</a>

  {if $shortTitle}<h1>{$shortTitle}</h1>{/if}
  {include file="Record/$subTemplate"}
</div>

<!-- END of: Record/view-alt.tpl -->
