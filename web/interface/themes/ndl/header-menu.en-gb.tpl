<!-- START of: header-menu.en-gb.tpl -->

<li class="menuHome"><a href="{$path}/" role="menuitem"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout"><a href="{$path}/Content/about" role="menuitem"><span>{translate text='navigation_about'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}"><a href="#" aria-haspopup="true"><span>{translate text='navigation_search'}</span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Search/Advanced" role="menuitem">
        <span>Advanced search</span>
        <span>More refined search terms and map search.</span>
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
        <span>Browse the catalogue</span>
        <span>Browse by author, topic, genre, area, era or tags.</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Search/History" role="menuitem">
        <span>Search history</span>
        <span>Your session-specific search history. To save your searches, please log in.</span>
      </a>    
    </li>
  </ul>
</li>

<li class="menuHelp menuHelp_{$userLang}"><a href="#" aria-haspopup="true"><span>{translate text='navigation_help'}</span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Content/searchhelp" role="menuitem">
        <span>Search tips</span>
        <span>Detailed search instructions.</span>
      </a>
    </li>
  </ul> 
</li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home" role="menuitem"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.en-gb.tpl -->
