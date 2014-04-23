<!-- START of: MyResearch/editList.tpl -->

<div class="myresearchHeader">
  <div class="content">
    <div class="grid_24"><h1>{translate text="edit_list"}</h1></div>
  </div>
</div>

<div class="content">
<div class="grid_24">

  <p class="backLink"><a href="{$path}/MyResearch/Favorites">&laquo;{translate text="Back to Your Account"}</a></p>
{if $infoMsg || $errorMsg}
  <div class="messages">
    {if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
    {if $infoMsg}<div class="info">{$infoMsg|translate}</div>{/if}
  </div>
{/if}
{if empty($list)}
  <div class="error">{translate text='edit_list_fail'}</div>
{else}
  <form method="post" name="editListForm" action="">
    <label class="displayBlock" for="list_title">{translate text="List"}:</label>
    <input id="list_title" type="text" name="title" value="{if $list->title == 'My Favorites'}{translate text=$list->title}{else}{$list->title|escape:"html"}{/if}" size="50" 
      class="mainFocus {jquery_validation required='This field is required'}"/>
    <fieldset>
      <legend>{translate text="Access"}:</legend> 
      <input id="list_public_1" type="radio" name="public" value="1" {if $list->public == 1}checked="checked"{/if}/> <label for="list_public_1">{translate text="Public"}</label>
      <input id="list_public_0" type="radio" name="public" value="0" {if $list->public == 0}checked="checked"{/if}/> <label for="list_public_0">{translate text="Private"}</label> 
    </fieldset>
    <input class="button buttonFinna" type="submit" name="submit" value="{translate text="Save"}"/>
  </form>
{/if}
</div>
</div>

<!-- END of: MyResearch/editList.tpl -->
