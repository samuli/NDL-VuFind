<!-- START of: header-menu.en_gb.tpl -->

<li class="menuHome"><a href="{$path}/" role="menuitem"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout menuAbout_{$userLang}">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#">{translate text='navigation_about'}</a></dt>
    <dd>
      <ul class="subNav" role="menu">
        <li><a class="big" href="#">
          <span>{translate text="About Finna"}</span>
          <span>{translate text="about_finna_desc"}</span>
          <span class="value">{$path}/Content/about</span></a>
        </li>
        <li><a class="big" href="#">
          <span>{translate text="Organisations"}</span>
          <span>{translate text="organisations_desc"}</span>
          <span class="value">{$path}/Content/organisations</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuSearch menuSearch_{$userLang}">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#">{translate text='navigation_search'}</a></dt>
    <dd>
      <ul class="subNav" role="menu">
        <li><a class="big" href="#">
          <span>{translate text="Advanced Search"}</span>
          <span>{translate text="advanced_search_desc"}</span>
          <span class="value">{$path}/Search/Advanced</span></a>
        </li>
        {if $dualResultsEnabled}
        <li>
          <a class="big" href="#">
          <span>{translate text="Advanced PCI Search"}</span>
          <span>{translate text="pci_advanced_search_description"}</span>
          <span class="value">{$path}/PCI/Advanced</span></a>
        </li>
        {/if}
        {if $metalibEnabled}
        <li>
          <a class="big" href="#">
          <span>{translate text="MetaLib Search"}</span>
          <span>{translate text="metalib_search_description"}</span>
          <span class="value">{$path}/MetaLib/Home</span></a>
        </li>
        {/if}
         <li>
          <a class="big" href="#">
          <span>{translate text="Browse the Catalog"}</span>
          <span>{translate text="catalog_desc"}</span>
          <span class="value">{$path}/Browse/Home</span></a>
        </li>
        <li><a class="big" href="#">
          <span>{translate text="Search History"}</span>
          <span>{translate text="search_history_desc"}</span>
          <span class="value">{$path}/Search/History</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuHelp menuHelp_{$userLang}"><a href="{$path}/Content/searchhelp" role="menuitem"><span>{translate text='navigation_search_tips'}</span></a></li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home" role="menuitem"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.en_gb.tpl -->
