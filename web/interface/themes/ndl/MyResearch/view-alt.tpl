<!-- START of: MyResearch/view-alt.tpl -->

<div class="record">
  {if !empty($recordId)}
    <a href="{$url}/Record/{$recordId|escape:"url"}/Home" class="backtosearch">&laquo; {translate text="Back to Record"}</a>
  {/if}

  {if $pageTitle}
  <div class="myresearchHeader">
    <div class="content">
      <div class="grid_24"><h1>{$pageTitle}</h1></div>
    </div>
  </div>
  {/if}
  <div class="content">
  {include file="MyResearch/$subTemplate"}
  </div>
</div>

<!-- END of: MyResearch/view-alt.tpl -->
