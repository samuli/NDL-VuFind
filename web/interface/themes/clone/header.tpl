<!-- START of: header.tpl -->

{if $bookBag}
  {js filename="cart.js"}
  {assign var=bookBagItems value=$bookBag->getItems()}
{/if}

<div id="headerTopFixed" class="clearfix">
    
  <div class="grid_8">

  </div>
  
  <div class="grid_12">
{*
  <ul id="headerMenu">
    {include file="header-menu.$userLang.tpl"}
  </ul>
*}
  </div>
    
  <div class="grid_4">
{*
    <div class="lang">
      {if is_array($allLangs) && count($allLangs) > 1}
      <ul>
        {foreach from=$allLangs key=langCode item=langName}
          {if $userLang != $langCode}
            <li><a href="{$fullPath|removeURLParam:'lng'|addURLParams:"lng=$langCode"|encodeAmpersands}">
              {translate text=$langName}</a>
            </li>
          {/if}
        {/foreach}
      </ul>
      {/if}
    </div>
*}
   </div>
</div>

  <div class="grid_24 drop">
    <a id="logo" href="{$url}" title="{translate text="Home"}"></a>
  </div>

<div id="headerSeparator" class="grid_24"></div>

<div id="headerBottom" class="grid_24">
  {if $showBreadcrumbs}
  <div class="content">
    <div class="grid_24">
      <div class="breadcrumbs">
        <div class="breadcrumbinner">
          <a href="{$url}">{translate text="Home"}</a><span></span>
          {include file="$module/breadcrumbs.tpl"}
        </div>
      </div>
    </div>
  </div>
  {/if}
  
  {if !$showTopSearchBox}
      {include file="Search/home-header.tpl"}
  {/if}
  <div id="searchFormHeader">
    <div class="searchbox">
      {if $pageTemplate != 'advanced.tpl'}
        {if $module=="Summon" || $module=="EBSCO" || $module=="PCI" 
          || $module=="WorldCat"  || $module=="Authority" || $module=="MetaLib"}
          {include file="`$module`/searchbox.tpl"}
        {else} 
          {include file="Search/searchbox.tpl"}
        {/if}
      {/if}
    </div>
  </div>
</div>
    
<!-- END of: header.tpl -->
