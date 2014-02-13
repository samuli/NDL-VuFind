<!-- START of: PCI/list-none.tpl -->

<div class="{if $sidebarOnLeft}last {/if}no-hits">
  <div class="contentHeader noResultHeader"><div class="content"><h1>{translate text='nohit_heading'}</h1></div></div>
  {* tabNavi *}
  {include file="Search/tabnavi.tpl"}
  <div class="content">
    <div id="resultList" class="{if ($sidebarOnLeft && (!empty($filterList) || $checkboxStatus != false))}sidebarOnLeft last{/if} grid_17">
      <p class="error">{translate text='nohit_prefix'} - <strong>{$lookfor|escape:"html"}</strong> - {translate text='nohit_suffix'}</p>

    {if !empty($filterList) || $checkboxStatus != false} 
      {php}
        // Generate link to a non-prefiltered search
        parse_str($this->get_template_vars('searchParams'), $paramsArray);
        unset($paramsArray['orfilter'], $paramsArray['prefiltered'], $paramsArray['filter']);
        $url = $this->get_template_vars('url') . '/PCI/Search?';
        $this->assign('searchWithoutPrefilter', $url . http_build_query($paramsArray));
      {/php}
      <p><a id="searchWithoutPrefilter" href="{$searchWithoutPrefilter}"><strong>{translate text='Search without the prefilter'}</strong></a></p>
    {/if}
  
    {if $parseError}
      <p class="error">{translate text='nohit_parse_error'}</p>
    {/if}

    {if $spellingSuggestions}
      <div class="correction">{translate text='nohit_spelling'}:<br/>
      {foreach from=$spellingSuggestions item=details key=term name=termLoop}
        {$term|escape} &raquo; {foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a href="{$data.expand_url|escape}"><img src="{$path}/images/silk/expand.png" alt="{translate text='spell_expand_alt'}"/></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}{if !$smarty.foreach.termLoop.last}<br/>{/if}
      {/foreach}
      </div>
    {/if}

    {* Recommendations *}
    {if $topRecommendations}
      {foreach from=$topRecommendations item="recommendations"}
        {include file=$recommendations}
      {/foreach}
    {/if}

    {if $noResultsRecommendations}
      {foreach from=$noResultsRecommendations item="recommendations" key='key' name="noResults"}
        {include file=$recommendations}
      {/foreach}
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

    {if !empty($filterList) || $checkboxStatus != false}
    <div id="sidebarFacets" class="{if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if} grid_6">
      {include file=$sideRecommendations.SideFacets}
    </div>
    {/if}
  </div>
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
<div class="clear"></div>

<!-- END of: PCI/list-none.tpl -->
