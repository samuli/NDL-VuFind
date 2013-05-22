<!-- START of: MyResearch/editList.tpl -->

<div class="span12 well-small">
  <h3>{translate text="edit_list"}</h3>
  {if $infoMsg || $errorMsg}
    <div class="messages">
      {if $errorMsg}<div class="alert alert-error">{$errorMsg|translate}</div>{/if}
      {if $infoMsg}<div class="alert alert-info">{$infoMsg|translate}</div>{/if}
    </div>
  {/if}
  {if empty($list)}
    <div class="alert alert-error">{translate text='edit_list_fail'}</div>
  {else}
    <form method="post" name="editListForm" action="">
      <label class="displayBlock" for="list_title">{translate text="List"}:</label>
      <input id="list_title" type="text" name="title" value="{$list->title|escape:"html"}" size="50" 
        class="mainFocus {jquery_validation required='This field is required'}"/>
      <label class="displayBlock" for="list_desc">{translate text="Description"}:</label>
      <textarea id="list_desc" name="desc" rows="3" cols="50">{$list->description|escape:"html"}</textarea>
      <fieldset>
        <span class="pull-left">&nbsp;&nbsp;{translate text="Access"}:&nbsp;&nbsp;</span>
        <div class="well well-small">
          <label class="radio inline" for="list_public_1">
            <input id="list_public_1" type="radio" name="public" value="1" {if $list->public == 1}checked="checked"{/if}/>{translate text="Public"}
          </label>
          <label class="radio inline" for="list_public_0">
            <input id="list_public_0" type="radio" name="public" value="0" {if $list->public == 0}checked="checked"{/if}/>{translate text="Private"}
          </label>
        </div>
      </fieldset>
      <input class="btn btn-info button" type="submit" name="submit" value="{translate text="Save"}"/>
    </form>
  {/if}
</div>

<!-- END of: MyResearch/editList.tpl -->
