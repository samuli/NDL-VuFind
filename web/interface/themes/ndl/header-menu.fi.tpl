<!-- START of: header-menu.fi.tpl -->

<li class="menuHome" tabindex="0"><a href="{$path}/" id="navHome" aria-labelled-by="{translate text='Home page'}"><span>{translate text='Home page'}</span></a></li>

<li class="menuAbout" tabindex="0"><a href="{$path}/Content/about" id="navAbout"><span style="line-height: 1.5em;">{translate text='navigation_about'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}" tabindex="0" aria-haspopup="true">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#" id="navSearch">{translate text='navigation_search'}</a></dt>
    <dd>
      <ul class="subNav" id="subNavSearch" role="menu">
        <li role="menuitem"><a class="big" href="#" id="menuSearchLink">
          <span>Tarkennettu haku</span>
          <span>Tarkemmat hakuehdot ja karttahaku</span>
          <span class="value">{$path}/Search/Advanced</span></a>
        </li>
        {if $dualResultsEnabled}
        <li role="menuitem">
          <a class="big" href="#">
          <span>{translate text="Advanced PCI Search"}</span>
          <span>{translate text="pci_advanced_search_description"}</span>
          <span class="value">{$path}/PCI/Advanced</span></a>
        </li>
        {/if}
        {if $metalibEnabled}
        <li role="menuitem">
          <a class="big" href="#">
          <span>{translate text="MetaLib Search"}</span>
          <span>{translate text="metalib_search_description"}</span>
          <span class="value">{$path}/MetaLib/Home</span></a>
        </li>
        {/if}
        <li role="menuitem"><a class="big" href="#">
          <span>Selaa luetteloa</span>
          <span>Selaa avainsanojen, tekijän, aiheen, genren, alueen tai aikakauden mukaan.</span>
          <span class="value">{$path}/Browse/Home</span></a>
        </li>
        <li role="menuitem"><a class="big" href="#">
          <span>Hakuhistoria</span>
          <span>Istuntokohtainen hakuhistoriasi. Kirjautumalla voit tallentaa hakusi.</span>
          <span class="value">{$path}/Search/History</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuHelp menuHelp_{$userLang}" tabindex="0" aria-haspopup="true">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#" id="navHelp">{translate text='navigation_help'}</a></dt>
    <dd>
      <ul class="subNav" id="subNavHelp">
        <li><a class="big" href="#">
          <span>Hakuohje</span>
          <span>Yksityiskohtaiset ohjeet hakuun</span>
          <span class="value">{$path}/Content/searchhelp</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuFeedback" tabindex="0"><a href="{$path}/Feedback/Home" id="navFeedback"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.fi.tpl -->
