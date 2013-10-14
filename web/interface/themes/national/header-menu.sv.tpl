<!-- START of: header-menu.sv.tpl -->

<li class="menuHome"><a href="{$path}/" role="menuitem"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout"><a href="#"><span>{translate text='navigation_about'}</span><span class="menuArrow"></span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Content/about">
      <span>{translate text="About Finna"}</span>
      <span>{translate text="about_finna_desc"}</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Content/organisations" role="menuitem">
        <span>{translate text="Organisations"}</span>
        <span>{translate text="organisations_desc"}</span>
      </a>
    </li>
  </ul>
</li>    
<li class="menuSearch menuSearch_{$userLang}"><a href="#" aria-haspopup="true"><span>{translate text='Search'}</span><span class="menuArrow"></span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Search/Advanced" role="menuitem">
        <span>{translate text="Advanced Search"}</span>
        <span>{translate text="advanced_search_desc"}</span>
      </a>
    </li>
    {if $dualResultsEnabled}
    <li>
      <a href="{$path}/PCI/Advanced" role="menuitem">
        <span>{translate text="Advanced PCI Search"}</span>
        <span>{translate text="pci_advanced_search_description"}</span>
      </a>
    </li>
    {/if}
    {if $metalibEnabled}
    <li>
      <a href="{$path}/MetaLib/Home" role="menuitem">
        <span>{translate text="MetaLib Search"}</span>
        <span>{translate text="metalib_search_description"}</span>
      </a>
    </li>
    {/if}
    <li>
      <a href="{$path}/Browse/Home" role="menuitem">
        <span>{translate text="Browse the Catalog"}</span>
        <span>{translate text="catalog_desc"}</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Search/History" role="menuitem">
        <span>{translate text="Search History"}</span>
        <span>{translate text="search_history_desc"}</span>
      </a>    
    </li>
  </ul>
</li>

<li class="menuHelp menuHelp_{$userLang}"><a href="{$path}/Content/searchhelp" role="menuitem"><span>{translate text='navigation_search_tips'}</span></a></li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home" role="menuitem"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.sv.tpl -->
