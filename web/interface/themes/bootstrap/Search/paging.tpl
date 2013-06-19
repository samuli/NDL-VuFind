{if $recordCount > 0}
  <div class="row-fluid hidden-phone pagination{if $position}{$position}{else} pagination-centered pagination{/if}">
  {if $position}
    <div class="span12{if ($module != 'MyResearch')} well well-small{/if}">
  {else}
    <div class="recordCount">
      <strong>{translate text="Search Results"}:<br />
      {$recordStart}-{$recordEnd}&nbsp;/&nbsp;{$recordCount}</strong>
    </div>
  {/if}
    <ul class="{if $position}pager pull-left{/if}" style="margin:0;">
      <li class="paginationMove paginationFirst{if $position} offscreen{/if}{if empty($pageLinks.first)} disabled"><a href="" title="first page"></a>{else}">{$pageLinks.first}{/if}</li>
      <li class="{if !$position}previous{/if}{if !$pageLinks.back} disabled{/if}">{if $pageLinks.back}{$pageLinks.back}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.prevImg}</span>{/if}</li>
      {if !$position}
        <li>{$pageLinks.pages}</li>
      {else}
        <li>&nbsp;<strong>{if ($module != 'MyResearch')}{translate text="Search Results"}:&nbsp;&nbsp;{/if}{$recordStart}-{$recordEnd}</strong>&nbsp;/&nbsp;{$recordCount}&nbsp;</li>
      {/if}
      <li class="{if !$position}next{/if}{if !$pageLinks.next} disabled{/if}">{if $pageLinks.next}{$pageLinks.next}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.nextImg}</span>{/if}</li>
      <li class="paginationMove paginationLast{if $position} offscreen{/if}{if empty($pageLinks.last)} disabled"><a href="" title="last page"></a>{else}">{$pageLinks.last}{/if}</li>
    </ul>

  {if ($module != 'MetaLib') && ($module != 'MyResearch') && ($position == 'Top')} 
    <ul class="pull-right listResultSelect inline">
      <li>
        <div class="limitSelect pull-left"> 
          {if $limitList|@count gt 1}
            <form class="form-inline" action="{$path}/Search/LimitResults" method="post">
              <label for="limit">{translate text='Results per page'}</label>
              <select id="limit" name="limit" class="selectpicker" data-style="btn-mini" onChange="document.location.href = this.options[this.selectedIndex].value;">
                {foreach from=$limitList item=limitData key=limitLabel}
                  <option value="{$limitData.limitUrl|escape}"{if $limitData.selected} selected="selected"{/if}>{$limitData.desc|escape}</option>
                {/foreach}
              </select>
              <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
            </form>
          {/if}
        </div>
      </li>
      <li>
        <div class="viewButtons">
        {if $viewList|@count gt 1}
          {foreach from=$viewList item=viewData key=viewLabel}
            {if !$viewData.selected}<a href="{$viewData.viewUrl|escape}" title="{translate text='Switch view to'} {translate text=$viewData.desc}" >{/if}<img src="{$path}/images/view_{$viewData.viewType}.png" {if $viewData.selected}title="{translate text=$viewData.desc} {translate text="view already selected"}"{/if}/>{if !$viewData.selected}</a>{/if}
          {/foreach}
        {/if}
        </div>
      </li>
      <li>
        <div class="sortSelect pull-left">
          <form class="form-inline" action="{$path}/Search/SortResults" method="post">
            <label for="sort_options_1">{translate text='Sort'}</label>
            <select id="sort_options_1" name="sort" class="jumpMenu selectpicker" data-style="btn-mini">
            {foreach from=$sortList item=sortData key=sortLabel}
              <option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
            {/foreach}
            </select>
            <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
          </form>
        </div>
      </li>
    </ul>
  {/if}

  {if $position}
    </div>
  {/if}
  </div>


 {* Smaller paging for mobile-phones *}
  <div class="span12 visible-phone pagination{if $position}{$position} well well-small{else} pagination-centered pagination-small{/if}">
  {if $position}
    <div class="row-fluid">
  {else}
    <div class="recordCount">
      {translate text="Search Results"}:<br />
      <strong>{$recordStart}-{$recordEnd}&nbsp;<strong>/</strong>&nbsp;{$recordCount}</strong>
    </div>
  {/if}
    <ul class="{if $position}pager{if $module != 'MetaLib'} pull-left{/if}{/if}" style="margin:0;">
      <li class="paginationMove paginationFirst{if $position} offscreen{/if}{if empty($pageLinks.first)} disabled"><a href="" title="first page"></a>{else}">{$pageLinks.first}{/if}</li>
      <li class="{if !$position}previous{/if}{if !$pageLinks.back} disabled{/if}">{if $pageLinks.back}{$pageLinks.back}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.prevImg}</span>{/if}</li>
      {if !$position}
        <li>{$pageLinks.pages}</li>
      {else}
        <li>&nbsp;<strong>{$recordStart}-{$recordEnd}</strong>&nbsp;/&nbsp;{$recordCount}&nbsp;</li>
      {/if}
      <li class="{if !$position}next{/if}{if !$pageLinks.next} disabled{/if}">{if $pageLinks.next}{$pageLinks.next}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.nextImg}</span>{/if}</li>
      <li class="paginationMove paginationLast{if $position} offscreen{/if}{if empty($pageLinks.last)} disabled"><a href="" title="last page"></a>{else}">{$pageLinks.last}{/if}</li>
    </ul>

  {if ($module != 'MetaLib') && ($position == 'Top')} 
    <ul class="pull-right listResultSelect inline">
      <li>
        <div class="limitSelect pull-left"> 
          {if $limitList|@count gt 1}
            <form class="form-inline" action="{$path}/Search/LimitResults" method="post">
              <label for="limit">{translate text='Results per page'}</label>
              <select id="limit" name="limit" class="selectpicker" data-style="btn-mini" onChange="document.location.href = this.options[this.selectedIndex].value;">
                {foreach from=$limitList item=limitData key=limitLabel}
                  <option value="{$limitData.limitUrl|escape}"{if $limitData.selected} selected="selected"{/if}>{$limitData.desc|escape}</option>
                {/foreach}
              </select>
              <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
            </form>
          {/if}
        </div>
      </li>
      <li>
        <div class="viewButtons">
        {if $viewList|@count gt 1}
          {foreach from=$viewList item=viewData key=viewLabel}
            {if !$viewData.selected}<a href="{$viewData.viewUrl|escape}" title="{translate text='Switch view to'} {translate text=$viewData.desc}" >{/if}<img src="{$path}/images/view_{$viewData.viewType}.png" {if $viewData.selected}title="{translate text=$viewData.desc} {translate text="view already selected"}"{/if}/>{if !$viewData.selected}</a>{/if}
          {/foreach}
        {/if}
        </div>
      </li>
      <li>
        <div class="sortSelect pull-left">
          <form class="form-inline" action="{$path}/Search/SortResults" method="post">
            <label for="sort_options_1">{translate text='Sort'}</label>
            <select id="sort_options_1" name="sort" class="jumpMenu selectpicker" data-style="btn-mini">
            {foreach from=$sortList item=sortData key=sortLabel}
              <option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
            {/foreach}
            </select>
            <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
          </form>
        </div>
      </li>
    </ul>
  {/if}

  {if $position}
    </div>
  {/if}
  </div>
  {* End smaller paging *}


{* Let's change the proper icons for first and last page links *}
  <script>
  {literal}
    $(document).ready(function() {
      $("a[title='first page']").empty().append('<i class="icon-fast-backward"></i>');
      $(".paginationFirst + li :first-child").empty().append('<i class="icon-step-backward"></i>');
      $(':first-child',$(".paginationLast").prev()).empty().append('<i class="icon-step-forward"></i>');
      $("a[title='last page']").empty().append('<i class="icon-fast-forward"></i>');
      $("a[title='page 5']").addClass("hidden-phone");
    });
  {/literal}
</script>

{/if}
