{if $piwikUrl}
{literal}
<!-- Piwik --> 
<script type="text/javascript"> 
var _paq = _paq || [];
(function(){ var u="{/literal}{$piwikUrl}{literal}"; 
_paq.push(['setSiteId', {/literal}{$piwikSiteId}{literal}]); 
_paq.push(['setTrackerUrl', u+'piwik.php']);{/literal}
_paq.push(['setCustomUrl', location.protocol + '//' + location.host + location.pathname]);
  {if ($module eq 'PCI') and ($action eq 'Record') and $id}
    {if $record.format}
      {assign var=newRecordFormat value=$record.format}
    {else}
      {assign var=newRecordFormat value='-'}
    {/if}
_paq.push(['setCustomVariable', 1, "PCIRecordFormat", "{$newRecordFormat|escape:"html"}", "page"]);
    {if $record.title}
      {assign var="recordTitle" value=$record.title}
    {else}
      {assign var="recordTitle" value="-"}
    {/if}
    {if $record.author and $record.author.0}
      {assign var="recordAuthor" value=$record.author.0}
    {else}
      {assign var="recordAuthor" value="-"}
    {/if}
_paq.push(['setCustomVariable', 2, "PCIRecordData", "{$id|escape:"html"}|{$recordAuthor|escape:"html"}|{$recordTitle|escape:"html"}", "page"]);
    {if $record.source}
      {assign var=recordSource value=$record.source}
    {else}
      {assign var=recordSource value='-'}
    {/if}
_paq.push(['setCustomVariable', 3, "PCIRecordSource", "{$recordSource|escape:"html"}", "page"]);
_paq.push(['setCustomVariable', 4, "RecordIndex", "PCI", "page"]);
  {/if}
  {if ($module eq 'MetaLib' and ($action eq 'Record') and $id)}
    {if $record.Title and $record.Title.0}
      {assign var="recordTitle" value=$record.Title.0}
    {else}
      {assign var="recordTitle" value="-"}
    {/if}
    {if $record.Author and $record.Author.0}
      {assign var="recordAuthor" value=$record.Author.0}
    {elseif $record.AdditionalAuthors}
      {assign var="recordAuthor" value=$record.AdditionalAuthors}
    {else}
      {assign var="recordAuthor" value="-"}
    {/if}
_paq.push(['setCustomVariable', 2, "MetaLibRecordData", "{$id|escape:"html"}|{$recordAuthor|escape:"html"}|{$recordTitle|escape:"html"}", "page"]);
    {if $record.Source and $record.Source.0}
      {assign var=recordSource value=$record.Source.0}
    {else}
      {assign var=recordSource value='-'}
    {/if}
_paq.push(['setCustomVariable', 3, "MetaLibRecordSource", "{$recordSource|escape:"html"}", "page"]);
_paq.push(['setCustomVariable', 4, "RecordIndex", "MetaLib", "page"]);
  {/if}
  {if ($module eq 'Record')}
    {if $recordFormat}
      {if $recordFormat.1}
        {assign var=newRecordFormat value=$recordFormat.1}
      {else}
        {assign var=newRecordFormat value=$recordFormat.0}
      {/if}
_paq.push(['setCustomVariable', 1, "RecordFormat", "{$newRecordFormat|escape:"html"}", "page"]);
    {/if}
    {if $id}
      {if $coreMainAuthor}
        {assign var="recordAuthor" value=$coreMainAuthor}
      {elseif $coreContributors}
        {assign var="recordAuthor" value=$coreContributors.0}
      {else}
        {assign var="recordAuthor" value="-"}
      {/if}
_paq.push(['setCustomVariable', 2, "RecordData", "{$id|escape:"html"}|{$recordAuthor|escape:"html"}|{if $coreShortTitle}{$coreShortTitle|escape:"html"}{if $coreSubtitle} : {$coreSubtitle|escape}{/if}{else}{translate text='Title not available'|escape:"html"}{/if}", "page"]);
_paq.push(['setCustomVariable', 4, "RecordIndex", "Local", "page"]);
    {/if}
    {if $coreInstitutions}
_paq.push(['setCustomVariable', 3, "RecordInstitution", "{$coreInstitutions.0|escape:"html"}", "page"]);
    {/if}
_paq.push(['trackPageView']);
  {elseif (($module eq 'Search' and ($action eq 'Results' or $action eq 'DualResults')) or ($module eq 'AJAX' and $action eq 'AJAX_MetaLib') or ($module eq 'PCI' and $action eq 'Search'))}
    {if $filterList}
_paq.push(['setCustomVariable', 1, "Facets", "{foreach from=$filterList item=filters}{foreach from=$filters item=filter}{$filter.field|escape:"html"}|{$filter.display|escape:"html"}\t{/foreach}{/foreach}", "page"]);
_paq.push(['setCustomVariable', 2, "FacetTypes", "{foreach from=$filterList item=filters}{foreach from=$filters item=filter}{$filter.field|escape:"html"}\t{/foreach}{/foreach}", "page"]);
    {/if}
    {if $action eq 'DualResults'}
      {assign var="typeOfSearch" value='dual'}
    {elseif $searchType}
      {assign var="typeOfSearch" value=$searchType}
    {else}
      {assign var="typeOfSearch" value='unknown'}
    {/if}
_paq.push(['setCustomVariable', 3, "SearchType", "{$typeOfSearch|escape:"html"}", "page"]);
{* Use trackSiteSearch *instead* of trackPageView in search pages *}
_paq.push(['trackSiteSearch', "{if $lookfor}{$lookfor|escape:"html"}{else}-{/if}", "{if $activePrefilter}{$activePrefilter|escape:"html"}{else}-{/if}", {if $recordCount}{$recordCount|escape:"html"}{else}false{/if}]);
  {else}
_paq.push(['trackPageView']);
  {/if}
{literal}
_paq.push(['enableLinkTracking']); 
var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.defer=true; g.async=true; g.src=u+'piwik.js'; 
s.parentNode.insertBefore(g,s); })();
 </script> 
{/literal}
<noscript><p><img src="{$piwikUrl}piwik.php?idsite={$piwikSiteId}" style="border:0" alt="" /></p></noscript>
<!-- End Piwik Code -->
{/if}