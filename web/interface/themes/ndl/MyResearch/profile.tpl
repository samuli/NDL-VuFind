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
        {if is_array($userMsg)}
          {foreach from=$userMsg item=msg}
            <p class="success">{translate text=$msg}</p>
          {/foreach}
        {else}
          <p class="success">{translate text=$userMsg}</p>
        {/if}
      {/if}
      {if $userError}
        {if is_array($userError)}
          {foreach from=$userError item=msg}
            <p class="error">{translate text=$msg}</p>
          {/foreach}
        {else}
          <p class="error">{translate text=$userError}</p>
        {/if}
      {/if}
      {if $errorMsg}
        <p class="error">{translate text=$errorMsg}</p>
      {/if}
    </div>
    {* NDLBlankInclude *}
    <p class="noContentMessage">{translate text='profile_instructions'}</p>
    {* /NDLBlankInclude *}
    <div class="profileInfo grid_12 static">
      {if $profile.blocks}
        {foreach from=$profile.blocks item=block name=loop}
          <p class="borrowingBlock"><strong>{translate text=$block|escape}</strong></p>
        {/foreach}
      {/if}
      {if !($hideProfileEmailAddress && $hideDueDateReminder)}
        <div class="profileGroupContainer">
        <form method="post" action="{$url}/MyResearch/Profile" class="profile_form" id="email_form">
          <h2>{translate text='Your Profile'}</h2>
          <table class="profileGroup">
            {if !$hideProfileEmailAddress}
              <tr>
                <th>{translate text='Email'}</th>
                <th><input type="text" name="email" value="{$email|escape}" class="{jquery_validation email='Email address is invalid'}"></th>
                <td class="notif"><span class="userGuider">{if !$hideDueDateReminder}{translate text="notif_email"}{else}{translate text="notif_email_alert"}{/if}</span></td>
              </tr>
            {/if}
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
            {/if}
            <tr>
              <th><input class="button buttonFinna left" type="submit" value="{translate text='Save'}" /></th>
              <td><td>
            </tr>
          </table>
        </form>
        </div>
        <div class="clear"></div>
      {/if}
      {if $catalogAccounts}
        <div class="clear"></div>
      {/if}
      <div class="profileGroupContainer">
      {if $user->cat_username}
        {capture name="accountString" assign="accountString"}
          {foreach from=$catalogAccounts item=account}
            {if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
          {/foreach}
          {assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''|translate_prefix:'source_'}
          {if $source != $accountname}
            {if !empty($accountname)}({/if}{$source}{if !empty($accountname)}){/if}
          {/if}
        {/capture}
        <h2>{translate text="Library Card Settings"}: {$accountString}</h2>
        <form method="post" action="{$url}/MyResearch/Profile" class="profile_form" id="pickup_form">
          <table class="profileGroup">
            <tr>
              <th><label for="home_library">{translate text="Preferred pick up location"}</label></th>
              <td>
                {if $showHomeLibForm}
                  {if $profile.home_library != ""}
                    {assign var='selected' value=$profile.home_library}
                  {else}
                    {assign var='selected' value=$defaultPickUpLocation}
                  {/if}
                  <select id="home_library" name="home_library">
                    {foreach from=$pickup item=lib name=loop}
                      <option value="{$lib.locationID|escape}" {if $selected == $lib.locationID}selected="selected"{/if}>{$lib.locationDisplay|escape}</option>
                    {/foreach} 
                  </select>
                {else}
                  {$pickup.0.locationDisplay}
                {/if}
              </td>
            </tr>
            {if $showHomeLibForm}
              <tr>
                <th colspan="2"><input class="button buttonFinna left" type="submit" value="{translate text='Save'}" /></th>
              </tr>
            {/if}
          </table>
        </form>
        {if count($profile.messagingServices)}
        <table class="profileGroup messagingSettings">          
          <tr><td colspan="3"><h3>{translate text='axiell_messaging_settings_title'}</h3></td></tr>
          {foreach from=$profile.messagingServices item=service name=loop}
          <tr><td colspan="3">{$service.type}: 
            {assign var="methodFound" value="0"}
            {foreach from=$service.sendMethods item=method name=loop2}
              {if $method.active}{if $methdodFound}, {/if}{assign var="methodFound" value="1"}{$method.method}{/if}
            {/foreach}
            {if !$methodFound}
              {translate text="axiell_messaging_settings_method_none"}
            {/if}
          </td></tr>
          {/foreach}
          <tr>
            <td>
              <a class="editMessagingSettings" href="#">{translate text="axiell_request_messaging_settings_change"}</a>
            </td>
          </tr>
        </table>
        {/if}
        {if $changePassword}
          <form method="post" action="{$url}/MyResearch/Profile" class="profile_form" id="password_form">
            <table class="profileGroup">
              <tr><th colspan="2" class="hefty">{translate text='change_password_title'}</th><th></th></tr>
              <tr>
                <th>{translate text='change_password_old_password'}:</th>
                <td><input type="password" id="oldPassword" name="oldPassword" value=""></td>
                <td class="notif"><span class="userGuider">{translate text='change_password_instructions'}</span></td>
              </tr>
              <tr>
                <th>{translate text='change_password_new_password'}:</th>
                <td><input type="password" id="newPassword" name="newPassword" value=""></td>
                <td></td>
              </tr>
              <tr>
                <th>{translate text='change_password_new_password_again'}:</th>
                <td><input type="password" id="newPassword2" name="newPassword2" value=""></td>
                <td></td>
              </tr>
              <tr>
                <th><input class="button buttonFinna left" type="submit" value="{translate text='change_password_submit'}" /></th>
                <td colspan="2"></td>
              </tr>
            </table>
          </form>
        {/if}
        <form method="post" action="{$url}/MyResearch/Profile" class="profile_form" id="personal_form">
          <table class="profileGroup">
            <tr>
              <th colspan="2" class="hefty">{translate text='library_personal_details'}</th>
              <th></th>
            </tr>
            <tr>
              <th>{translate text='First Name'}</th>
              <td>{if $profile.firstname}{$profile.firstname|escape}{else}-{/if}</td>
              <td></td>
            </tr>
            <tr>
              <th>{translate text='Last Name'}</th>
              <td>{if $profile.lastname}{$profile.lastname|escape}{else}-{/if}</td>
              <td></td>
            </tr>
            {if $driver != "AxiellWebServices"}
              <tr>
                <th>{translate text='Address'} 1</th>
                <td>{if $profile.address1}{$profile.address1|escape}{else}-{/if}</td>
                <td></td>
              </tr>
              <tr>
                <th>{translate text='Address'} 2</th>
                <td>{if $profile.address2}{$profile.address2|escape}{else}-{/if}</td>
                <td></td>
              </tr>
            {else}
              <tr>
                <th>{translate text='Address'}</th>
                <td>{if $profile.address1}{$profile.address1|escape}{else}-{/if}</td>
                <td class="notif">
                  <span class="userGuider">{translate text="address_change"}
                  <a class="editAddress" href="#">{translate text="axiell_request_address_change"}</a>.
                </span>
                </td>
              </tr>
            {/if}
            <tr>
              <th>{translate text='Zip'}</th>
              <td>{if $profile.zip}{$profile.zip|escape}{else}-{/if}</td>
              <td></td>
            </tr>   
            <tr>
              <th>{translate text='Phone Number'}</th>
              <td>
                {if $driver == "AxiellWebServices"}
                  <input type="text" name="phone_number" id="phone_number" value="{if $profile.phone}{$profile.phone|escape}{/if}" />
                {else}
                  {if $profile.phone}{$profile.phone|escape}{else}-{/if}
                {/if}
              </td>
              <td></td>
            </tr>
            <tr>
              <th>{translate text='Email'}</th>
              <td>
                {if $driver == "AxiellWebServices"}
                  <input type="email" name="email_address" id="email_address" value="{if $profile.email}{$profile.email|escape}{/if}" />
                {else}
                  {if $profile.email}{$profile.email|escape}{else}-{/if}
                {/if}
              </td>
              <td></td>
            </tr>
            <tr>
              <th>{translate text='Group'}</th>
              <td>{$profile.group|escape}</td>
              <td></td>
            </tr> 
            {if $profile.blocks}
            <tr>
              <th>{translate text='Borrowing Blocks'}</th>
              <td colspan="2">
              {foreach from=$profile.blocks item=block name=loop}
                <p class="blockInfo">{$block|escape}</p>
              {/foreach}
              </td>
            </tr>
            {/if}
            {if $driver == "AxiellWebServices"}
              <tr>
                <th><input class="button buttonFinna left" type="submit" value="{translate text='Save Personal Information'}" /></th>
                <td><td>
              </tr>
              <tr>
                <td colspan="3">
                  <a class="edit editAddress" href="#">{translate text="axiell_request_address_change"}</a>
                </td>
              </tr>
            {/if}
          </table>
        </form>
      </div>
      {else}
        {include file="MyResearch/catalog-login.tpl"}
      {/if}
    </div>
    <div id="deleteAccount"><button class="button buttonFinna">{translate text="delete_account_title"}</button></div>
  </div>
</div>
<div class="clear"></div>

<script type="text/javascript">
  {literal}
  $("#deleteAccount button").unbind().click(function(e) {
    var url = path + '/AJAX/JSON_DeleteUser?method=init';
    var dialog = getPageInLightbox(url, "{/literal}{translate text="delete_account_title"}{literal}");
    e.preventDefault();
  });
  $(document).ready(function() {
    $("#email_form").validate();
    $("#personal_form").validate();
    $('.editAddress').click(function(e) {
      var params = {
        'changeAddressRequest': true
      };
      getLightbox('MyResearch', 'Profile', null, null, '{/literal}{translate text="axiell_request_address_change"}{literal}', '', '', '', params);
      e.preventDefault();
    });
  {/literal}
  {if $changePassword}
    {literal}
    $("#password_form").validate();
    $("#newPassword").rules("add", {
        minlength: {/literal}{$changePassword.minLength}{literal},
        maxlength: {/literal}{$changePassword.maxLength}{literal},
        messages: {
            {/literal}minlength: jQuery.format("{translate text="Minimum length `$smarty.ldelim`0`$smarty.rdelim` characters"}"){literal},
            {/literal}maxlength: jQuery.format("{translate text="Maximum length `$smarty.ldelim`0`$smarty.rdelim` characters"}"){literal}
        }
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
  $('.editAddress').click(function(e) {
    var params = {
      'changeAddressRequest': true
    };
    getLightbox('MyResearch', 'Profile', null, null, '{/literal}{translate text="axiell_request_address_change"}{literal}', '', '', '', data);
    e.preventDefault();
  });

  $('.editMessagingSettings').unbind('click').on('click', function(e) {
    var data = {
      'changeMessagingSettingsRequest':true,
    };
    getLightbox('MyResearch', 'Profile', null, null, '{/literal}{translate text="axiell_request_messaging_settings_change"}{literal}', '', '', '', data);
    e.preventDefault();
  });

});
  {/literal}
</script>

<!-- END of: MyResearch/profile.tpl -->
