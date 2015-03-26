%0 Generic
{if $record.Author[0]}
%A {$record.Author[0]}
{/if}
{if $record.AdditionalAuthors}
{foreach from=$record.AdditionalAuthors item=item}
%A {$item}
{/foreach}
{/if}
{if $record.PublicationDate[0]}
%D {$record.PublicationDate[0]}
{/if}
{if $record.PublicationTitle[0]}
%I {$record.PublicationTitle[0]}
{/if}
{if $record.language[0]}
%G {$record.language[0]}
{/if}
%T {$record.Title[0]}
{if $record.ISSN[0]}
%@ {$record.ISSN[0]}
{/if}
{if $record.url}
{foreach from=$record.url item=item}
%U {$item}
{/foreach}
{/if}
{literal}

{/literal}