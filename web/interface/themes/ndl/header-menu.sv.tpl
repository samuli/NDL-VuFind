<!-- START of: header-menu.sv.tpl -->

<li class="menuHome"><a href="{$path}/" role="menuitem"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout"><a href="{$path}/Content/about" role="menuitem"><span>{translate text='navigation_about'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#">{translate text='navigation_search'}</a></dt>
    <dd>
      <ul class="subNav" role="menu">
        <li><a class="big" href="#">
          <span>Utökad sökning</span>
          <span>Fler sökvillkor och sökning på karta.</span>
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
        <li><a class="big" href="#">
          <span>Bläddra i katalogen</span>
          <span>Bläddra enligt författare, ämne, område, tidsperiod eller tagg.</span>
          <span class="value">{$path}/Browse/Home</span></a>
        </li>
        <li><a class="big" href="#">
          <span>Sökhistorik</span>
          <span>Din sökhistorik enligt session. Om du loggar in kan du spara dina sökningar.</span>
          <span class="value">{$path}/Search/History</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuHelp menuHelp_{$userLang}">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#">{translate text='navigation_help'}</a></dt>
    <dd>
      <ul class="subNav" role="menu">
        <li><a class="big" href="#">
          <span>Söktips</span>
          <span>Detaljerade sökanvisningar.</span>
          <span class="value">{$path}/Content/searchhelp</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>


<li class="menuFeedback"><a href="{$path}/Feedback/Home" role="menuitem"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.sv.tpl -->
