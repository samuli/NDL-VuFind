<a href="{if $lastsearch}{$lastsearch|escape}{else}{$url}/MetaLib/Search{/if}">{translate text="Search"}{if $lookfor}: {$lookfor|truncate:30:"..."|escape}{/if}</a> 
<span>&gt;</span>
{if $id}
<em>{$record.Title.0|truncate:30:"..."|escape}</em>
{/if}