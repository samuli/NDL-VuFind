<!-- START of: PCI/result-grid.tpl -->

<div class="gridRecordBox result recordId" id="record{$record.ID.0|escape}">
  <div class="span-3 last addToFavLink">
    <a id="saveRecord{$record.id|escape}" href="{$url}/PCI/Save?id={$record.id|escape:"url"}" class="tool savePCIRecord PCIRecord fav" title="{translate text='Add to favorites'}"></a>
  </div>      

  <div class="gridContent">
    <div class="gridTitleBox" >
      <a href="{$url}/PCI/Record?id={$record.id|escape:"url"}"
        class="gridTitle">{if !$record.title}{translate text='Title not available'}{else}{$record.title|highlight}{/if}</a>

      <div class="gridPublished">
        {if !empty($record.publicationDate)}{translate text='Published'}: {$record.publicationDate|escape}{/if}
      </div>
      {if $listNotes}
      <div class="notes">
        <p><span class="heading">{translate text="Description"} </span>({$listUsername|escape:'html'}):</p>
        <p class="text">{$listNotes|escape:'html'}</p>
      </div>
      {/if}
    </div>
  </div>

  <div class="coverDiv">
    <div class="resultNoImage format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""} format{$record.format|lower|regex_replace:"/[^a-z0-9]/":""}"></div>
  </div>

  <div class="clear"></div>
</div>

<!-- END of: PCI/result-grid.tpl -->
