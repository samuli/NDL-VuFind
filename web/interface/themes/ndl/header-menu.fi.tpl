<!-- START of: header-menu.fi.tpl -->

<li class="menuHome"><a href="{$path}/" role="menuitem"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout"><a href="{$path}/Content/about"><span>{translate text='navigation_about'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}"><a href="#" aria-haspopup="true"><span>{translate text='navigation_search'}</span><span class="menuArrow"></span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Search/Advanced" role="menuitem">
        <span>Tarkennettu haku</span>
        <span>Tarkemmat hakuehdot ja karttahaku</span>
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
        <span>Selaa luetteloa</span>
        <span>Selaa tagien, tekijän, aiheen, genren, alueen tai aikakauden mukaan.</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Search/History" role="menuitem">
        <span>Hakuhistoria</span>
        <span>Istuntokohtainen hakuhistoriasi. Kirjautumalla voit tallentaa hakusi.</span>
      </a>    
    </li>
  </ul>
</li>

<li class="menuHelp menuHelp_{$userLang}"><a href="#" aria-haspopup="true"><span>{translate text='navigation_help'}</span><span class="menuArrow"></span></a>
  <ul class="subNav" role="menu">
    <li>
      <a href="{$path}/Content/searchhelp" role="menuitem">
        <span>Hakuohje</span>

        <span>Yksityiskohtaiset ohjeet hakuun.</span>

      </a>
    </li>
  </ul> 
</li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home" role="menuitem"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.fi.tpl -->
