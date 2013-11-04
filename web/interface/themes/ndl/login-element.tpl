<!-- START of: login-element.tpl -->
{if !$hideLogin}
<li class="menuLogin menuLogin_{$userLang}" id="loginDetails">
  {if $user}
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#">{if $mozillaPersonaCurrentUser}{$mozillaPersonaCurrentUser|truncate:20:'...':true:false|escape}
      {elseif $user->lastname || $user->firstname}{if $user->firstname}{assign var=fullname value=$user->firstname|cat:' '|cat:$user->lastname}{else}{assign var=fullname value=$user->lastname}{/if}{$fullname|truncate:20:'...':true:false|escape}{/if}</a></dt>
    <dd>
      <ul class="subNav" role="menu">
        <li>
          <a class="big account" href="{$path}/MyResearch/Home">
            <span>{translate text="Your Account"}</span>
            <span>{translate text="your_account_info"}</span>
            <span class="value">{$path}/MyResearch/Home</a></span>
        </li>
        {if $mozillaPersonaCurrentUser}
        <li>
          <a id="personaLogout" class="logout" href="">
            <span>{translate text="Log Out"}</span>
            <span> </span>
          </a>
        </li>
        {else}
        <li>
          <a class="logout" href="">
            <span>{translate text="Log Out"}</span>
            <span class="value">{$path}/MyResearch/Logout</span>
          </a>
        </li>
      {/if}

      </ul>
    </dd>
  </dl>

  {if $catalogAccounts}
  <li class="menuLibCard menuLibCard_{$userLang}">
    <span>{translate text="Select Library Card"} :
    </span>
    <form id="catalogAccountForm" method="post" action="" style="float:right;">
      <select id="catalogAccount" name="catalogAccount" title="{translate text="Selected Library Card"}" class="jumpMenu">
        {foreach from=$catalogAccounts item=account}
        <option value="{$account.id|escape}"{if $account.cat_username == $currentCatalogAccount} selected="selected"{/if}>{$account.account_name|truncate:15:'...':true:false|escape}</option>
        {/foreach}
        <option value="new">{translate text="Add"}...</option>
      </select>
      <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
    </form>
  </li>
  {/if}
  
  {else}
  <a href="{$path}/MyResearch/Home"><span id="userId">{translate text="Login"}</span></a>
  {/if}
</li>  
{/if}  

<!-- END of: login-element.tpl -->
