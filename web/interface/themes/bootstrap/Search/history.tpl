<!-- START of: Search/history.tpl -->

{include file="MyResearch/menu.tpl"}

<div class="well-small myResearch">
    {if !$noHistory}
      {if $saved}
        <span class="lead">{translate text="history_saved_searches"}</span>
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
        <table class="table table-hover datagrid savedHistory">
          <tr class="well">
            <th {*width="15%"*}>{translate text="history_time"}</th>
            <th {*width="30%"*}>{translate text="history_search"}</th>
            <th {*width="20%"*} class="hidden-phone">{translate text="history_limits"}</th>
            <th {*width="10%" style="text-align:right"*} style="text-align: right;" class="hidden-phone">{translate text="history_results"}</th>
            <th {*width="20%"*} style="text-align: right;">{translate text="history_schedule"}</th>
            <th {*width="5%"*} style="text-align: right;" >{translate text="history_delete"}</th>
          </tr>
          {foreach item=info from=$saved name=historyLoop}
          {if ($smarty.foreach.historyLoop.iteration % 2) == 0}
          <tr class="evenrow">
          {else}
          <tr class="oddrow">
          {/if}
            <td>{$info.time}</td>
            <td><a href="{$info.url|escape}">{if empty($info.description)}{translate text="history_empty_search"}{else}{$info.description|escape}{/if}</a></td>
            <td class="hidden-phone">{foreach from=$info.filters item=filters key=field}{foreach from=$filters item=filter}
              <strong>{translate text=$field|escape}</strong>: {$filter.display|escape}<br/>
            {/foreach}{/foreach}</td>
            <td style="text-align:right;" class="hidden-phone">{$info.hits}</td>
            <td style="text-align: right;">
              <select name="schedule" onchange="javascript:window.location='{$path}/MyResearch/SaveSearch?save={$info.searchId|escape:"url"}&amp;mode=history&amp;schedule=' + $(this).attr('value'); return false;" class="span8 selectpicker" data-style="btn-small">
                <option value="0"{if $info.schedule == 0} selected="selected"{/if}>{translate text="schedule_none"}</option>
                <option value="1"{if $info.schedule == 1} selected="selected"{/if}>{translate text="schedule_daily"}</option>
                <option value="2"{if $info.schedule == 2} selected="selected"{/if}>{translate text="schedule_weekly"}</option>
              </select>
            </td>
            <td style="text-align: right;"><a href="{$path}/MyResearch/SaveSearch?delete={$info.searchId|escape:"url"}&amp;mode=history" class="btn btn-small btn-danger delete"><i class="icon-remove icon-white"></i>&nbsp;{translate text="history_delete_link"}</a></td>
          </tr>
          {/foreach}
        </table>
      {/if}

      {if $links}
        <span class="lead">{translate text="history_recent_searches"}</span>
        <table class="table table-hover datagrid sessionHistory">
          <tr class="well">
            <th {*width="15%"*}>{translate text="history_time"}</th>
            <th {*width="30%"*}>{translate text="history_search"}</th>
            <th {*width="20%"*} class="hidden-phone">{translate text="history_limits"}</th>
            <th {*width="10%" style="text-align:right"*} style="text-align: right;">{translate text="history_results"}</th>
            <th {*width="20%"*}> </th>
            <th {*width="5%"*}  style="text-align: right;">{translate text="history_save"}</th>
          </tr>
          {foreach item=info from=$links name=historyLoop}
          {if ($smarty.foreach.historyLoop.iteration % 2) == 0}
          <tr class="evenrow">
          {else}
          <tr class="oddrow">
          {/if}
            <td>{$info.time}</td>
            <td><a href="{$info.url|escape}">{if empty($info.description)}{translate text="history_empty_search"}{else}{$info.description|escape}{/if}</a></td>
            <td class="hidden-phone">{foreach from=$info.filters item=filters key=field}{foreach from=$filters item=filter}
              <strong>{translate text=$field|escape}</strong>: {$filter.display|escape}<br/>
            {/foreach}{/foreach}</td>
            <td style="text-align:right" class="text-right">{$info.hits}</td>
            <td> </td>
            <td style="text-align: right;"><a href="{$path}/MyResearch/SaveSearch?save={$info.searchId|escape:"url"}&amp;mode=history" class="btn btn-small btn-success"><i class="icon-plus-sign icon-white"></i>&nbsp;{translate text="history_save_link"}</a></td>
          </tr>
          {/foreach}
        </table>
        <a href="{$path}/Search/History?purge=true" class="btn btn-small btn-danger pull-right delete floatright"><i class="icon-remove icon-white"></i>&nbsp;{translate text="history_purge"}</a>
      {/if}

    {else}
      <span class="lead">{translate text="history_recent_searches"}</span>
      <div class="alert alert-info resultHead">{translate text="history_no_searches"}</div>
    {/if}
    <div class="clearfix">&nbsp;</div>
</div>


<!-- END of: Search/history.tpl -->
