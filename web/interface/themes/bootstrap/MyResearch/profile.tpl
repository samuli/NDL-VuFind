<!-- START of: MyResearch/profile.tpl -->

{include file="MyResearch/menu.tpl"}

{if count($pickup) > 1}
  {assign var='showHomeLibForm' value=true}
{else}
  {assign var='showHomeLibForm' value=false}
{/if}
<div class="well-small myResearch profile{if $sidebarOnLeft} last{/if}">
  <span class="lead">{translate text='Your Profile'}</span>

    <form method="post" action="{$url}/MyResearch/Profile" id="profile_form">
      <div class="row-fluid profileInfo">
        <h4>{translate text='Local Settings'}</h4>
        <div class="span5">
          {translate text='Email'}:
          <br /><input type="text" name="email" value="{$email|escape}"></input>

          {if $showHomeLibForm}
          <br />
          <label for="home_library">{translate text="Preferred Library"}:</label>

            {if count($pickup) > 1}
              {if $profile.home_library != ""}
                {assign var='selected' value=$profile.home_library}
              {else}
                {assign var='selected' value=$defaultPickUpLocation}
              {/if}
              <select id="home_library" name="home_library" class="selectpicker">
              {foreach from=$pickup item=lib name=loop}
                <option value="{$lib.locationID|escape}" {if $selected == $lib.locationID}selected="selected"{/if}>{$lib.locationDisplay|escape}</option>
              {/foreach}
              </select>
            {else}
              {$pickup.0.locationDisplay}
            {/if}
          {/if}
          <br/>
          <input class="btn btn-info button" type="submit" value="{translate text='Save'}" />
        </div>
      </div>
    </form>

    {if $user->cat_username}
      {if $userMsg}
      <div class="resultHead">
        <p class="alert alert-success success">{translate text=$userMsg}</p>
      </div>
      {/if}
      <div class="row-fluid profileInfo">
        <h4>{translate text='Source of information'}:
          {assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}
          {translate text=$source prefix='source_'}
        </h4>
        <div class="span5 well-small">
          <table class="table table-condensed">
          <tr>
            <td>{translate text='First Name'}:</td>
            <td>{if $profile.firstname}{$profile.firstname|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Last Name'}:</td>
            <td>{if $profile.lastname}{$profile.lastname|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td>{translate text='Address'} 1:</td>
            <td>{if $profile.address1}{$profile.address1|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Address'} 2:</td>
            <td>{if $profile.address2}{$profile.address2|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Zip'}:</td>
            <td>{if $profile.zip}{$profile.zip|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr>
            <td>{translate text='Phone Number'}:</td>
            <td>{if $profile.phone}{$profile.phone|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Email'}:</td>
            <td>{if $info.email}{$info.email|escape}{else}-{/if}</td>
          </tr>
          <tr>
            <td>{translate text='Group'}:</td>
            <td>{$profile.group|escape}</td>
          </tr>
          </table>
        </div>

        <div class="row-fluid profileGroup">
        {foreach from=$profile.blocks item=block name=loop}
          {if $smarty.foreach.loop.first}
            <span>{translate text='Borrowing Blocks'}:</span>
          {else}
            <span>&nbsp;</span>
          {/if}
          <span>{$block|escape}</span><br class="clear"/>
        {/foreach}
        </div>
    
    {else}
      {include file="MyResearch/catalog-login.tpl"}
    {/if}
      </div>
  </div>


<!-- END of: MyResearch/profile.tpl -->
