<!-- START of: Search/history.tpl -->
{if $user}
  {include file="MyResearch/menu.tpl"}
{else}
  <div class="myresearchHeader">
    <div class="content">
      <div class="grid_24"><h1>{translate text="Search History"}</h1></div>
    </div>
  </div>
{/if}

<div class="myResearch">
  <div class="content">
    {if !$noHistory}
      {if $saved}
        {assign var="scheduled" value=false}
        {foreach item=info from=$saved name=historyLoop}
          {if $info.schedule > 0}
            {assign var="scheduled" value=true}
          {/if}   
        {/foreach}
        {if $scheduled}
          {if !$user->email || $user->email == " "}
        <div class="error">{translate text="no_email_address"} <a href="{$path}/MyResearch/Profile">{translate text="check_profile"}</a></div>
          {else}
        <div class="info">{translate text="alert_email_address"}: {$user->email} (<a href="{$path}/MyResearch/Profile">{translate text="edit"}</a>)</div>
          {/if}
        {/if}
        {if $user}<h2>{translate text="history_saved_searches"}</h2>{/if}
        <table class="datagrid savedHistory" width="100%">
          <tr>
            <th width="15%">{translate text="history_time"}</th>
            <th width="30%">{translate text="history_search"}</th>
            <th width="20%">{translate text="history_limits"}</th>
            <th width="10%" style="text-align:right">{translate text="history_results"}</th>
            <th width="20%">{translate text="history_schedule"}</th>
            <th width="5%" class="alignMiddle">{translate text="history_delete"}</th>
          </tr>
          {foreach item=info from=$saved name=historyLoop}
          {if ($smarty.foreach.historyLoop.iteration % 2) == 0}
          <tr class="evenrow">
          {else}
          <tr class="oddrow">
          {/if}
            <td>{$info.time}</td>
            <td><a href="{$info.url|escape}">{if empty($info.description)}{translate text="history_empty_search"}{else}{$info.description|escape}{/if}</a></td>
            <td>{foreach from=$info.filters item=filters key=field}{foreach from=$filters item=filter}
              <strong>{translate text=$field|escape}</strong>: {$filter.display|escape}<br/>
            {/foreach}{/foreach}</td>
            <td style="text-align:right">{$info.hits}</td>
            <td>
              {if $info.url|strpos:"PCI" == false && $info.url|strpos:"MetaLib" == false}
              <select id="{$info.searchId|escape:"html"}" name="schedule" onchange="javascript:window.location='{$path}/MyResearch/SaveSearch?save={$info.searchId|escape:"url"}&amp;mode=history&amp;schedule=' + $(this).attr('value'); return false;">
                <option value="0"{if $info.schedule == 0} selected="selected"{/if}>{translate text="schedule_none"}</option>
                <option value="1"{if $info.schedule == 1} selected="selected"{/if}>{translate text="schedule_daily"}</option>
                <option value="2"{if $info.schedule == 2} selected="selected"{/if}>{translate text="schedule_weekly"}</option>
              </select>
              {/if}
            </td>
            <td><a href="{$path}/MyResearch/SaveSearch?delete={$info.searchId|escape:"url"}&amp;mode=history" class="delete"></a></td>
          </tr>
          {/foreach}
        </table>
      {/if}
      {if $user && !$saved}
      	<h2>{translate text="history_saved_searches"}</h2>
        <table>
        	<tr>
            	<td><p class="noContentMessage">{translate text="You do not have any saved searches"}</p></td>
            </tr>
        </table>
      {/if}
      {if $links}
          <h2>{translate text="history_recent_searches"}</h2>
          <table class="datagrid sessionHistory" width="100%">
          <tr>
            <th width="15%">{translate text="history_time"}</th>
            <th width="30%">{translate text="history_search"}</th>
            <th width="20%">{translate text="history_limits"}</th>
            <th width="10%" class="alignRight">{translate text="history_results"}</th>
            <th width="20%"> </th>
            <th width="5%" class="alignRight">{translate text='Save'}</th>
          </tr>
          {foreach item=info from=$links name=historyLoop}
          {if ($smarty.foreach.historyLoop.iteration % 2) == 0}
          <tr class="evenrow">
          {else}
          <tr class="oddrow">
          {/if}
            <td>{$info.time}</td>
            <td><a href="{$info.url|escape}">{if empty($info.description)}{translate text="history_empty_search"}{else}{$info.description|escape}{/if}</a></td>
            <td>{foreach from=$info.filters item=filters key=field}{foreach from=$filters item=filter}
              <strong>{translate text=$field|escape}</strong>: {$filter.display|escape}<br/>
            {/foreach}{/foreach}</td>
            <td style="text-align:right">{$info.hits}</td>
            <td> </td>
            <td class="alignMiddle"><a href="{$path}/MyResearch/SaveSearch?save={$info.searchId|escape:"url"}&amp;mode=history" class="add"></a></td>
          </tr>
          {/foreach}
        </table>
        <a href="{$path}/Search/History?purge=true" class="delete floatright">{translate text="history_purge"}</a>
      {/if}

    {else}
       {if $user}<h2>{translate text="history_recent_searches"}</h2>{/if}
        <div class="noContentMessage">{translate text="history_no_searches"}</div>
    {/if}
  </div>
<div class="clear"></div>
</div>


<!-- END of: Search/history.tpl -->
