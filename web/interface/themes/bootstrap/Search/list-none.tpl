<!-- START of: Search/list-none.tpl -->

<div class="{if $sidebarOnLeft}last {/if}no-hits">
  <div class="resulthead"><h3>{if $searchType == 'advanced'}{translate text='Advanced Search'}{else}{translate text='Search'}{/if}: {translate text='nohit_heading'}</h3></div>
  <p class="alert alert-error">{translate text='nohit_prefix'} - <strong>{$lookfor|escape:"html"}</strong> - {translate text='nohit_suffix'}</p>

  {if $parseError}
    <p class="alert alert-error">{translate text='nohit_parse_error'}</p>
  {/if}

  {if $spellingSuggestions}
  <div class="alert alert-info correction">{translate text='nohit_spelling'}:<br/>
    {foreach from=$spellingSuggestions item=details key=term name=termLoop}
      {$term|escape} &raquo; {foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a href="{$data.expand_url|escape}"><img src="{$path}/images/silk/expand.png" alt="{translate text='spell_expand_alt'}"/></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}{if !$smarty.foreach.termLoop.last}<br/>{/if}
    {/foreach}
  </div>
  {/if}

  {* Recommendations *}
  {if $topRecommendations}
    {foreach from=$topRecommendations item="recommendations"}
      {if !$visFacets} {* Do not want to show TopPubDateVis *}
        {include file=$recommendations}
      {/if}
    {/foreach}
  {/if}

  {if $noResultsRecommendations}
    {foreach from=$noResultsRecommendations item="recommendations" key='key' name="noResults"}
      {include file=$recommendations}
    {/foreach}
  {/if}
</div>

{* Narrow Search Options, commented out for now
<div class="{if $sidebarOnLeft}pull-18 sidebarOnLeft{else}last{/if}">
  {if $sideRecommendations}
    {foreach from=$sideRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}
</div>
End Narrow Search Options *}

<div class="clearfix">&nbsp;</div>

<!-- END of: Search/list-none.tpl -->
