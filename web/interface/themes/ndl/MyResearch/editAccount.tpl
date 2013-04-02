<!-- START of: MyResearch/editAccount.tpl -->

<div class="myresearchHeader">
  <div class="content">
    <div class="grid_24">
      <h1>{if $id}{translate text="Edit Library Card"}{else}{translate text="Add a Library Card"}{/if}</h1>
    </div>
  </div>
</div>
<div class="content">
<div class="grid_24">
{if $errorMsg}
  <div class="messages">
    {if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
  </div>
{/if}
<form method="post" name="editAccountForm" action="{$url}/MyResearch/Accounts">
{if $id}
  <input type="hidden" name="id" value="{$id|escape}" />
{/if}
  <label class="displayBlock" for="account_name">{translate text="Library Card Name"}</label>
  <input id="account_name" type="text" name="account_name" value="{$account_name|escape}" size="50" 
    class="mainFocus {jquery_validation required='This field is required'}"/>
  <label class="displayBlock" for="description">{translate text="Description"}</label>
  <textarea id="description" name="description" rows="3" cols="50">{$description|escape}</textarea>
  {if $loginTargets}
    <label class="displayBlock" for="login_target">{translate text="Login Target"}</label>
    <select id="login_target" name="login_target">
    {foreach from=$loginTargets item=target}
      <option value="{$target}"{if (!$login_target && ($target == $defaultLoginTarget)) || ($target == $login_target)} selected="selected"{/if}>{translate text=$target prefix='source_'}</option>
    {/foreach}
    </select>
    <br class="clear"/>
  {/if}
    <label class="displayBlock" for="username">{translate text='Username'}</label>
    <input id="username" type="text" name="username" value="{$cat_username|escape}" class="{jquery_validation required='This field is required'}"/>
    <label class="displayBlock" for="password">{translate text='Password'}</label>
    <input id="password" type="password" name="password" value="{$cat_password|escape}" class="{jquery_validation required='This field is required'}"/>
    <br class="clear"/>

  <input class="button buttonFinna" type="submit" name="submit" value="{translate text="Save"}"/>
</form>
</div>
</div>
<!-- END of: MyResearch/editList.tpl -->
