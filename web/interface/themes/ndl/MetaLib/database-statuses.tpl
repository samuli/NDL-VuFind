    <div id="databaseStatuses">
      {if $successDatabases}
        <div id="databaseSuccess">
           <strong>{translate text='Metalib Databases'}:</strong>
          <br/>
          {foreach from=$successDatabases item=success name=successLoop}
            <a href="{$success.url}">- {$success.name|escape}</a>{if !$smarty.foreach.successLoop.last}<br/>{/if}
          {/foreach}
        </div>
      {/if}

      {if $failedDatabases}
        <div id="databaseFailed">
          <strong>{translate text='Metalib Search Failed'}:</strong>
          <br/>
          {foreach from=$failedDatabases item=failed name=failedLoop}
            {if $failed|is_array}<a href="{$failed.url}">- {$failed.name|escape}</a>{else}- {$failed|escape}{/if}{if !$smarty.foreach.failedLoop.last}<br/>{/if}
          {/foreach}
        </div>
      {/if}
      {if $disallowedDatabases}
        <div id="databaseDisallowed">
           <strong>{translate text='Metalib Search Not Authorized'}:</strong>
          <br/>
          {foreach from=$disallowedDatabases item=disallowed name=disallowedLoop}
            <a href="{$disallowed.url}">- {$disallowed.name|escape}</a>{if !$smarty.foreach.disallowedLoop.last}<br/>{/if}
          {/foreach}
        </div>
      {/if}
    </div>