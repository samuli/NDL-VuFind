{if $recordCount > 0}
  <div class="pagination{if $position}{$position}{/if}{if !$position} pagination-centered pagination-small{/if}">
  {if !$position}
    <div class="recordCount">
      {translate text="Search Results"}:<br />
      <strong>{$recordStart}-{$recordEnd}&nbsp;<strong>/</strong>&nbsp;{$recordCount}</strong>
    </div>
  {/if}
    <ul class="{if $position}pager{/if}" style="margin:0;">
    <li class="paginationMove paginationFirst{if empty($pageLinks.first)} disabled"><a href="" title="first page" style="opacity: .5; border-color: #bbbbbb;"></a>{else}">{$pageLinks.first}{/if}</li>
    {if $position}<li>&nbsp;{$recordStart}-{$recordEnd}&nbsp;<strong>/</strong>&nbsp;{$recordCount}&nbsp;</li>{/if}
    {if $recordCount > 20}
      <li class="{if !$position}previous{/if}{if !$pageLinks.back} disabled{/if}">{if $pageLinks.back}{$pageLinks.back}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.prevImg}</span>{/if}</li>
      {if !$position}<li>{$pageLinks.pages}</li>{/if}
      <li class="{if !$position}next{/if}{if !$pageLinks.next} disabled{/if}">{if $pageLinks.next}{$pageLinks.next}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.nextImg}</span>{/if}</li>
    {/if}
    <li class="paginationMove paginationLast {if empty($pageLinks.last)} disabled"><a href="" title="last page" style="opacity: .5; border-color: #bbbbbb;"></a>{else}">{$pageLinks.last}{/if}</li>
    </ul>
  </div>

{* Let's change the proper icons for first and last page links *}
  <script>
  {literal}
    $(document).ready(function() {
      $("a[title='last page']").empty().append('<i class="icon-fast-forward"></i>');
      $("a[title='first page']").empty().append('<i class="icon-fast-backward"></i>');
      $("li.previous").next().addClass("hidden-phone");
    });
  {/literal}
</script>

{/if}
