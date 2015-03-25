RT Generic
{if $record.Author[0]}
A1 {$record.Author[0]}
{/if}
{if $record.AdditionalAuthors}
{foreach from=$record.AdditionalAuthors item=item}
A1 {$item}
{/foreach}
{/if}
{if $record.PublicationDate[0]}
FD {$record.PublicationDate[0]}
{/if}
{if $record.PublicationTitle[0]}
YR {$record.PublicationTitle[0]}
{/if}
{if $record.language[0]}
LA {$record.language[0]}
{/if}
T1 {$record.Title[0]}
{if $record.ISSN[0]}
SN {$record.ISSN[0]}
{/if}
{literal}

{/literal}