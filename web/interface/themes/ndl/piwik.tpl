{if $piwikUrl}
{literal}
<!-- Piwik --> 
<script type="text/javascript"> 
var _paq = _paq || [];
(function(){ var u="{/literal}{$piwikUrl}{literal}"; 
_paq.push(['setSiteId', {/literal}{$piwikSiteId}{literal}]); 
_paq.push(['setTrackerUrl', u+'piwik.php']);{/literal}
  {if ($module eq "Record")}
    {if $recordFormat}
      {if $recordFormat.1}
        {assign var=newRecordFormat value=$recordFormat. 1}
      {else}
        {assign var=newRecordFormat value=$recordFormat.0}
      {/if}
_paq.push(['setCustomVariable',  1, "RecordFormat", "{$newRecordFormat|escape:"html"}", "page"]);
    {/if}
    {if $id and $coreMainAuthor and $coreShortTitle}
_paq.push(['setCustomVariable',  2, "RecordData", "{$id|escape:"html"}|{$coreMainAuthor|escape:"html"}|{$coreShortTitle|escape:"html"}", "page"]);
    {/if}
    {if $id and !$coreMainAuthor and $coreShortTitle and $coreContributors}
_paq.push(['setCustomVariable',  2, "RecordData", "{$id|escape:"html"}|{$coreContributors.0|escape:"html"}|{$coreShortTitle|escape:"html"}", "page"]);
    {/if}
    {if $id and !$coreMainAuthor and $coreShortTitle and !$coreContributors}
_paq.push(['setCustomVariable',  2, "RecordData", "{$id|escape:"html"}|-|{$coreShortTitle|escape:"html"}", "page"]);
    {/if}
    {if $coreInstitutions}
_paq.push(['setCustomVariable',  3, "RecordInstitution", "{$coreInstitutions.0|escape:"html"}", "page"]);
    {/if}
  {/if}
{literal}
_paq.push(['enableLinkTracking']); 
_paq.push(['trackPageView']); 
var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.defer=true; g.async=true; g.src=u+'piwik.js'; 
s.parentNode.insertBefore(g,s); })();
 </script> 
{/literal}
<noscript><p><img src="{$piwikUrl}piwik.php?idsite={$piwikSiteId}" style="border:0" alt="" /></p></noscript>
<!-- End Piwik Code -->
{/if}