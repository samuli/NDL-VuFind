<!-- START of: Record/view-holdings.tpl -->
<div class="content">
  <div class="grid_24">
  {if $offlineMode == "ils-offline"}
  <div class="sysInfo">
    <h2>{translate text="ils_offline_title"}</h2>
    <p><strong>{translate text="ils_offline_status"}</strong></p>
    <p>{translate text="ils_offline_holdings_message"}</p>
    <p><a href="mailto:{$supportEmail}">{$supportEmail}</a></p>
  </div>
  {/if}

  {include file=$holdingsMetadata}

  <script type="text/javascript">
    setUpCheckRequest();
    setUpCheckCallSlipRequest();
    setUpCheckUBRequest();
  </script>
</div>
</div>
{if $locationServiceModal}
    <div id="modalLocationService" title="{translate text="Location Service"}">
        <a id="locationServiceDirectLink" href="" target="_blank" class="">{translate text="Open in a New Window"}</a>
        <iframe id="locationServiceFrame" src=""></iframe>
    </div>
    {js filename="locationservice.js"}
{/if}
<!-- END of: Record/view-holdings.tpl -->
