<!-- START of: RecordDrivers/Index/listentry.tpl -->

<div class="listentry recordId" id="record{$listId|escape}">
 <div class="checkboxFilter">
  <div class="resultCheckbox">
    <input id="checkbox_{$listId|regex_replace:'/[^a-z0-9]/':''|escape}" type="checkbox" name="ids[]" value="{$listId|escape}" class="checkbox_ui checkbox"/>
    <label for="checkbox_{$listId|regex_replace:'/[^a-z0-9]/':''|escape}" >{translate text="Select"}: {$listTitle|escape}</label>
    <input type="hidden" name="idsAll[]" value="{$listId|escape}" />
  </div>
 </div>
  
  {assign var=img_count value=$summImages|@count}
  <div class="coverDiv">
{* Multiple images *}
{if $img_count > 1}
    <div class="imagelinks">
{foreach from=$summImages item=desc name=imgLoop}
   {if $smarty.foreach.imgLoop.iteration <= 3}
      <a data-dates="{$listDate.0|escape}{if $listDate.1 && $listDate.1 != $listDate.0} - {$listDate.1|escape}{/if}" data-title="{$listTitle|truncate:100:"..."|escape:"html"}" data-building="{translate text=$listBuilding.0|rtrim:'/' prefix="facet_"}" data-url="{$url}/Record/{$listId|escape:'url'}" data-linktext="{translate text='To the record'}"  data-author="{$listAuthor}" class="title fancybox fancybox.image"  href="{$path}/thumbnail.php?id={$listId|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=large"  onmouseover="document.getElementById('thumbnail_{$listId|escape:"url"}').src='{$path}/thumbnail.php?id={$listId|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=small'; document.getElementById('thumbnail_link_{$listId|escape:"url"}').href='{$path}/thumbnail.php?id={$listId|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=large'; return false;" rel="gallery" />
         {if $smarty.foreach.imgLoop.iteration > 2}
            &hellip;
         {else}
            {if $desc}{$desc|escape}{else}{$smarty.foreach.imgLoop.iteration + 1}{/if}
         {/if}
      </a>
   {/if}
{/foreach}
    </div>
{/if}
    <div class="resultNoImage"><p>{translate text='No image'}</p></div>
    {if $img_count > 1}
        <div class="resultImage">
            <a class="title fancybox-trigger" href="{$path}/thumbnail.php?id={$listId|escape:"url"}&index=0&size=large" id="thumbnail_link_{$listId|escape:"url"}">
               <img id="thumbnail_{$listId|escape:"url"}" src="{$path}/thumbnail.php?id={$listId|escape:"url"}&size=small" class="summcover" alt="{translate text='Cover Image'}" />
            </a>
        </div>
    {elseif $img_count == 1 || $listThumb}
        <div class="resultImage">
            <a class="fancybox fancybox.image" href="{$listThumb|escape}&index=0&size=large" rel="gallery" id="thumbnail_link_{$listId|escape:"url"}" data-dates="{$listDate.0|escape}{if $listDate.1 && $listDate.1 != $listDate.0} - {$listDate.1|escape}{/if}" data-title="{$listTitle|truncate:100:"..."|escape:"html"}" data-building="{translate text=$listBuilding.0|rtrim:'/'  prefix="facet_"}" data-url="{$url}/Record/{$listId|escape:'url'}" data-linktext="{translate text='To the record'}"  data-author="{$listAuthor}"><img id="thumbnail_{$listId|escape:"url"}" src="{$listThumb|escape}" class="summcover" alt="{translate text='Cover Image'}"/></a>
        </div>    
    {/if}  
  </div>

  <div class="resultColumn2">
      <a href="{$url}/Record/{$listId|escape:"url"}" class="title">{$listTitle|escape}</a><br/>
      {if $listAuthor}
        {translate text='by'}: <a href="{$url}/Search/Results?lookfor={$listAuthor|escape:"url"}&amp;type=Author">{$listAuthor|escape}</a><br/>
      {/if}
      {if $listTags}
        <strong>{translate text='Your Tags'}:</strong>
        {foreach from=$listTags item=tag name=tagLoop}
          <a href="{$url}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape:"html"}</a>{if !$smarty.foreach.tagLoop.last},{/if}
        {/foreach}
        <br/>
      {/if}
      {if $listNotes}
        <strong>{translate text='Notes'}:</strong>
        {if count($listNotes) > 1}<br/>{/if}
        {foreach from=$listNotes item=note}
          {$note|escape:"html"}<br/>
        {/foreach}
      {/if}

      {assign var=mainFormat value=$listFormats.0} 
      {assign var=displayFormat value=$listFormats|@end} 
      <span class="iconlabel format{$mainFormat|lower|regex_replace:"/[^a-z0-9]/":""} format{$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$displayFormat prefix='format_'}</span>
  </div>

  {if $listEditAllowed}
  <div class="last floatright editItem">
      <a href="{$url}/MyResearch/Edit?id={$listId|escape:"url"}{if !is_null($listSelected)}&amp;list_id={$listSelected|escape:"url"}{/if}">{translate text="Edit"}</a>
  </div>
  {/if}

  <div class="clear"></div>
</div>

<!-- END of: RecordDrivers/Index/listentry.tpl -->
