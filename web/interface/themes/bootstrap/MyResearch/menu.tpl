<!-- START of: MyResearch/menu.tpl -->

  <h3 class="account"><!--i class="icon-user"></i-->{translate text="Your Account"}</h3>

<!--
  <div class="ui-tabs ui-widget myResearchMenu">
    <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix">
      <li class="active ui-state-default ui-corner-top {if $pageTemplate=="favorites.tpl" || $pageTemplate=="list.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Favorites">{translate text='Favorites'}</a></li>
      <li class="active ui-state-default ui-corner-top {if $pageTemplate=="checkedout.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/CheckedOut">{translate text='Checked Out Items'}</a></li>
      <li class="active ui-state-default ui-corner-top {if $pageTemplate=="holds.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Holds">{translate text='Holds and Requests'}</a></li>
      <li class="active ui-state-default ui-corner-top {if $pageTemplate=="fines.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Fines">{translate text='Fines'}</a></li>
      <li class="active ui-state-default ui-corner-top {if $pageTemplate=="profile.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Profile">{translate text='Profile'}</a></li>
      {* Only highlight saved searches as active if user is logged in: *}
      <li class="active ui-state-default ui-corner-top {if $user && $pageTemplate=="history.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/Search/History?require_login">{translate text='history_saved_searches'}</a></li>
    </ul>
  </div>
-->

  <div class="tabbable myResearchMenu">
    <ul class="nav nav-tabs">
      <li class="{if $pageTemplate=="favorites.tpl" || $pageTemplate=="list.tpl"}active{/if}"><a href="{$url}/MyResearch/Favorites">{translate text='Favorites'}</a></li>
      <li class="{if $pageTemplate=="checkedout.tpl"}active{/if}"><a href="{$url}/MyResearch/CheckedOut">{translate text='Checked Out Items'}</a></li>
      <li class="{if $pageTemplate=="holds.tpl"}active{/if}"><a href="{$url}/MyResearch/Holds">{translate text='Holds and Requests'}</a></li>
      <li class="{if $pageTemplate=="fines.tpl"}active{/if}"><a href="{$url}/MyResearch/Fines">{translate text='Fines'}</a></li>
      <li class="{if $pageTemplate=="profile.tpl"}active{/if}"><a href="{$url}/MyResearch/Profile">{translate text='Profile'}</a></li>
{if $libraryCard}
      <li class="{if $pageTemplate=="accounts.tpl"}active{/if}"><a href="{$url}/MyResearch/Accounts">{translate text='Library Cards'}</a></li>
{/if}
      {* Only highlight saved searches as active if user is logged in: *}
      <li class="{if $user && $pageTemplate=="history.tpl"}active{/if}"><a href="{$url}/Search/History?require_login">{translate text='history_saved_searches'}</a></li>
    </ul>
  </div>

<!-- END of: MyResearch/menu.tpl -->
