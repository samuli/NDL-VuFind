<!-- START of: header-menu.fi.tpl -->

<li class="menuHome"><a href="{$path}/"><span></span></a></li>

<li class="menuAbout"><a href="{$path}/Content/about"><span>{translate text='navigation_about'}</span></a></li>

<li class="menuSearch menuSearch_{$userLang}"><a href="#"><span>{translate text='navigation_search'}</span></a>
  <ul class="subNav">
    <li>
      <a href="{$url}">
        <span>Haun aloitussivu</span>
        <span>Etusivulta voit helposti aloittaa uuden perushaun.</span>
      </a>    
    </li>
    <li>
      <a href="{$path}/Search/Advanced">
        <span>Tarkennettu haku</span>
        <span>Tarkemmat hakuehdot ja karttahaku</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Browse/Home">
        <span>Selaa luetteloa</span>
        <span>Selaa tagien, tekijän, aiheen, genren, alueen tai aikakauden mukaan.</span>
      </a>
    </li>
    <li>
      <a href="{$path}/Search/History">
        <span>Hakuhistoria</span>
        <span>Istuntokohtainen hakuhistoriasi. Kirjautumalla voit tallentaa hakusi.</span>
      </a>    
    </li>
  </ul>
</li>

<li class="menuHelp menuHelp_{$userLang}"><a href="#"><span>{translate text='navigation_help'}</span></a>
  <ul class="subNav">
    <li>
      <a href="{$path}/Content/searchhelp">
        <span>Hakuohje</span>

        <span>Yksityiskohtaiset ohjeet hakuun.</span>

      </a>
    </li>
  </ul> 
</li>

<li class="menuFeedback"><a href="{$path}/Feedback/Home"><span>{translate text='navigation_feedback'}</span></a></li>

{include file="login-element.tpl"}

<!-- END of: header-menu.fi.tpl -->
