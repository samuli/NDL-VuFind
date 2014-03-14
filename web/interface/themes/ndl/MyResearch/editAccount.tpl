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
  
  <p class="backLink"><a href="{$path}/MyResearch/Accounts">&laquo;{translate text="Back to Your Account"}</a></p>
{if $errorMsg}
  <div class="messages">
   <div class="error">
    {if $errorMsg === 'Invalid Patron Login'}{translate text="Login Failed Info"}
    {else}
     {$errorMsg|translate}     
    {/if} 
   </div>
  </div>
{/if}
<form method="post" name="editAccountForm" action="{$url}/MyResearch/Accounts" id="editAccountForm">
{if $id}
  <input type="hidden" name="id" value="{$id|escape}" />
{/if}
{if $loginTargets}
    <br class="clear"/>
  	<label class="displayBlock" for="login_target">{translate text="Choose library"}</label>
    <select id="login_target" name="login_target" class="{jquery_validation required='Please choose a library'}">
      <option value="">{translate text="Choose library"}</option>
    {foreach from=$loginTargets item=target}
      <option value="{$target}"{if (!$login_target && ($target == $defaultLoginTarget)) || ($target == $login_target)} selected="selected"{/if}>{translate text=$target prefix='source_'}</option>
    {/foreach}
    </select>
    <br class="clear"/>
  {/if}
  <label class="displayBlock" for="account_name">{translate text="Library Card Name"}</label>
  <input id="account_name" type="text" name="account_name" value="{$account_name|escape}" size="50" 
    class="mainFocus" placeholder="{translate text ='librarycard_placeholder'}"/>
    <label class="displayBlock" for="username">{translate text='Username'}</label>
    <input id="username" type="text" name="username" value="{$cat_username|escape}" class="{jquery_validation required='This field is required'}"/>
    <label class="displayBlock" for="password">{translate text='Password'}</label>
    <input id="password" type="password" name="password" value="{$cat_password|escape}" class="{jquery_validation required='This field is required'}"/>
    <br class="clear"/>
  <input class="button buttonFinna" type="submit" name="submit" {if $id}value="{translate text="Update"}"{else}value="{translate text="Save"}"{/if}/>
</form>
<script type="text/javascript">
  {literal}
  $(document).ready(function() {
    $("#editAccountForm").validate();      
    $("input").one("keydown", function () { 
      $("#errormessage").css({"visibility":"hidden"});
    });
  });
  {/literal}
</script>
</div>
</div>
<!-- END of: MyResearch/editList.tpl -->
