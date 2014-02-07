<!-- START of: PCI/list-list.tpl -->

{js filename="openurl.js"}
{if $showPreviews}
{js filename="preview.js"}
{/if}
{if $metalibEnabled}
{js filename="metalib_links.js"}
{/if}
{include file="Search/rsi.tpl"}
{include file="Search/openurl_autocheck.tpl"}
{js filename="check_save_statuses.js"}
<ul class="recordSet">
{foreach from=$recordSet item=record name="recordLoop"}
{assign var="id" value=$record.id}
  <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
    <span class="recordNumber">{$recordStart+$smarty.foreach.recordLoop.iteration-1}</span>
    <div class="result recordId" id="record{$id|escape:"html"}">
      <div class="resultColumn1">
        <div class="coverDiv">

        {* Multiple images *}
        {if $img_count > 1}
          <div class="imagelinks">
        {foreach from=$summImages item=desc name=imgLoop}
            <a href="{$path}/thumbnail.php?id={$summId|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=large" class="title" onmouseover="document.getElementById('thumbnail_{$summId|escape:"url"}').src='{$path}/thumbnail.php?id={$summId|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=small'; document.getElementById('thumbnail_link_{$summId|escape:"url"}').href='{$path}/thumbnail.php?id={$summId|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=large'; return false;" />
            {if $desc}{$desc|escape}{else}{$smarty.foreach.imgLoop.iteration + 1}{/if}
            </a>
        {/foreach}
          </div>
        {/if}
        {if is_array($summFormats)}
          {assign var=mainFormat value=$summFormats.0} 
          {assign var=displayFormat value=$summFormats|@end} 
        {else}
          {assign var=mainFormat value=$summFormats} 
          {assign var=displayFormat value=$summFormats} 
        {/if}
        {* Cover image *}
          <div class="resultNoImage format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""} format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""}"></div>
        {if $summThumb}
            <div class="resultImage"><a href="{$summThumb|regex_replace:"/&size=small/":"&size=large"|escape}" onclick="launchFancybox(this); return false;" rel="{$summId|escape:"url"}"><img src="{$summThumb|escape}" class="summcover" alt="{translate text='Cover Image'}" /></a></div>
        {/if}

        </div> 

    </div>
    
    <div class="resultColumn2 grid_11">
        <div class="resultItemLine1">
            <a href="{$url}/PCI/Record?id={$id|escape:"url"}"
            class="title">{if !$record.title}{translate text='Title not available'}{else}{$record.title|highlight}{/if}</a>
        </div>
        <div class="resultItemFormat"><span class="iconlabel format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""} format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$record.format prefix='format_PCI_'}</span>
        </div>
        <div class="resultItemLine2">
        {if !empty($record.author.0)}
            {translate text='by'}:
        {foreach from=$record.author item=author name="loop"}
            <a href="{$url}/PCI/Search?type=Author&amp;lookfor={$author|unhighlight|trim|escape:"url"}">{$author|trim|highlight}</a>{if !$smarty.foreach.loop.last}, {/if} 
        {/foreach}
        {/if}
        {if !empty($record.publicationDate)}{translate text='Publication Date'}: {$record.publicationDate|escape}{/if}
        </div>
        <div class="resultItemLine3">
        {if !empty($record.publicationTitle)}{translate text='Published in'}: {$record.publicationTitle|escape}{/if}
        </div>
        {if $record.url || $record.openUrl}
        <div class="resultItemLine4">
            {if $record.url || $record.fulltext != 'no_fulltext'}
                {if $record.url|@count > 2}
                <p class="resultContentToggle"><a href="#" class="toggleHeader">{translate text='available_online'}<img src="{path filename="images/down.png"}" width="11" height="6" /></a></p>
                {else}
                <p class="resultContentToggle">{translate text='available_online'}<img src="{path filename="images/down.png"}" width="11" height="6" /></p>
                {/if}    
            <div class="resultContentList">
            <ul>
                {foreach from=$record.url item=recordLink}
                <li><a target="_blank" href="{$recordLink|proxify|escape}">{$recordLink|escape:"html"|truncate:60:"...":true:true}</a><br />
                {/foreach}
            </ul>
                {if $record.openUrl}
                {include file="Search/openurl.tpl" openUrl=$record.openUrl}
                {/if}  
            </div>
            {else}
                {if $record.openUrl}
                {include file="Search/openurl.tpl" openUrl=$record.openUrl}
                {/if}              
            {/if}  
        </div>
        {/if}    
    
        {* Display the lists that this record is saved to *}
        <div class="savedLists info hide" id="savedLists{$id|escape}">
          <strong>{translate text="Saved in"}:</strong>
        </div>
    </div>

    <div class="last addToFavLink">
        <a id="saveRecord{$id|escape}" href="{$url}/PCI/Save?id={$id|escape:"url"}" class="tool savePCIRecord PCIRecord fav" title="{translate text='Add to favorites'}"></a>
    </div>
    <div class="clear"></div>
</div>
    
</li>
{/foreach}
</ul>

<!-- END of: Search/list-list.tpl -->