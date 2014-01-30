<div class="sideRecommendation">
    <dl class="narrowList navmenu">
        <dt><span>{translate text='New Items in Index'}</span></dt>
        {foreach from=$newItemsLinks item=link name=links}
            {if !$smarty.foreach.links.last}
            <dd><a href="{$link.url}">{$link.label}&nbsp;</a></dd>
            {else}
            <dd><div>{$link.label} ... <span id="showDate"></span><a id="newItemsFromDate" data-url="" data-urltemplate="{$link.url}" data-solrdate="" href="" class="button buttonFinna searchButton right">&nbsp;</a></div>
                <div id="newItemsLimit" class="hasDatePick"></div></dd>
            {/if}
        {/foreach}
    </dl>
</div>
