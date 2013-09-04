<!-- START of: Search/list-grid.tpl -->

{js filename="check_item_statuses.js"}
{js filename="check_save_statuses.js"}
{if $showPreviews}
{js filename="preview.js"}
{/if}

  <ul class="recordSet galleryView">
  {foreach from=$recordSet item=record name="recordLoop"}
    <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
      {$record}
    </li>
  {/foreach}
  </ul>
  <script type="text/javascript">
    {literal}
    $(function() {
        $('.galleryView li.result').hover(function() {
            var gridContent = $(this).find('.gridContent');
            var h, o = 52;
            
            gridContent.toggleClass('visible');
            if (gridContent.hasClass('visible')) {
                h = gridContent[0].scrollHeight -1;
                if (h <= 54) {
                    return;
                }
            } else {
                h = o;
            }
            gridContent.animate({
                'height' : h
            }, 50);
        });
    });
    {/literal}
  </script>
<!-- END of: Search/list-grid.tpl -->
