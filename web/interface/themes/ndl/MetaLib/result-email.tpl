{* This file is used for emails. Note that the line feeds are important for nice text layout. *}
{translate text="Title"}: {if $record.Title.0}{$record.Title.0}{else}{translate text='Title not available'}{/if}
{if $record.Author}

{translate text='by'}: {foreach from=$record.Author item=author name=aut}{$author|escape}{if not $smarty.foreach.aut.last}, {/if}{/foreach}{/if}
{if $record.publicationDate}

{translate text='Published'}: {$record.publicationDate.0|escape}{/if}

{translate text="Full Record"}: {$url}/MetaLib/Record?id={$record.id|escape:"url"}
