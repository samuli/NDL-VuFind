<!-- START of: header.tpl -->

{if $bookBag}
  {js filename="cart.js"}
  {assign var=bookBagItems value=$bookBag->getItems()}
{/if}
{assign var=logoUrl value=""}
{if "homelogo.$userLang.tpl"|template_full_path}
  {include file="homelogo.$userLang.tpl" assign=logoUrl}
{/if}
{if !$logoUrl|trim}{include file="homelogo.tpl" assign=logoUrl}{/if}

  <div class="grid_24 drop">
    <a id="logo" href="{$url}" title="{translate text='Home'}">
      {image src=$logoUrl}
    </a>
  </div>

<div id="headerSeparator" class="grid_24"></div>

<div id="headerBottom" class="grid_24">
  {if $showBreadcrumbs}
  <div class="content">
      <div class="breadcrumbs" role="navigation" aria-label="{translate text='Breadcrumbs'}">
        <div class="breadcrumbinner">
          <a href="{$url}">{translate text="Home page"}</a><span></span>
          {if $module}{include file="$module/breadcrumbs.tpl"}{/if}
        </div>
      </div>
  </div>
  {/if}
  
  {if !$showTopSearchBox}
      {include file="Search/home-header.tpl"}
  {/if}
  <div id="searchFormHeader">
    <div class="searchbox">
      {if $pageTemplate != 'advanced.tpl' && $searchType != 'PCIAdvanced'}
        {if $module=="Summon" || $module=="PCI"
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
