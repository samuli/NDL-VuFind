{if $record.format}
RT {$record.format}
{/if}
{if $record.author[0]}
A1 {$record.author[0]}
{/if}
{if $record.author2}
{foreach from=$record.author2 item=item}
A1 {$item}
{/foreach}
{/if}
{if $record.publicationDate}
FD {$record.publicationDate}
{/if}
{if $record.publicationTitle}
YR {$record.publicationTitle}
{/if}
{if $record.language}
LA {$record.language}
{/if}
T1 {$record.title}
{if $record.url}
{foreach from=$record.url item=item}
UL {$item}
{/foreach}
{else if $record.backlink}
UL {$record.backlink}
{/if}
{if $record.ISSN}
SN {$record.ISSN}
{/if}
{literal}

{/literal}