{*
<br /><a class="btn btn-info" href="{$url}"><i class="icon-search icon-white"></i><br />Haku</a>
*}
<a class="btn btn-info" href="{$path}/Search/Advanced" style="line-height: 15px;"><i class="icon-zoom-in icon-white"></i><br />{if $userLang=='fi'}Tark.{elseif $userLang=='sv'}Utö.{else}Adv.{/if} {translate text="Search"}</a>
{if $pciEnabled}
  <br /><a class="btn btn-info" href="{$path}/PCI/Advanced" style="line-height: 15px;"><i class="icon-zoom-in icon-white"></i><br />{if $userLang=='fi'}Tark.{elseif $userLang=='sv'}Utö.{else}Adv.{/if} {translate text="PCI Search"}</a>
{/if}
{if $metalibEnabled}
  <br /><a class="btn btn-info" href="{$path}/MetaLib/Home">{image src=icon-nelli-white.png}{if $userLang=='fi'}monihaku{elseif $userLang=='sv'}metasökning{else}Metasearch{/if}</a>
{/if}
<br /><a class="btn btn-info" href="{$path}/Search/History"{if $userLang == 'en-gb'} style="line-height: 15px;"{/if}><i class="icon-list-alt icon-white"></i><br />{translate text="Search History"}</a>
<br /><a class="btn btn-info" href="{$path}/Browse/Home"><i class="icon-eye-open icon-white" ></i><br />{translate text="Browse"}</a>
{if !$hideLogin}
  {if $user}
    <br /><a class="btn btn-info" href="{$path}/MyResearch/Home"><i class="icon-user icon-white"></i><br />{translate text="Your Account"}</a>
    {if $mozillaPersonaCurrentUser}
      <br /><a id="personaLogout" class="btn btn-info" href=""><i class="icon-arrow-left icon-white"></i><br />{translate text="Log Out"}</a>
    {else}
      <br /><a class="btn btn-info" href="{$path}/MyResearch/Logout"><i class="icon-arrow-left icon-white"></i><br />{translate text="Log Out"}</a>
    {/if}
  {/if}
  {if !$user}
    {if $authMethod == 'Shibboleth'}
      <br /><a class="btn btn-info" href="{$sessionInitiator}" style="line-height: 15px;"><i class="icon-arrow-right icon-white"></i><br />{translate text="Institutional Login"}</a>
    {else}
      <br /><a class="btn btn-info" href="{$path}/MyResearch/Home" style="line-height: 15px;"><i class="icon-arrow-right icon-white"></i><br />{translate text="Login"}</a>
    {/if}
  {/if}
{/if}
<br /><a class="btn btn-info" href="{$path}/Content/searchhelp"><i class="icon-info-sign icon-white"></i><br />{translate text="Search Tips"}</a>

