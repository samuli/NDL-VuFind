<ul>
{foreach from=$searchPhrases item=phrase name=phrases}
    <li><span class="counter">{counter}</span><span class="searchTerm"><a href="{$url}/Search/Results?lookfor={$phrase|escape url}">{$phrase|truncate:20:"..."|escape}</a></span></li>
    {if $smarty.foreach.phrases.iteration == 5}</ul><ul>{/if}
{/foreach}
</ul>