<!-- START of: MyResearch/list-form.tpl -->

{if $listError}<p class="error">{$listError|translate}</p>{/if}
<form method="post" action="{$url}/MyResearch/ListEdit" name="listEdit" id="listEdit">

<label class="displayBlock" for="list_title">{translate text="List"}:</label>
  <input id="list_title" type="text" name="title" value="{$list->title|escape:"html"}"{* size="50"*} 
      class="mainFocus {jquery_validation required='This field is required'}"/>
  <label class="displayBlock" for="list_desc">{translate text="Description"}:</label>
  <textarea id="list_desc" name="desc" rows="3"{* cols="50"*}>{$list->desc|escape:"html"}</textarea>
  <fieldset>
    <span class="pull-left">&nbsp;&nbsp;{translate text="Access"}:&nbsp;&nbsp;</span>
    <div class="well well-small">
      <label class="radio inline" for="list_public_1">
        <input id="list_public_1" type="radio" name="public" value="1"/>{translate text="Public"}
      </label>
      <label class="radio inline" for="list_public_0">
        <input id="list_public_0" type="radio" name="public" value="0" checked="checked"/>{translate text="Private"}
      </label>
    </div>
  </fieldset>
  <input class="btn btn-info button" type="submit" name="submit" value="{translate text="Save"}"/>
  <input type="hidden" name="recordId" value="{$recordId}"/>
  <input type="hidden" name="followupModule" value="{$followupModule}"/>
  <input type="hidden" name="followupAction" value="{$followupAction}"/>
  <input type="hidden" name="followupId" value="{$followupId}"/>
  <input type="hidden" name="followupText" value="{translate text='Add to favorites'}"/>
  {if $bulkIDs}
    {foreach from=$bulkIDs item="bulkID"}
      <input type="hidden" name="ids[]" value="{$bulkID}"/>
    {/foreach}
  {/if}
</form>

<!-- END of: MyResearch/list-form.tpl -->
