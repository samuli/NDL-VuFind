<!-- START of: MyResearch/menu.tpl -->

  <div class="myresearchHeader">
  <div class="content">
    <div class="grid_24"><span class="usericon"></span><h1>{translate text="Your Account"}</h1>
{if in_array('myAccount', $contextHelp)}<span id="contextHelp_myAccount" class="showHelp">{translate text="Search Tips"}</span>{/if}
      <form action="" method="post">
        <select id="myResearchMenuMobile" name="myresearchmenumobile" class="jumpMenuURL">
        <option value="{$url}/MyResearch/Profile"{if $pageTemplate=="profile.tpl"} selected="selected"{/if}>{translate text='Profile'}</option>
        <option value="{$url}/MyResearch/CheckedOut"{if $pageTemplate=="checkedout.tpl"} selected="selected"{/if}>{translate text='Checked Out Items'}</option>
        <option value="{$url}/MyResearch/Holds"{if $pageTemplate=="holds.tpl"} selected="selected"{/if}>{translate text='Holds and Requests'}</option>
        <option value="{$url}/MyResearch/Fines"{if $pageTemplate=="fines.tpl"} selected="selected"{/if}>{translate text='Fines'}</option>
        {if $libraryCard} 
        <option value="{$url}/MyResearch/Accounts"{if $pageTemplate=="accounts.tpl"} selected="selected"{/if}>{translate text='Library Cards'}</option>
        {/if}
        <option value="{$url}/MyResearch/Favorites"{if $pageTemplate=="favorites.tpl" || $pageTemplate=="list.tpl"} selected="selected"{/if}>{translate text='Favorites'}</option>
        <option value="{$url}/Search/History?require_login"{if $pageTemplate=="history.tpl"} selected="selected"{/if}>{translate text='history_saved_searches'}</option>
        </select>
        <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
        </form>
    </div>
  </div>
  </div>

  <div class="ui-tabs ui-widget myResearchMenu">
    <div class="content">
      <div class="grid_24">
      <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix">
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="profile.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Profile">{translate text='Profile'}</a></li>
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="checkedout.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/CheckedOut">{translate text='Checked Out Items'}</a></li>
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="holds.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Holds">{translate text='Holds and Requests'}</a></li>
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="fines.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Fines">{translate text='Fines'}</a></li>
        {if $libraryCard}      
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="accounts.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Accounts">{translate text='Library Cards'}</a></li>
        {/if}       
        <li class="active ui-state-default ui-corner-top {if $pageTemplate=="favorites.tpl" || $pageTemplate=="list.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/MyResearch/Favorites">{translate text='Favorites'}</a></li>
        {* Only highlight saved searches as active if user is logged in: *}
        <li class="active ui-state-default ui-corner-top {if $user && $pageTemplate=="history.tpl"} ui-tabs-selected ui-state-active{/if}"><a href="{$url}/Search/History?require_login">{translate text='history_saved_searches'}</a></li>
      </ul>
    </div>
    </div>
  </div>
      
<!-- END of: MyResearch/menu.tpl -->
