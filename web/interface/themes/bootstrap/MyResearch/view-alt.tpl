<!-- START of: MyResearch/view-alt.tpl -->

<div class="span12 well-small record">
  {if !empty($recordId)}
    <a href="{$url}/Record/{$recordId|escape:"url"}/Home" class="backtosearch">&laquo; {translate text="Back to Record"}</a>
  {/if}

  {if $shortTitle}<h3>{$shortTitle}</h3>{/if}
  {include file="MyResearch/$subTemplate"}
</div>

<!-- END of: MyResearch/view-alt.tpl -->
