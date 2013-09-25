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
            $(this).toggleClass('hover');
            var gridContent = $(this).find('.gridContent');
            var h = '', o = 52;
            if ($(this).hasClass('hover')) {
                h = gridContent[0].scrollHeight -1;
                if (h <= 54) {
                    return;
                }
            } 
            gridContent.css('height', h); // If h=='', reset element height
        });
    });
    {/literal}
  </script>
<!-- END of: Search/list-grid.tpl -->
