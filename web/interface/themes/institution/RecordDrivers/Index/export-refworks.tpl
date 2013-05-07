RT {$indexData.recordType}
T1 {$indexData.title_full}
{if $indexData.series}
{foreach from=$indexData.series item=item}
T2 {$item}
{/foreach}
{/if}
{if $indexData.series2}
{foreach from=$indexData.series2 item=item}
T2 {$item}
{/foreach}
{/if}
{if $indexData.author}
A1 {$indexData.author}
{/if}
{if $indexData.author2}
{foreach from=$indexData.author2 item=item}
A1 {$item}
{/foreach}
{/if}
{if $indexData.language}
{foreach from=$indexData.language item=item}
LA {$item}
{/foreach}
{/if}
{if $indexData.publisher}
{foreach from=$indexData.publisher item=item}
PB {$item}
{/foreach}
{/if}
{if $indexData.publisher}
{foreach from=$indexData.publishDate item=item}
YR {$item}
{/foreach}
{/if}
UL {$url}/Record/{$id|escape:"url"}
{if $indexData.isbn}
{foreach from=$indexData.isbn item=item}
SN {$item}
{/foreach}
{/if}
{if $indexData.topic}
{foreach from=$indexData.topic item=item}
K1 {$item}
{/foreach}
{/if}