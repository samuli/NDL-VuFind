<!-- START of: header.tpl -->

{js filename="jquery.cookie.js"}

{if $bookBag}
  {js filename="cart.js"}
  {assign var=bookBagItems value=$bookBag->getItems()}
{/if}

<div id="loginHeader" class="hidden-phone row-fluid{if !$showTopSearchBox} text-right{/if}"> <!-- 2.1 -->

{if !$hideLogin}
  {if $catalogAccounts}
    <form method="post" action="">
  {/if} 
    <ul id="logoutOptions" class="inline{if $showTopSearchBox} pull-right{/if}{if !$user} hide{/if}">
    {if $catalogAccounts}
      <li><span class="badge badge-info libraryCardBadge">{translate text="Select Library Card"}:</span> 
      <select id="catalogAccount" name="catalogAccount" title="{translate text="Selected Library Card"}" class="selectpicker jumpMenu" data-style="btn btn-mini">
      {foreach from=$catalogAccounts item=account}
        <option value="{$account.id|escape}"{if $account.cat_username == $currentCatalogAccount} selected="selected"{/if}>{$account.account_name|escape}</option>
      {/foreach}
        <option value="new">{translate text="Add"}...</option>
      </select>
      <noscript><input type="submit" value="{translate text="Set"}" /></noscript></li>
    {/if}
      <li><i class="icon-user"></i>&nbsp;<a class="account" href="{$path}/MyResearch/Home">{translate text="Your Account"}</a></li>

    {if $mozillaPersonaCurrentUser}
      <li><i class="icon-arrow-left"></i>&nbsp;<a id="personaLogout" class="logout" href="">{translate text="Log Out"}</a></li>
    {else}
      <li><i class="icon-arrow-left"></i>&nbsp;<a class="logout" href="{$path}/MyResearch/Logout">{translate text="Log Out"}</a></li>
    {/if}
    </ul>
    <ul id="loginOptions" class="inline{if $showTopSearchBox} pull-right{/if}{if $user} hide{/if}">
    {if $authMethod == 'Shibboleth'}
      <li><a class="login" href="{$sessionInitiator}">{translate text="Institutional Login"}</a></li>
    {else}
      <li><a href="{$path}/MyResearch/Home">{translate text="Login"}</a></li>
    {/if}
    </ul>
</div> <!-- /2.1 -->
  {if $catalogAccounts}
    </form>
  {/if} 
{/if} {* /!$hideLogin *}

{include file="homelogo.tpl" assign=logoUrl}
{if $showTopSearchBox}

{* This is a temporary solution: assign specific id for MetaLib, all others can use the default logo *}
<div class="row-fluid">
<div id="logoHeader{if $module=='MetaLib'}MetaLib{/if}" class="span4 text-center"> <!-- 2.2 -->
  <a id="logo{if $module=='MetaLib'}MetaLib{/if}" href="{$url}{if $module=='MetaLib'}/MetaLib/Home{/if}" title="{translate text="Home"}">{image src=$logoUrl}</a>
</div> <!-- /2.2 -->

<div id="searchFormHeader" class="span6"> <!-- 2.3 -->

  <div class="row-fluid">
  {if $pageTemplate != 'advanced.tpl'}
    {if $module=="Summon" || $module=="EBSCO" || $module=="PCI" || $module=="WorldCat" || $module=="Authority" || $module=="MetaLib"}
      {include file="`$module`/searchbox.tpl"}
    {else}
      {include file="Search/searchbox.tpl"}
    {/if}
  {/if}
  </div>
</div> <!-- /2.3 -->
</div>
{else}

<div class="row-fluid searchHome"> <!-- 2.4 -->

  {if $offlineMode == "ils-offline"}
  <div class="span12 sysInfo">
    <h2>{translate text="ils_offline_title"}</h2>
    <p><strong>{translate text="ils_offline_status"}</strong></p>
    <p>{translate text="ils_offline_home_message"}</p>
    <p><a href="mailto:{$supportEmail}">{$supportEmail}</a></p>
  </div>
  {/if}
  <div class="span12 text-center searchHomeLogo{if $module=='MetaLib'} searchHomeLogoMetaLib{/if}">
    <span id="logo{if $module=='MetaLib'}MetaLib{/if}">{image src=$logoUrl}</span>
  </div>
</div> <!-- /2.4 -->

<div class="row-fluid searchHomeForm"> <!-- 2.5 -->
  {if $module=="Summon" || $module=="EBSCO" || $module=="PCI" || $module=="WorldCat" || $module=="Authority" || $module=="MetaLib"}
    {include file="`$module`/searchbox.tpl"}
  {else}
    {include file="Search/searchbox.tpl"}
  {/if}
</div> <!-- /2.5 -->

{/if} {* /$showTopSearchBox *}

<!-- END of: header.tpl -->
