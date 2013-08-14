<div class="span12 well-small">
  {* Recommendations *}
  {if $topRecommendations}
    {foreach from=$topRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}
  <div class="resulthead"><h3>{translate text='nohit_heading'}</h3></div>
  <p class="alert alert-error">{translate text='nohit_prefix'} - <strong>{$lookfor|escape:"html"}</strong> - {translate text='nohit_suffix'}</p>

  {if $parseError}
    <p class="alert alert-error">{translate text='nohit_parse_error'}</p>
  {/if}

  {if $spellingSuggestions}
  <div class="correction">{translate text='nohit_spelling'}:<br/>
    {foreach from=$spellingSuggestions item=details key=term name=termLoop}
      {$term|escape} &raquo; {foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a href="{$data.expand_url|escape}"><img src="{$path}/images/silk/expand.png" alt="{translate text='spell_expand_alt'}"/></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}{if !$smarty.foreach.termLoop.last}<br/>{/if}
    {/foreach}
  </div>
  {/if}
  {if $searchType == 'PCIAdvanced'}
    <div class="editSearch">
      <p><a href="{$path}/PCI/Advanced?edit={$searchId}"><strong>{translate text="Edit this Advanced PCI Search"}</strong></a></p>
      <p><a href="{$path}/PCI/Advanced"><strong>{translate text="Start a new Advanced PCI Search"}</strong></a></p>
      {if $dualResultsEnabled}
        <p><a href="{$path}/"><strong>{translate text="Start a new Basic Search"}</strong></a></p>
      {else}
        <p><a href="{$path}/PCI/Home"><strong>{translate text="Start a new Basic PCI Search"}</strong></a></p>
      {/if}
    </div>
  {/if}
</div>

  
{* Narrow Search Options *}
<div class="span-5 {if $sidebarOnLeft}pull-18 sidebarOnLeft{else}last{/if}">
  {if $sideRecommendations}
    {foreach from=$sideRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}
</div>
{* End Narrow Search Options *}

<div class="clear"></div>
