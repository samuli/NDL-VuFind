{if $offlineMode == "ils-offline"}
  <div class="sysInfo">
    <h2>{translate text="ils_offline_title"}</h2>
    <p><strong>{translate text="ils_offline_status"}</strong></p>
    <p>{translate text="ils_offline_login_message"}</p>
    <p><a href="mailto:{$supportEmail}">{$supportEmail}</a></p>
  </div>
{else}
  <h3>{translate text='Library Catalog Profile'}</h3>
  {if $loginError}
    <p class="error">{translate text=$loginError}</p>
  {/if}
  <p>{translate text='cat_establish_account'}</p>
  <form method="post" action="{$path}/MyResearch/Profile" data-ajax="false">
    <div data-role="fieldcontain">
      <label for="profile_cat_username">{translate text='Library Catalog Username'}:</label>
      <input id="profile_cat_username" type="text" name="cat_username" value=""/>
    </div>
    <div data-role="fieldcontain">
      <label for="profile_cat_password">{translate text='Library Catalog Password'}:</label>
      <input id="profile_cat_password" type="text" name="cat_password" value=""/>
    </div>
    <div data-role="fieldcontain">
      <input type="submit" name="submit" value="{translate text="Save"}"/>
    </div>
  </form>
{/if}