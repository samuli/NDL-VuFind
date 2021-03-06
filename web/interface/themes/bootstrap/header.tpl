<!-- START of: header.tpl -->

{js filename="jquery.cookie.js"}

{if $bookBag}
  {js filename="cart.js"}
  {assign var=bookBagItems value=$bookBag->getItems()}
{/if}

<div id="loginHeader" class="row-fluid{if !$showTopSearchBox} text-right{/if}"> <!-- 2.1 -->
{if $pageTemplate != 'advanced.tpl'}
  <a href="{$path}/Content/searchhelp" class="badge pull-left showSearchHelp" title="{translate text="Search Tips"}"><i class="icon-info-sign"></i>&nbsp;{translate text="Search Tips"}</a>
{/if}
{if !$hideLogin}
  {if $catalogAccounts}
    <form method="post" action="#" class="hidden-phone">
  {/if} 
    <ul id="logoutOptions" class="hidden-phone inline{if $showTopSearchBox} pull-right{/if}{if !$user} hide{/if}">
    {if $catalogAccounts}
      <li><span class="label label-info libraryCardBadge">{translate text="Select Library Card"}:</span> 
      <select id="catalogAccount" name="catalogAccount" title="{translate text="Selected Library Card"}" class="selectpicker jumpMenu" data-style="btn btn-mini">
      {foreach from=$catalogAccounts item=account}
        <option value="{$account.id|escape}"{if $account.cat_username == $currentCatalogAccount} selected="selected"{/if}>{$account.account_name|truncate:15:'...':true:false|escape}</option>
      {/foreach}
        <option value="new">{translate text="Add"}...</option>
      </select>
      <noscript><input type="submit" value="{translate text="Set"}" /></noscript></li>
    {/if}
      <li><a class="badge account" href="{$path}/MyResearch/Home" title="{translate text="Your Account"}"><i class="icon-user"></i>&nbsp;{if $mozillaPersonaCurrentUser}{$mozillaPersonaCurrentUser|truncate:20:'...':true:false|escape}
      {elseif $user->lastname || $user->firstname}{if $user->firstname}{assign var=fullname value=$user->firstname|cat:' '|cat:$user->lastname}{else}{assign var=fullname value=$user->lastname}{/if}{$fullname|truncate:20:'...':true:false|escape}{else}{translate text="Your Account"}{/if}</a></li>

    {if $mozillaPersonaCurrentUser}
      <li><a id="personaLogout" class="badge logout" title="{translate text="Log Out"}" href=""><i class="icon-arrow-left"></i>&nbsp;{translate text="Log Out"}</a></li>
    {else}
      <li><a class="badge logout" href="{$path}/MyResearch/Logout" title="{translate text="Log Out"}"><i class="icon-arrow-left"></i>&nbsp;{translate text="Log Out"}</a></li>
    {/if}
    </ul>
    <ul id="loginOptions" class="hidden-phone inline{if $showTopSearchBox} pull-right{/if}{if $user} hide{/if}">
    {if $authMethod == 'Shibboleth'}
      <li><a class="badge login" href="{$sessionInitiator}" title="{translate text="Institutional Login"}">{translate text="Institutional Login"}</a></li>
    {else}
      <li><a href="{$path}/MyResearch/Home" class="badge login" title="{translate text="Login"}">&nbsp;{translate text="Login"}</a></li>
    {/if}
    </ul>
  {if $catalogAccounts}
    </form>
  {/if} 
{/if} {* /!$hideLogin *}
</div> <!-- /2.1 -->

{include file="homelogo.tpl" assign=logoUrl}
{* if $showTopSearchBox*}

{* This is a temporary solution: assign specific id for MetaLib, all others can use the default logo *}
{* <!--
<div class="row-fluid">
<div id="logoHeader{if $module=='MetaLib'}MetaLib{/if}" class="span4 text-center">
  <a id="logo" href="{$url}{if $module=='MetaLib'}/MetaLib/Home{/if}" title="{translate text="Home"}">{image src=$logoUrl}</a>
</div>

<div id="searchFormHeader" class="span6">

  <div class="row-fluid">
  {if $pageTemplate != 'advanced.tpl'}
    {if $module=="Summon" || $module=="EBSCO" || $module=="PCI" || $module=="WorldCat" || $module=="Authority" || $module=="MetaLib"}
      {include file="`$module`/searchbox.tpl"}
    {else}
      {include file="Search/searchbox.tpl"}
    {/if}
  {/if}
  </div>
</div>
</div>
{else}
--> *}
<div class="row-fluid text-center{* searchHome*}"> <!-- 2.4 -->

  {if $offlineMode == "ils-offline"}
  <div class="span12 alert alert-error text-left sysInfo">
    <h3>{translate text="ils_offline_title"}</h3>
    <p><strong>{translate text="ils_offline_status"}</strong></p>
    <p>{translate text="ils_offline_home_message"}</p>
    <p><a href="mailto:{$supportEmail}">{$supportEmail}</a></p>
  </div>
  {/if}
  <div class="span12 text-center{* searchHomeLogo{if $module=='MetaLib'} searchHomeLogoMetaLib{/if*}">
  {*if $showTopSearchBox*}
    <a id="logo" href="{$url}{if $module=='MetaLib'}/MetaLib/Home{elseif $module=='PCI'}/PCI/Home{/if}" title="{if $module=='MetaLib'}{translate text="MetaLib Search"}: {elseif $module=='PCI'}{translate text="PCI Search"}: {/if}{translate text="Home"}">{image src=$logoUrl}</a>
  {*else}
    <span id="logo">{image src=$logoUrl}</span>
  {/if*}
  </div>
  {if !$showTopSearchBox}
  <div class="row-fluid">
    {if !$error}    
    <div class="span12 blurbLineWrapper lead">
      {include file="Search/home-header.tpl"}
    </div>
    {/if}
  </div>
  {/if}
</div> <!-- /2.4 -->

<div class="row-fluid searchHomeForm"> <!-- 2.5 -->
  {if $module=="Summon" || $module=="PCI" || $module=="WorldCat" || $module=="Authority" || $module=="MetaLib"}
    {include file="`$module`/searchbox.tpl"}
  {else}
    {include file="Search/searchbox.tpl"}
  {/if}
</div> <!-- /2.5 -->

{*/if*} {* /$showTopSearchBox *}

<!-- END of: header.tpl -->
