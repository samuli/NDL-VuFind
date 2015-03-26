{if $record.format}
%0 {$record.format}
{/if}
{if $record.author[0]}
%A {$record.author[0]}
{/if}
{if $record.author2}
{foreach from=$record.author2 item=item}
%A {$item}
{/foreach}
{/if}
{if $record.publicationDate}
%D {$record.publicationDate}
{/if}
{if $record.publicationTitle}
%J {$record.publicationTitle}
{/if}
{if $record.language}
%G {$record.language}
{/if}
%T {$record.title}
{if $record.url}
{foreach from=$record.url item=item}
%U {$item}
{/foreach}
{else if $record.backlink}
%U {$record.backlink}
{/if}
{if $record.snippet}
%X {$record.snippet}
{/if}
{if $record.ISSN}
%@ {$record.ISSN}
{/if}
{literal}

{/literal}