<!-- START of: login-element.tpl -->

{if !$hideLogin}
<li class="menuLogin menuLogin_{$userLang}"><a href="{if $user}#{else}{$path}/MyResearch/Home{/if}">
    <span id="userId"{if $user} class="loggedIn"{/if}>{if $user}{if $mozillaPersonaCurrentUser}{$mozillaPersonaCurrentUser|truncate:25:'...':true:false}{elseif $user->lastname || $user->firstname}{if $user->firstname}{$user->firstname}&nbsp;{/if}{$user->lastname}{else}{translate text="Your Account"}{/if}{else}{translate text="Login"}{/if}</span></a>
    <ul class="subNav">
{if !$hideLogin}
    {if $user}
        <li>
            <a class="account" href="{$path}/MyResearch/Home">
                <span>{translate text="Your Account"}</span>
                <span>{translate text="your_account_info"}</span>
            </a>
        </li>
{*
        {if $catalogAccounts}
        <li>
            <span>{translate text="Select Library Card"}</span>
            <form method="post" action="">
              <select id="catalogAccount" name="catalogAccount" title="{translate text="Selected Library Card"}" class="jumpMenu">
                {foreach from=$catalogAccounts item=account}
                  <option value="{$account.id|escape}"{if $account.cat_username == $currentCatalogAccount} selected="selected"{/if}>{$account.account_name|escape}</option>
                {/foreach}
                <option value="new">{translate text="Add"}...</option>
              </select>
            <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
            </form>
        </li>
        {/if}
*}
        {if $mozillaPersonaCurrentUser}
        <li>
            <a id="personaLogout" class="logout" href="">
                <span>{translate text="Log Out"}</span>
                <span> </span>
            </a>
        </li>
        {else}
        <li>
            <a class="logout" href="{$path}/MyResearch/Logout">
                <span>{translate text="Log Out"}</span>
                <span> </span>
            </a>
        </li>
        {/if}
    {/if}
{/if}
    </ul>
</li>
{if $catalogAccounts}
<li class="menuLibCard menuLibCard_{$userLang}">
    <span>{translate text="Select Library Card"} :
<!--
    <ul class="subNav">
    <li>
-->
    <form method="post" action="" style="float:right;">
      <select id="catalogAccount" name="catalogAccount" title="{translate text="Selected Library Card"}" class="jumpMenu">
        {foreach from=$catalogAccounts item=account}
          <option value="{$account.id|escape}"{if $account.cat_username == $currentCatalogAccount} selected="selected"{/if}>{$account.account_name|escape}</option>
        {/foreach}
        <option value="new">{translate text="Add"}...</option>
      </select>
    <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
    </form>
    </span>
<!--
    </li>
    </ul>
-->
</li>
{/if}
{/if}

<!-- END of: login-element.tpl -->
