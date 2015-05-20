<!-- START of: header-menu.en-gb.tpl -->

<li class="menuHome" tabindex="0"><a href="{$path}/" id="navHome" aria-label="{translate text='Home page'}"><span>{translate text='Home page'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}" tabindex="0" aria-haspopup="true">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#" id="navSearch">{translate text='navigation_search'}</a></dt>
    <dd>
      <ul class="subNav" id="subNavSearch" role="menu">
        <li role="menuitem"><a class="big" href="#" id="menuSearchLink">
          <span>Advanced search</span>
          <span>More refined search terms and map search</span>
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
          <span>Browse the catalogue</span>
          <span>Browse by author, topic, genre, area, era or tags</span>
          <span class="value">{$path}/Browse/Home</span></a>
        </li>
        <li role="menuitem"><a class="big" href="#">
          <span>Search history</span>
          <span>Your session-specific search history. To save your searches, please log in.</span>
          <span class="value">{$path}/Search/History</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuAbout" tabindex="0" aria-haspopup="true">
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#" id="navSearch">{translate text='navigation_aboutus'}</a></dt>
    <dd>
      <ul class="subNav" id="subNavSearch" role="menu">
        <li role="menuitem"><a class="big" href="#">
          <span>{translate text='navigation_aboutus'}</span>
          <span>De crudelitate et pietate etan sit melius amari quam timerivel et contra</span>
          <span class="value">{$path}/Content/about</span></a>
        </li>
        <li><a class="big" href="#">
          <span>{translate text="navigation_about_finna"}</span>
          <span>{translate text="navigation_about_finna_desc"}</span>
          <span class="value">{$path}/Content/aboutfinna</span></a>
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
          <span>Search tips</span>
          <span>Detailed search instructions</span>
          <span class="value">{$path}/Content/searchhelp</span></a>
        </li>
      </ul>
    </dd>
  </dl>
</li>

<li class="menuFeedback" tabindex="0"><a href="{$path}/Feedback/Home" id="navFeedback"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.en-gb.tpl -->
