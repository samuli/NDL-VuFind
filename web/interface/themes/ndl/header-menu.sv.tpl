<!-- START of: header-menu.sv.tpl -->

<li class="menuHome"><a href="{$path}/" role="menuitem"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout"><a href="{$path}/Content/about" role="menuitem"><span>{translate text='navigation_about'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}"><a href="#" aria-haspopup="true"><span>{translate text='navigation_search'}</span><span class="menuArrow"></span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Search/Advanced" role="menuitem">
        <span>Utökad sökning</span>
        <span>Fler sökvillkor och sökning på karta</span>
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
        <span>Bläddra i katalogen</span>
        <span>Bläddra enligt författare, ämne, område, tidsperiod eller tagg.</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Search/History" role="menuitem">
        <span>Sökhistorik</span>
        <span>Din sökhistorik enligt session. Om du loggar in kan du spara dina sökningar.</span>
      </a>    
    </li>
  </ul>
</li>

<li class="menuHelp menuHelp_{$userLang}"><a href="#" aria-haspopup="true"><span>{translate text='navigation_help'}</span><span class="menuArrow"></span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Content/searchhelp" role="menuitem">
        <span>Söktips</span>
        <span>Detaljerade sökanvisningar</span>
      </a>
    </li>
  </ul> 
</li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home" role="menuitem"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.sv.tpl -->
