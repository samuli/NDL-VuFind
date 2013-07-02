{* Meta tags for Facebook *}
{if $coreTitle}
<meta property="og:title" content="{$coreTitle}" />
{/if}
{if $extendedSummary}
<meta property="og:description" content="{$siteTitle}: {$extendedSummary.0}" />
{else}
{if $recordFormat}
  {if is_array($recordFormat)}
    {assign var=mainFormat value=$recordFormat.0} 
  {else}
    {assign var=mainFormat value=$recordFormat} 
  {/if}
{/if}
{if $corePublicationDates}
  {if is_array($corePublicationDates)}
    {assign var=mainDate value=$corePublicationDates.0} 
  {else}
    {assign var=mainDate value=$corePublicationDates} 
  {/if}
{/if}
{if $mainFormat || $mainDate || $coreMainAuthor}
<meta property="og:description" content="{$siteTitle}: {translate text=$mainFormat} {$coreMainAuthor} {$mainDate}" />
{/if}
{/if}
<meta property="og:site_name" content="{$siteTitle}"/>
