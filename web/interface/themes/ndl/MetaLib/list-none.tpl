<!-- START of: MetaLib/list-none.tpl -->

<div class="{if $sidebarOnLeft}last {/if}no-hits">
  <div class="contentHeader noResultHeader"><div class="content"><h1>{translate text='nohit_heading'}</h1></div></div>
  {* tabNavi *}
  {if $searchType != 'advanced'}
    {include file="Search/tabnavi.tpl"}
  {/if}
  <div class="content">
    <div id="resultList" class="{if $sidebarOnLeft}sidebarOnLeft last{/if} grid_17">
    {if $noQuery}
      <div class="metalibError">
        <p class="error">{translate text='metalib_no_query'}</p>
      </div>
    {else}
      <div class="metalibError">
        <p class="error">{translate text='nohit_prefix'} - <strong>{$lookfor|escape:"html"}</strong> - {translate text='nohit_suffix'}</p>
      {if !$userAuthorized && $methodsAvailable}
        <div class="loginNotification">
          <p>{translate text="authorize_user_notification"}</p>
        </div>
      {/if}
        <strong>{translate text='You can'}:</strong>
        <p>- {translate text='Try to search with another phrase'}</p>
        <p>- {translate text='Try with a different search set'}</p>
      </div>
    {/if}

    {if $parseError}
      <div class="metalibError">
        	<p class="error">{translate text='nohit_parse_error'}</p>
      </div>
    {/if}
    </div>
    <div id="sidebarFacets" class="{if $sidebarOnLeft}pull-18 sidebarOnLeft{else}last{/if} grid_6">
      {include file="MetaLib/search-sets.tpl"}
      {include file="MetaLib/database-statuses.tpl"}
    </div>

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

<!-- END of: MetaLib/list-none.tpl -->
