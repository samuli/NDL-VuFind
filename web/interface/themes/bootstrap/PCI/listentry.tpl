<!-- START of: PCI/listentry.tpl -->

<table>
<tr>
<td>

      <div class="listentry recordId" id="record{$record.id|escape}">
        <div class="resultCheckbox">
        <label for="checkbox_{$record.id|regex_replace:'/[^a-z0-9]/':''|escape}" class="offscreen">{translate text="Select this record"}</label>
        <input id="checkbox_{$record.id|regex_replace:'/[^a-z0-9]/':''|escape}" type="checkbox" name="ids[]" value="{$record.id|escape}" class="checkbox_ui"/>
        <input type="hidden" name="idsAll[]" value="{$record.id|escape}" />
        </div>

</td>
<td>  

        <div class="coverDiv">
          <div class="resultNoImage"><p>{translate text='No image'}</p></div>
        </div>

</td>
<td>
        
        <div class="resultColumn2">
          <div class="resultItemLine1">
            <a href="{$url}/PCI/Record?id={$record.id|escape:"url"}"  
            class="title">{if !$record.title.0}{translate text='Title not available'}{else}{$record.title|highlight}{/if}</a>
          </div>

          <div class="resultItemLine2">
            {if $record.author}
            {translate text='by'}
            {foreach from=$record.author item=author name="loop"}
              <a href="{$url}/PCI/Search?type=Author&amp;lookfor={$author|unhighlight|escape:"url"}">{$author|highlight}</a>{if !$smarty.foreach.loop.last},{/if} 
            {/foreach}
            <br/>
            {/if}

            {if $record.publicationTitle}{translate text='Published in'} {$record.publicationTitle|highlight}, {/if}
            {$record.source} 
          </div>
          <!--
          <div class="resultItemLine3">
            {if $record.snippet}
            <blockquote>
              <span class="quotestart">&#8220;</span>{$record.snippet}<span class="quoteend">&#8221;</span>
            </blockquote>
            {/if}
          </div> -->

          <span class="iconlabel format{$record.format|getSummonFormatClass|escape}">{translate text=$record.format}</span>
        </div>
        
</td>
      {if $listEditAllowed}
<td>

        <div class="last floatright editItem">
          <a href="{$url}/MyResearch/Edit?id={$record.id|escape:"url"}{if !is_null($listSelected)}&amp;list_id={$listSelected|escape:"url"}{/if}" class="edit tool"></a>
          {* Use a different delete URL if we're removing from a specific list or the overall favorites: *}
          <a
          {if is_null($listSelected)}
            href="{$url}/MyResearch/Favorites?delete={$record.id|escape:"url"}"
          {else}
            href="{$url}/MyResearch/MyList/{$listSelected|escape:"url"}?delete={$record.id|escape:"url"}"
          {/if}
          class="delete tool" onclick="return confirm('{translate text='confirm_delete'}');"></a>
        </div>
      {/if}

</tr>
</table>

        <div class="clear"></div>
        <span class="Z3988" title="{$record.openUrl|escape}"></span>
      </div>
<!-- END of: PCI/listentry.tpl -->
