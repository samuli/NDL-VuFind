<!-- START of: MyResearch/login.tpl -->

{if $offlineMode == "ils-offline"}
  <div class="sysInfo">
    <h2>{translate text="ils_offline_title"}</h2>
    <p><strong>{translate text="ils_offline_status"}</strong></p>
    <p>{translate text="ils_offline_login_message"}</p>
    <p><a href="mailto:{$supportEmail}">{$supportEmail}</a></p>
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
  {if $message}<div class="error" id="errormessage">{$message|translate}</div>{/if}
  <p class="loginInfo grid_15">{translate text="Login information"}</p>
  <div class="loginTitle">
    {translate text='login_choices'}
  </div>

    {if $libraryCard && $authMethod != 'Shibboleth'}
    {assign var=loginNumber value=$loginNumber+1}
  <div class="loginAction">
    <h3>{$loginNumber}. {translate text='login_title_local'}</h3>
    <form method="post" action="{$url}/MyResearch/Home" name="loginForm" id="loginForm">
      <label for="login_username">{translate text='Username'}</label>
      <br class="clear"/>
      <input id="login_username" type="text" name="username" value="{$username|escape}" class="{jquery_validation required='This field is required'}"/>
      <br class="clear"/>
      <label for="login_password">{translate text='Password'}</label>
      <br class="clear"/>
      <input id="login_password" type="password" name="password" class="{jquery_validation required='This field is required'}"/>
      <br class="clear"/>
    {if $loginTargets}
      <select id="login_target" name="login_target" class="{jquery_validation required='Please choose a library'}">
        <option value="">{translate text="Choose library"}</option>
      {foreach from=$loginTargets item=target}
        <option value="{$target}"{if $target == $defaultLoginTarget} selected="selected"{/if}>{translate text=$target prefix='source_'}</option>
      {/foreach}
      </select>
      <br class="clear"/>
    {/if}
      <input class="button buttonFinna" type="submit" name="submit" value="{translate text='Login'}"/>
      {if $followup}<input type="hidden" name="followup" value="{$followup}"/>{/if}
      {if $followupModule}<input type="hidden" name="followupModule" value="{$followupModule}"/>{/if}
      {if $followupAction}<input type="hidden" name="followupAction" value="{$followupAction}"/>{/if}
      {if $recordId}<input type="hidden" name="recordId" value="{$recordId|escape:"html"}"/>{/if}
      {if $extraParams}
        {foreach from=$extraParams item=item}
          <input type="hidden" name="extraParams[]" value="{$item.name|escape}|{$item.value|escape}" />
        {/foreach}
      {/if}
      <div class="clear"></div>
    </form>
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
  </div>
  <div class="loginDescription{$lbSmall}">
    <div class="description">
      <div class="descriptionTitle">{translate text='login_services_desc'}</div> 
      {translate text='login_desc_local_html'}
    </div>
  </div>
  {/if}

  {if $sessionInitiator}
    {assign var=loginNumber value=$loginNumber+1}
    {if $libraryCard}
  <div class="separator{$lbSmall}"><span class="text">{translate text="login_separator"}</span></div>
    {/if}
  <div class="loginAction">
    <h3>{$loginNumber}. {translate text="login_title_shibboleth"}</h3>
    <a href="{$sessionInitiator}">{image src='haka_landscape_medium.gif'}</a>
  </div>
  <div class="loginDescription{$lbSmall}">
    <div class="description">
      <div class="descriptionTitle">{translate text='login_services_desc'}</div> 
      {translate text='login_desc_shibboleth_html'}
    </div>
  </div>
  {/if}

  {if $mozillaPersona}
    {assign var=loginNumber value=$loginNumber+1}
    {if $libraryCard || $sessionInitiator}
  <div class="separator{$lbSmall}"><span class="text">{translate text="login_separator"}</span></div>
    {/if}
  {assign var=followupParams value="#"|explode:$followupAction} 
  <div class="loginAction">
    <h3>{$loginNumber}. {translate text="login_title_email"}</h3>
    <a id="personaLogin" class="persona-login" href="" data-followup="{$followup}" data-followupurl="{$url}/{$followupModule}/{$recordId|escape:"html"}/{$followupParams.0}?submit#{$followupParams.1}"><span>{translate text="Mozilla Persona"}</span></a>
{if $lightbox}
    <script type="text/javascript">
    {literal}
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
    {/literal}
    </script>
{/if}
  </div>
  <div class="loginDescription{$lbSmall}">
    <div class="description">
      <div class="descriptionTitle">{translate text='login_services_desc'}</div> 
      {translate text='login_desc_email_html'}
    </div>
  </div>
  {/if}

</div>
{/if}

<!-- END of: MyResearch/login.tpl -->
