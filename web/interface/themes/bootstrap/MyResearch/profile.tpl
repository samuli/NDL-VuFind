<!-- START of: MyResearch/profile.tpl -->

{include file="MyResearch/menu.tpl"}

{if count($pickup) > 1}
  {assign var='showHomeLibForm' value=true}
{else}
  {assign var='showHomeLibForm' value=false}
{/if}
<div class="well-small myResearch profile{if $sidebarOnLeft} last{/if}">
  {if $userMsg}
      <div class="alert alert-info">{translate text=$userMsg}</div>
  {/if}
  {if $userError}
      <div class="alert alert-error">{translate text=$userError}</div>
  {/if}

  <span class="lead">{translate text='Your Profile'}</span>

    <form method="post" action="{$url}/MyResearch/Profile" id="profile_form">
      <div class="row-fluid profileInfo">
        <h4>{translate text='Local Settings'}</h4>
        <div class="span5">
          {translate text='Email'}:
          <br /><input type="text" name="email" value="{$email|escape}" class="{jquery_validation email='Email address is invalid'}"></input>
          <br/>
          {translate text='due_date_reminder'}:
          <br/>
          <select name="due_date_reminder">
            <option value="0" {if $dueDateReminder == 0}selected="selected"{/if}>{translate text='due_date_reminder_none'}</option>
            <option value="1" {if $dueDateReminder == 1}selected="selected"{/if}>{translate text='due_date_reminder_one_day'}</option> 
            <option value="2" {if $dueDateReminder == 2}selected="selected"{/if}>{translate text='due_date_reminder_two_days'}</option> 
            <option value="3" {if $dueDateReminder == 3}selected="selected"{/if}>{translate text='due_date_reminder_three_days'}</option> 
          </select>

          {if $showHomeLibForm}
          <br />
          <label for="home_library">{translate text="Preferred Library"}:</label>

            {if count($pickup) > 1}
              {if $profile.home_library != ""}
                {assign var='selected' value=$profile.home_library}
              {else}
                {assign var='selected' value=$defaultPickUpLocation}
              {/if}
              <select id="home_library" name="home_library" class="selectpicker">
              {foreach from=$pickup item=lib name=loop}
                <option value="{$lib.locationID|escape}" {if $selected == $lib.locationID}selected="selected"{/if}>{$lib.locationDisplay|escape}</option>
              {/foreach}
              </select>
            {else}
              {$pickup.0.locationDisplay}
            {/if}
          {/if}
          <br/>
          <input class="btn btn-info button" type="submit" value="{translate text='Save'}" />
        </div>
      </div>
    </form>

    {if $user->cat_username}
      <div class="row-fluid profileInfo">
        <h4>{translate text='Source of information'}:
          {assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}
          {translate text=$source prefix='source_'}
        </h4>
        <div class="span5 well-small">
          <table class="table table-condensed">
          <tr>
            <td>{translate text='First Name'}:</td>
            <td>{if $profile.firstname}{$profile.firstname|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Last Name'}:</td>
            <td>{if $profile.lastname}{$profile.lastname|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td>{translate text='Address'} 1:</td>
            <td>{if $profile.address1}{$profile.address1|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Address'} 2:</td>
            <td>{if $profile.address2}{$profile.address2|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Zip'}:</td>
            <td>{if $profile.zip}{$profile.zip|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td>{translate text='Phone Number'}:</td>
            <td>{if $profile.phone}{$profile.phone|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Email'}:</td>
            <td>{if $profile.email}{$profile.email|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Group'}:</td>
            <td>{$profile.group|escape}</td>
          </tr>
          </table>
        </div>

        <div class="row-fluid profileGroup">
        {foreach from=$profile.blocks item=block name=loop}
          {if $smarty.foreach.loop.first}
            <span>{translate text='Borrowing Blocks'}:</span>
          {else}
            <span>&nbsp;</span>
          {/if}
          <span>{$block|escape}</span><br class="clear"/>
        {/foreach}
        </div>

        {if $changePassword}
        <br class="clear"/>
        <form method="post" action="{$url}/MyResearch/Profile" id="password_form">      
          <div class="row-fluid profileInfo">
            <h4>{translate text='change_password_title'}</h4>
            <div class="span5">
              <p>{translate text='change_password_instructions'}</p>
	          {translate text='change_password_old_password'}:
              <br /><input type="password" id="oldPassword" name="oldPassword" value=""></input>
	          <br />{translate text='change_password_new_password'}:
	          <br /><input type="password" id="newPassword" name="newPassword" value=""></input>
	          <br />{translate text='change_password_new_password_again'}:
	          <br /><input type="password" id="newPassword2" name="newPassword2" value=""></input>
              <br /><input class="btn btn-info button" type="submit" value="{translate text='change_password_submit'}" />
            </div>
        </form>
        {/if}
        
    {else}
      {include file="MyResearch/catalog-login.tpl"}
    {/if}
      </div>
  </div>

<script>
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
