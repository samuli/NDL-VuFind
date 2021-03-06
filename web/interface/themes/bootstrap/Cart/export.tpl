{if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
{if $infoMsg}<div class="info">{$infoMsg|translate}</div>{/if}

{if empty($exportOptions)}
  <div class="error">{translate text="bulk_export_not_supported"}</div>
{else}
<form action="{$url}/Cart/Home?export" method="POST" name="exportForm" title="{translate text='Export Items'}">

  <label class="displayBlock">{$exportList|@count} {translate text="records"}</label>

  <label for="format">{translate text='Format'}:</label>      
  <select name="format" id="format">
  {foreach from=$exportOptions item=exportOption}
    <option value="{$exportOption|escape}">{translate text=$exportOption}</option>
   {/foreach}
  </select>
  
  {foreach from=$exportIDS item=exportID}
    <input type="hidden" name="ids[]" value="{$exportID|escape:"URL"}" />
  {/foreach}
  
  {if $followupModule}
    <input type="hidden" name="followup" value="1" />
    <input type="hidden" name="followupModule" value="{$followupModule|escape}" />
  {/if}
  {if $followupAction}
    <input type="hidden" name="followupAction" value="{$followupAction|escape}" />
  {/if}
  <br />
  <input class="btn btn-small btn-info input-small button" type="submit" name="submit" value="{translate text='export_selected'}">

</form>
{/if}
