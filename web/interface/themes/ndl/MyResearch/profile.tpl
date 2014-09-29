<!-- START of: MyResearch/profile.tpl -->

{include file="MyResearch/menu.tpl"}

{if count($pickup) > 1}
  {assign var='showHomeLibForm' value=true}
{else}
  {assign var='showHomeLibForm' value=false}
{/if}
<div class="myResearch profile{if $sidebarOnLeft} last{/if}">
  <div class="content">
    <div class="resultHead grid_24">
  {if $userMsg}
      <p class="success">{translate text=$userMsg}</p>
  {/if}
  {if $userError}
      <p class="error">{translate text=$userError}</p>
  {/if}
  {if $errorMsg}
      <p class="error">{translate text=$errorMsg}</p>
  {/if}
    </div>
  
    <form method="post" action="{$url}/MyResearch/Profile" id="profile_form">
    <div class="profileInfo grid_12 static">
      {* NDLBlankInclude *}
      		<p class="noContentMessage">{translate text='profile_instructions'}</p>
      {* /NDLBlankInclude *}
      {if $profile.blocks}
        {foreach from=$profile.blocks item=block name=loop}
          <p class="borrowingBlock"><strong>{translate text=$block|escape}</strong></p>
        {/foreach}
      {/if}
      <h2>{translate text='Your Profile'}</h2>
      <table class="profileGroup">
      <tr>        
        <th>{translate text='Email'}</th><td><input type="text" name="email" value="{$email|escape}" class="{jquery_validation email='Email address is invalid'}"></input></td><td class="notif"><span class="userGuider">{if !$hideDueDateReminder}{translate text="notif_email"}{else}{translate text="notif_email_alert"}{/if}</span></td>
      </tr>
      {if $libraryCard}
      <tr>
        {if !$hideDueDateReminder}
           <th>{translate text='due_date_reminder'}</th>
           <td>
              <select name="due_date_reminder">
                <option value="0" {if $dueDateReminder == 0}selected="selected"{/if}>{translate text='due_date_reminder_none'}</option>
                <option value="1" {if $dueDateReminder == 1}selected="selected"{/if}>{translate text='due_date_reminder_one_day'}</option> 
                <option value="2" {if $dueDateReminder == 2}selected="selected"{/if}>{translate text='due_date_reminder_two_days'}</option> 
                <option value="3" {if $dueDateReminder == 3}selected="selected"{/if}>{translate text='due_date_reminder_three_days'}</option> 
              </select>
           </td>
           {if count($catalogAccounts) > 1}
             <td class="notif"><span class="userGuider">{translate text="notif_duedate"}</span></td>
		   {else}
        	 <td></td>
           {/if}
        {else}
            <input type="hidden" name="due_date_reminder" value="0" />
        {/if}
      </tr>
      {/if} <!-- end of duedate line -->
      <tr>
        <th><input class="button buttonFinna left" type="submit" value="{translate text='Save'}" /></th>
        <td><td>
      </tr>
    </table>
    </form>
    <div class="clear"></div>


    
    
    <!-- this is the -->
    {if $catalogAccounts}

    <div class="clear"></div>
    {/if}

    {if $user->cat_username}
    <h2>{translate text="Library Card Settings"}: 	
    	     {foreach from=$catalogAccounts item=account}
        	{if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
     {/foreach} 
            {if !empty($accountname)}({/if}{assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}{translate text=$source prefix='source_'}{if !empty($accountname)}){/if}
    </h2>
    <table class="profileGroup">
      {if $showHomeLibForm}   
      <tr>
        <form method="post" action="{$url}/MyResearch/Profile" id="profile_form">
        <th><label for="home_library">{translate text="Preferred pick up location"}</label></th>
        {if count($pickup) > 1}
          {if $profile.home_library != ""}
            {assign var='selected' value=$profile.home_library}
          {else}
            {assign var='selected' value=$defaultPickUpLocation}
          {/if}
        <td>
         <select id="home_library" name="home_library">
          {foreach from=$pickup item=lib name=loop}
            <option value="{$lib.locationID|escape}" {if $selected == $lib.locationID}selected="selected"{/if}>{$lib.locationDisplay|escape}</option>
          {/foreach}
         </select>
        </td>
      </tr>
        <tr>
        	<th colspan="3"><input class="button buttonFinna left" type="submit" value="{translate text='Save'}" /></th>
        </tr>
        {else}
          <td>{$pickup.0.locationDisplay}</td>
          <td></td>
        {/if}
        </form>
      </tr>
      {/if}
    { if $changePassword }
      <form method="post" action="{$url}/MyResearch/Profile" id="password_form">      
        <tr><td colspan="3"><h3>{translate text='change_password_title'}</h3></td></tr>
        <tr>
	        <th>{translate text='change_password_old_password'}:</th>
	        <td><input type="password" id="oldPassword" name="oldPassword" value=""></input></td>
            <td><span class="userGuider">{translate text='change_password_instructions'}</span></td>
        </tr>
        <tr>
	        <th>{translate text='change_password_new_password'}:</th>
	        <td><input type="password" id="newPassword" name="newPassword" value=""></input></td>
            <td></td>
        </tr>
        <tr>
	        <th>{translate text='change_password_new_password_again'}:</th>
	        <td><input type="password" id="newPassword2" name="newPassword2" value=""></input></td>
            <td></td>
        </tr>
	  <tr>
      	<th><input class="button buttonFinna left" type="submit" value="{translate text='change_password_submit'}" /></th>
        <td colspan="2"></td>
      </tr>
      </form>
      { /if }
      <tr><th colspan="2"><h3>{translate text='library_personal_details'}</h3></th>
      </tr>
      <tr>
        <th>{translate text='First Name'}</th><td>{if $profile.firstname}{$profile.firstname|escape}{else}-{/if}</td><td></td>
      </tr>
      <tr>
        <th>{translate text='Last Name'}</th><td>{if $profile.lastname}{$profile.lastname|escape}{else}-{/if}</td><td></td>
      </tr>
      <tr>
        <th>{translate text='Address'} 1</th><td>{if $profile.address1}{$profile.address1|escape}{else}-{/if}</td><td></td>
      </tr>
      <tr>
        <th>{translate text='Address'} 2</th><td>{if $profile.address2}{$profile.address2|escape}{else}-{/if}</td><td></td>
      </tr>
      <tr>
        <th>{translate text='Zip'}</th><td>{if $profile.zip}{$profile.zip|escape}{else}-{/if}</td><td></td>
      </tr>   
      <tr>
        <th>{translate text='Phone Number'}</th><td>{if $profile.phone}{$profile.phone|escape}{else}-{/if}</td><td></td>
      </tr>
      <tr>
        <th>{translate text='Email'}</th><td>{if $profile.email}{$profile.email|escape}{else}-{/if}</td><td></td>
      </tr>
      <tr>
        <th>{translate text='Group'}</th><td>{$profile.group|escape}</td><td></td>
      </tr> 
      <tr>
      {foreach from=$profile.blocks item=block name=loop}
        {if $smarty.foreach.loop.first}
          <th>{translate text='Borrowing Blocks'}</th>

        {/if}
        <td class="blockInfo">{$block|escape}</td>
      {/foreach}
      </tr>
    </table>
      {else}
        {include file="MyResearch/catalog-login.tpl"}
      {/if}
    </div>
    <div id="deleteAccount"><button class="button buttonFinna">{translate text="delete_account_title"}</button></div>
  </div>
</div>
<div class="clear"></div>

<script>
   {literal}
   $("#deleteAccount button").unbind().click(function(e) {
      var url = path + '/AJAX/JSON_DeleteUser?method=init';
      var dialog = getPageInLightbox(url, "{/literal}{translate text="delete_account_title"}{literal}");
      e.preventDefault();
  });
  {/literal}
  
  {literal}
  $(document).ready(function() {
    $("#profile_form").validate();     
  {/literal}
  {if $changePassword}
    {literal} 
    $("#password_form").validate();
    $("#password_form input[type='password']").each(function() {
        $(this).rules("add", {
            minlength: {/literal}{$changePassword.minLength}{literal},
            maxlength: {/literal}{$changePassword.maxLength}{literal},
            messages: {
                {/literal}minlength: jQuery.format("{translate text="Minimum length `$smarty.ldelim`0`$smarty.rdelim` characters"}"){literal},
                {/literal}maxlength: jQuery.format("{translate text="Maximum length `$smarty.ldelim`0`$smarty.rdelim` characters"}"){literal}
            },
        });
    });
    $("#newPassword2").rules("add", {
        equalTo: '#newPassword',
        messages: {
            equalTo: "{/literal}{translate text='change_password_error_verification'}{literal}"
        }
    });
    {/literal}
  {/if}
  {literal} 
  });
  {/literal}
</script>

<!-- END of: MyResearch/profile.tpl -->
