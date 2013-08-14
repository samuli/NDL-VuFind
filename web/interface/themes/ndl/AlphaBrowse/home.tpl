{capture name=pagelinks}
  <div class="alphaBrowsePageLinks">
    <div class="content">
      <div class="pagination{if $position} pagination{$position}{/if}">
        <span class="paginationMove paginationBack {if isset ($prevRowid)}visible{/if}">
          {if isset ($prevRowid)}<a href="{$path}/AlphaBrowse/Results?source={$source|escape:"url"}&amp;from={$from|escape:"url"}&amp;rowid={$prevRowid}&amp;page=-1">&laquo; {translate text="Prev"}</a>{/if}
          <span>&#9668;</span>
        </span>
        {if $result}
          {foreach from=$result.Browse.items item=item name=firstlast}
            {if $smarty.foreach.firstlast.first}{$item.heading|truncate:30:"&hellip;"} &ndash; {/if}{if $smarty.foreach.firstlast.last}{$item.heading|truncate:30:"&hellip;"}{/if}
          {/foreach}
        {/if}
        <span class="paginationMove paginationNext {if isset ($nextRowid)}visible{/if}">
          {if isset ($nextRowid)}<a href="{$path}/AlphaBrowse/Results?source={$source|escape:"url"}&amp;from={$from|escape:"url"}&amp;rowid={$nextRowid}">{translate text="Next"} &raquo;</a>{/if}
          <span>&#9654;</span>
        </span>
      </div>
    </div>
  </div>    
{/capture}

<div class="browseHeader">
  <div class="content"><h1>{translate text='Browse Alphabetically'}</h1></div>
</div>

<div class="content">
  <div class="resulthead">
    <form method="get" action="{$path}/AlphaBrowse/Results" name="alphaBrowseForm" id="alphaBrowseForm">
      <label for="alphaBrowseForm_source">{translate text='Browse Alphabetically'}</label>
      <select id="alphaBrowseForm_source" name="source" class="styledDropdowns">
        {foreach from=$alphaBrowseTypes key=key item=item}
          <option value="{$key|escape}" {if $source == $key}selected="selected"{/if}>{translate text=$item}</option>
        {/foreach}
      </select>
      <label for="alphaBrowseForm_from">{translate text='starting from'}</label>
      <input type="text" name="from" id="alphaBrowseForm_from" value="{$from|escape}"/>
      <input class="button buttonFinna" type="submit" value="{translate text='Browse'}"/>
    </form>
  </div>

  {if $result}
    <div class="alphaBrowseResult">
    <div class="alphaBrowseHeader">{translate text="alphabrowse_matches"}</div>
      {foreach from=$result.Browse.items item=item name=recordLoop}
      <div class="alphaBrowseEntry {if ($smarty.foreach.recordLoop.iteration % 2) == 0}alt {/if}">
      <div class="alphaBrowseHeading">
        {if $item.count > 0}
        {capture name="searchLink"}
          {* linking using bib ids is generally more reliable than
           doing searches for headings, but headings give shorter
           queries and don't look as strange. *}
          {if $item.count < 5}
          {$path}/Search/Results?type=ids&amp;lookfor={foreach from=$item.ids item=id}{$id}+{/foreach}
          {else}
          {$path}/Search/Results?type={$source|capitalize|escape:"url"}Browse&amp;lookfor={$item.heading|escape:"url"}
          {/if}
        {/capture}
        <a href="{$smarty.capture.searchLink|trim}">{$item.heading|escape:"html"}</a>
        {else}
        {$item.heading|escape:"html"}
        {/if}
      </div>
      <div class="alphaBrowseCount">{if $item.count > 0}{$item.count}{/if}</div>
      <div class="clear"></div>

      {if $item.useInstead|@count > 0}
        <div class="alphaBrowseRelatedHeading">
        <div class="title">{translate text="Use instead"}:</div>
        <ul>
          {foreach from=$item.useInstead item=heading}
          <li><a href="{$path}/AlphaBrowse/Results?source={$source|escape:"url"}&amp;from={$heading|escape:"url"}">{$heading|escape:"html"}</a></li>
          {/foreach}
        </ul>
        </div>
      {/if}

      {if $item.seeAlso|@count > 0}
        <div class="alphaBrowseRelatedHeading">
        <div class="title">{translate text="See also"}:</div>
        <ul>
          {foreach from=$item.seeAlso item=heading}
          <li><a href="{$path}/AlphaBrowse/Results?source={$source|escape:"url"}&amp;from={$heading|escape:"url"}">{$heading|escape:"html"}</a></li>
          {/foreach}
        </ul>
        </div>
      {/if}

      {if $item.note}
        <div class="alphaBrowseRelatedHeading">
        <div class="title">{translate text="Note"}:</div>
        <ul>
          <li>{$item.note|escape:"html"}</li>
        </ul>
        </div>
      {/if}

      </div>
      {/foreach}

    </div>
  {/if}
</div>

{if $result}
  {$smarty.capture.pagelinks}
{/if}

  <div class="span-5 {if $sidebarOnLeft}pull-18 sidebarOnLeft{else}last{/if}">
</div>

<div class="clear"></div>
