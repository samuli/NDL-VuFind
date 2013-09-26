{php}
/*
 * calculate the total page count in order to output it after the list of pages,
 * e.g. "1 2 3 4 5 / 24648"
 */

$pageCount = 0;
$vars = $this->get_template_vars('pageLinks');
if (array_key_exists('pagerOptions', $vars) && array_key_exists('perPage', $vars['pagerOptions'])) {
   $recordCount = $this->get_template_vars('recordCount');
   $perPage = $vars['pagerOptions']['perPage'];
   $pageCount = floor($recordCount / $perPage);
   if ($recordCount%$perPage > 0) {
      $pageCount++; 
   }
}

$this->assign('pageCount', $pageCount);
{/php}

{if $recordCount > 0}
  {if !empty($pageLinks.pages)} 
  <div class="resultPagination{if $position} resultPagination{$position}{if $sidebarOnLeft} sidebarOnLeft{/if}{/if}">
    <div class="content">
      <div class="pagination{if $position} pagination{$position}{/if}">
        <span class="paginationMove paginationFirst {if !empty($pageLinks.first)}visible{/if}">{$pageLinks.first}<span>&#9668;&#9668;</span></span>
        <span class="paginationMove paginationBack {if !empty($pageLinks.back)}visible{/if}">{$pageLinks.back}<span>&#9668;</span></span>
        <span class="paginationPages">{$pageLinks.pages}</span>
        / <span class="paginationPages">{$pageCount|number_format:0:".":" "|replace:" ":"&#x2006;"}</span>
        <span class="paginationMove paginationNext {if !empty($pageLinks.next)}visible{/if}">{$pageLinks.next}<span>&#9654;</span></span>
        <span class="paginationMove paginationLast {if !empty($pageLinks.last)}visible{/if}">{$pageLinks.last}<span>&#9654;&#9654;</span></span>
      </div>
    </div>
  </div>
  {/if}
{/if}
