<form method="post" action="{$url}/MyResearch/Profile" class="messaging_settings_form profile_form">
  <table class="profileGroup">
    {foreach from=$services key=service item=data}
    <tr>
      <th>{$data.type}</th>
      <td>
        <select name="{$service}">
          <option value="none">{translate text="messaging_settings_method_none"}</option>
          {if $service == 'dueDateAlert'}
          {foreach from=$emailDays key="day" item="label"}
          <option value="{$day+1}"{if $data.numOfDays == $day+1} selected{/if}>{$label}</option>
          {/foreach}
          {else}
          {foreach from=$data.sendMethods key=method item=methodData}          
          <option value="{$methodData.type}"{if $methodData.active} selected{/if}>{$methodData.method}</option>
          {/foreach}
          {/if}
        </select>
      </td>
    </tr>
    {/foreach}
    <tr>
      <th>
        <input type="hidden" name="changeMessagingSettings" value="1"></input>
        <input class="button buttonFinna left" type="submit" value="{translate text='Save'}" />
      </th>       
    </tr>
  </table>
</form>
<span class="messagingSettingsChangeDescription">
  {translate text="request_change_description"}
</span>