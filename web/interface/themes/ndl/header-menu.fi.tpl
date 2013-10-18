<!-- START of: header-menu.fi.tpl -->

<li class="menuHome"><a href="{$path}/" role="menuitem"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout"><a href="{$path}/Content/about"><span style="line-height: 1.5em;">{translate text='navigation_about'}</span></a></li>

<li class="menuAbout menuAbout_{$userLang}">
  <ul class="dropdown dropdownStatic stylingDone">
    <li><a href="{$path}/Content/about">{translate text='navigation_about'}</a></li>
  </ul>
</li>


<li class="menuSearch menuSearch_{$userLang}">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#">{translate text='navigation_search'}</a></dt>
    <dd>
      <ul class="subNav" role="menu">
        <li><a class="big" href="#">
          <span>Tarkennettu haku</span>
          <span>Tarkemmat hakuehdot ja karttahaku</span>
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
          <span>Selaa luetteloa</span>
          <span>Selaa tagien, tekijän, aiheen, genren, alueen tai aikakauden mukaan.</span>
          <span class="value">{$path}/Browse/Home</span></a>
        </li>
        <li><a class="big" href="#">
          <span>Hakuhistoria</span>
          <span>Istuntokohtainen hakuhistoriasi. Kirjautumalla voit tallentaa hakusi.</span>
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
          <span>Hakuohje</span>
          <span>Yksityiskohtaiset ohjeet hakuun.</span>
          <span class="value">{$path}/Content/searchhelp</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home" role="menuitem"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.fi.tpl -->
