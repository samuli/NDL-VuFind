<!-- START of: Record/view-componentparts.tpl -->

<div class="content">
<div class="grid_24">
{if $componentPartsTemplate}
  {* <h5 class="recordTabHeader">{translate text='Contents/Parts'}:</h5> *}
  {include file=$componentPartsTemplate}
{else}
  {translate text="Contents/Parts unavailable"}.
{/if}
</div>
</div>
<!-- END of: Record/view-componentparts.tpl -->
