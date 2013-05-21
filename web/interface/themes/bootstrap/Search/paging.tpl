{if $recordCount > 0}
  <div class="pagination{if $position}{$position}{/if}{if !$position} pagination-centered{/if}">
    <ul class="{if $position}pager{/if}" style="margin:0;">
    {if $position}<li>&nbsp;{$recordStart}-{$recordEnd}&nbsp;<strong>/</strong>&nbsp;{$recordCount}&nbsp;</li>{/if}
    {if $recordCount > 20}
    <li class="{if !$position}previous{/if}{if !$pageLinks.back} disabled{/if}">{if $pageLinks.back}{$pageLinks.back}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.prevImg}</span>{/if}</li>
    {if !$position}<li>{$pageLinks.pages}</li>{/if}
    <li class="{if !$position}next{/if}{if !$pageLinks.next} disabled{/if}">{if $pageLinks.next}{$pageLinks.next}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.nextImg}</span>{/if}</li>
    {/if}
    </ul>
  </div>
{/if}
