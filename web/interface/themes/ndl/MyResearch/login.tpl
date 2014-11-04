<!-- START of: MyResearch/login.tpl -->

{if $offlineMode == "ils-offline"}
  <div class="sysInfo">
    <h2>{translate text="ils_offline_title"}</h2>
    <p><strong>{translate text="ils_offline_status"}</strong></p>
    <p>{translate text="ils_offline_login_message"}</p>
    <p><a href="mailto:{$supportEmail|escape:"html"}">{$supportEmail}</a></p>
  </div>
{elseif $hideLogin}
  <div class="error">{translate text='login_disabled'}</div>
{/if}

{if !$hideLogin}
{if $lightbox}
  {assign var=lbSmall value='Small'}
{/if}
{assign var=loginNumber value=0}

  <div class="contentHeader loginContentHeader"><div class="content"><h1>{translate text='Login'}</h1></div></div>
  <div class="content loginForm">
  <div class="clear"></div>
  {if $message && $message != 'You must be logged in first'}<div class="error" id="errormessage">{$message|translate}</div>{/if}
  <div class="grid_14">
   <p class="loginInfo">{translate text="Login information"}</p>

  {* NDLBlankInclude *}
  {include file='Additions/login-more.tpl'}
  {* /NDLBlankInclude *}

  </div>

  {* NDLBlankInclude *}
  {include file='Additions/login-more.tpl'}
  {* /NDLBlankInclude *}

  <div class="clear"></div>

  {if $sessionInitiator}
    {assign var=loginNumber value=$loginNumber+1}
  <div class="loginAction">
    <h3 class="grid_14">{$loginNumber}. {translate text="login_title_shibboleth"}</h3>
  </div>
  <div class="clear"></div>
  <div class="shibLogin grid_7">
        <a href="{$sessionInitiator}">{image src='haka_landscape_medium.gif'}</a>
  </div>
  <div class="grid_7">
    <div class="loginDescription{$lbSmall}">
    <div class="description {if !$libraryCard}hide{/if}">
      {translate text='login_desc_connectcard_html'}
    </div>
  </div>
  </div>
  <div class="clear"></div>
  <div class="shibText grid_14"><h3>{translate text='login_shibboleth_notification'}</h3></div>
  {/if}
  <div class="clear"></div>
  
  {if $libraryCard && $authMethod != 'Shibboleth'}
    {assign var=loginNumber value=$loginNumber+1}
  <div class="loginAction">
    <h3 class="loginHeader grid_14">{$loginNumber}. {translate text='login_title_local'}</h3>
    <div class="clear"></div>
    <div class="grid_7">
    <form class="libraryLogin" method="post" action="{$url}/MyResearch/Home" name="loginForm" id="loginForm">
  {if count($loginTargets) > 1}
    <label for="login_target">{translate text="Choose library"}</label>
      <br class="clear"/>
      <select id="login_target" name="login_target" class="{jquery_validation required='Please choose a library'}">
        <option value="">{translate text="Choose library"}</option>
      {foreach from=$loginTargets item=target}
        <option value="{$target|escape:"html"}"{if $target == $defaultLoginTarget} selected="selected"{/if}>{translate text=$target prefix='source_'}</option>
      {/foreach}
      </select>
      <br class="clear"/>
  {elseif count($loginTargets) == 1}
		<input type="hidden" value="{$loginTargets[0]|escape:"html"}" name="login_target" />
		<p class="libraryDescription" name="libraryDescription"><strong>{translate text=$loginTargets[0] prefix='source_'}</strong></p>
  {/if}
      <label for="login_username">{translate text='Username'}</label>
      <br class="clear"/>
      <input id="login_username" type="text" name="username" value="{$username|escape}" class="{jquery_validation required='This field is required'}"/>
      <br class="clear"/>
      <label for="login_password">{translate text='Password'}</label>
      <br class="clear"/>
      <input id="login_password" type="password" name="password" class="{jquery_validation required='This field is required'}"/>
      <br class="clear"/>
      <input class="button buttonFinna" type="reset" value="{translate text='confirm_create_account_abort'}"/>
      <input class="button buttonFinna" type="submit" name="submit" value="{translate text='Login'}"/>

      {if $followup}<input type="hidden" name="followup" value="{$followup|escape:"html"}"/>{/if}
      {if $followupModule}<input type="hidden" name="followupModule" value="{$followupModule|escape:"html"}"/>{/if}
      {if $followupAction}<input type="hidden" name="followupAction" value="{$followupAction|escape:"html"}"/>{/if}
      {if $recordId}<input type="hidden" name="recordId" value="{$recordId|escape:"html"}"/>{/if}
      {if $extraParams}
        {foreach from=$extraParams item=item}
          <input type="hidden" name="extraParams[]" value="{$item.name|escape}|{$item.value|escape}" />
        {/foreach}
      {/if}
    </form>
    </div>
    <script type="text/javascript">
      {literal}
      $(document).ready(function() {
        $("#loginForm").validate();      
        $("input").one("keydown", function () { 
          $("#errormessage").css({"visibility":"hidden"});
        });
      });
      {/literal}
    </script>
    {if $authMethod == 'DB'}<a class="new_account" href="{$url}/MyResearch/Account">{translate text='Create New Account'}</a>{/if}
  
  
  <div class="loginDescription{$lbSmall} grid_7">
    <div class="description">
      {translate text='login_desc_local_html'}
    </div>
  </div>
 </div>
  {/if}
  <div class="clear"></div>

  {if $libraryCard}
    {if !$lightbox}
      {js filename="lightbox.js" }
      {js filename="rc4.js" }
    {/if}
    <script type="text/javascript">
    trConfirmCreateAccountBtn = '{translate text="confirm_create_account_continue"}';

    {literal}
    $(document).ready(function() {        
       registerAjaxLogin($('.loginForm'), false);
    });
    </script>
    {/literal}    
  {/if}
 
  {if $mozillaPersona}
    {assign var=loginNumber value=$loginNumber+1}
    {if $libraryCard || $sessionInitiator}
    {/if}
  {assign var=followupParams value="#"|explode:$followupAction} 
  <div class="loginAction">
    <h3 class="grid_14">{$loginNumber}. {translate text="login_title_email"}</h3><div class="clear"></div>
     <div class="personaLogin grid_7">
     {if $followupModule == 'PCI' || $followupModule == 'MetaLib'}
         <a id="personaLogin" class="persona-login" href="" data-followup="{$followup|escape:"html"}" data-followupurl="{$url}/{$followupModule|escape:"url"}/{$followupAction|escape:"url"}?id={$recordId|escape:"url"}&submit"><span>{translate text="Mozilla Persona"}</span></a>
     {else}
       {if $followup === 'SaveSearch'}
         {* SaveSearch special case. Note that $recordId is already urlencoded, so just escape html *}
         <a id="personaLogin" class="persona-login" href="" data-followup="{$followup|escape:"html"}" data-followupurl="{$url}/{$followupModule|escape:"url"}/{$followupAction|escape:"url"}?{$recordId|escape:"html"}"><span>{translate text="Mozilla Persona"}</span></a>
       {else}
    	   <a id="personaLogin" class="persona-login" href="" data-followup="{$followup|escape:"html"}" data-followupurl="{$url}/{$followupModule|escape:"url"}/{$recordId|escape:"url"}/{$followupParams.0|escape:"url"}?submit#{$followupParams.1|escape:"url"}"><span>{translate text="Mozilla Persona"}</span></a>
       {/if}
     {/if}	

   {if $lightbox}
   {literal}
   <script type="text/javascript">
    $(document).ready(function() {        
        $.ajax({
            url: 'https://login.persona.org/include.js',
            dataType: 'script',
            success: function() {
                {/literal}
                mozillaPersonaSetup({if $mozillaPersonaCurrentUser}"{$mozillaPersonaCurrentUser}"{else}null{/if}, {if $mozillaPersonaAutoLogout}true{else}false{/if});
                {literal}
            }
        });
    });
    </script>
    {/literal}
    {/if}

   </div>
  </div>
  <div class="grid_7">
   <div class="loginDescription{$lbSmall}">
    <div class="description">
      {translate text='login_desc_email_html'}
      {if $libraryCard}{translate text='login_desc_connectcard_html'}{/if}
    </div>
   </div>
  </div>
  <div class="clear"></div>
</div>
  {/if}

{/if}

<!-- END of: MyResearch/login.tpl -->
