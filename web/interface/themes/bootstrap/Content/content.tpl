<!-- START of: Content/content.tpl -->

<div class="contentHeader">
  <div class="content">
    <div><h1>{$title}</h1></div>
  </div>
</div>
{if $menu}
<div class="menu"></div>
{/if}
<div class="sections">
{foreach from=$sections item=section name=section}
  <div class="contentSection {if $smarty.foreach.section.index is odd}odd{/if}">
    <div class="content"><div class="grid_17 {if $menu}prefix_7{/if}">{$section}</div>
    </div>
  </div>
{/foreach}
</div>

<!-- END of: Content/content.tpl -->
