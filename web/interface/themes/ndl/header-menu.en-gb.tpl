<!-- START of: header-menu.en-gb.tpl -->

<li class="menuHome"><a href="{$path}/"><span>&#x2302;</span></a></li>

<li class="menuAbout"><a href="{$path}/Content/about"><span>{translate text='navigation_about'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}"><a href="#"><span>{translate text='navigation_search'}</span></a>
  <ul class="subNav">
    <li>
      <a href="{$url}">
        <span>Search home</span>
        <span>Start a new search from home page.</span>
      </a>    
    </li>
    <li>
      <a href="{$path}/Search/Advanced">
        <span>Advanced search</span>
        <span>More refined search terms and map search.</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Browse/Home">
        <span>Browse the catalogue</span>
        <span>Browse by author, topic, genre, area, era or tags.</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Search/History">
        <span>Search history</span>
        <span>Your session-specific search history. To save your searches, please log in.</span>
      </a>    
    </li>
  </ul>
</li>

<li class="menuHelp menuHelp_{$userLang}"><a href="#"><span>{translate text='navigation_help'}</span></a>
  <ul class="subNav">
    <li>
      <a href="{$path}/Content/searchhelp">
        <span>Search tips</span>
        <span>Detailed search instructions.</span>
      </a>
    </li>
  </ul> 
</li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.en-gb.tpl -->
