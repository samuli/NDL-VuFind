<!-- START of: login-element.tpl -->
{if !$hideLogin}
<li class="menuLogin menuLogin_{$userLang}" id="loginDetails">
  {if $user}
  <dl class="dropdown dropdownStatic stylingDone">
    <dt><a href="#">{if $mozillaPersonaCurrentUser}{$mozillaPersonaCurrentUser|truncate:20:'...':true:false|escape}
      {elseif $user->lastname || $user->firstname}{if $user->firstname}{assign var=fullname value=$user->firstname|cat:' '|cat:$user->lastname}{else}{assign var=fullname value=$user->lastname}{/if}{$fullname|truncate:20:'...':true:false|escape}{/if}</a></dt>
    <dd>
      <ul class="subNav">
        <li>
          <a class="big account" href="{$path}/MyResearch/Home">
            <span>{translate text="Your Account"}</span>
            <span>{translate text="your_account_info"}</span>
            <span class="value">{$path}/MyResearch/Home</span></a>
        </li>
        {if $mozillaPersonaCurrentUser}
        <li>
          <a id="personaLogout" class="logout" href="">
            <span>{translate text="Log Out"}</span>
            <span> </span>
          </a>
        </li>
        {else}
        <li>
          <a class="logout" href="">
            <span>{translate text="Log Out"}</span>
            <span class="value">{$path}/MyResearch/Logout</span>
          </a>
        </li>
        {/if}

      </ul>
    </dd>
  </dl>
</li>
  
  {else}
  <a href="{$path}/MyResearch/Home"><span id="userId">{translate text="Login"}</span></a>
</li>
  {/if}
{/if}  

<!-- END of: login-element.tpl -->
