<!-- START of: MyResearch/menu.tpl -->

  <div class="myresearchHeader">
  <div class="content">
    <div class="grid_24"><h1>{translate text="Your Account"}</h1></div>
  </div>
  </div>

  <div class="ui-tabs ui-widget myResearchMenu">
    <div class="content">
      <div class="grid_24">
      <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix">
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="favorites.tpl" || $pageTemplate=="list.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Favorites">{translate text='Favorites'}</a></li>
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="checkedout.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/CheckedOut">{translate text='Checked Out Items'}</a></li>
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="holds.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Holds">{translate text='Holds and Requests'}</a></li>
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="fines.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Fines">{translate text='Fines'}</a></li>
        {if $libraryCard}      
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="accounts.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Accounts">{translate text='Library Cards'}</a></li>
        {/if}      
        {* Only highlight saved searches as active if user is logged in: *}
        <li class="active ui-state-default ui-corner-top {if $user && $pageTemplate=="history.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/Search/History?require_login">{translate text='history_saved_searches'}</a></li>
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="profile.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Profile">{translate text='Profile'}</a></li>
      </ul>
    </div>
    </div>
  </div>
  
<!-- END of: MyResearch/menu.tpl -->
