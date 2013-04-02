{* This file is used for emails. Note that the line feeds are important for nice text layout. *}
{translate text="Title"}: {if $record.title}{$record.title}{else}{translate text='Title not available'}{/if}
{if $record.author}

{translate text='by'}: {foreach from=$record.author item=author name=aut}{$author|escape}{if not $smarty.foreach.aut.last}, {/if}{/foreach}{/if}
{if $record.publicationDate}

{translate text='Published'}: {$record.publicationDate|escape}{/if}

{translate text="Full Record"}: {$url}/PCI/{$record.id|escape:"url"}
