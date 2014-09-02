<!-- START of: PCI/list-list.tpl -->

{js filename="openurl.js"}
{if $showPreviews}
{js filename="preview.js"}
{/if}
{if $metalibEnabled}
{js filename="metalib_links.js"}
{/if}
{include file="Search/rsi.tpl"}
{include file="Search/openurl_autocheck.tpl"}
{js filename="check_save_statuses.js"}
<ul class="recordSet">
  {if !$userAuthorized && $methodsAvailable}
   <div class="loginNotification">
   <p>{translate text="authorize_user_notification"}</p>
   </div>
  {/if}
{foreach from=$recordSet item=record name="recordLoop"}
  <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
    <span class="recordNumber">{$recordStart+$smarty.foreach.recordLoop.iteration-1}</span>
    {include file="PCI/result-list.tpl"}
</li>
{/foreach}
</ul>

<!-- END of: Search/list-list.tpl -->