<!-- START of: MyResearch/view-alt.tpl -->

<div class="record">
  {if !empty($recordId)}
    <a href="{$url}/Record/{$recordId|escape:"url"}/Home" class="backtosearch">&laquo; {translate text="Back to Record"}</a>
  {/if}

  {if $shortTitle}<h1>{$shortTitle}</h1>{/if}
  {include file="MyResearch/$subTemplate"}
</div>

<!-- END of: MyResearch/view-alt.tpl -->
