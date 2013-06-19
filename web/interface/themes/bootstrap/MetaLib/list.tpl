<!-- START of: MetaLib/list.tpl -->

{* Main Listing *}
<div class="span12 {if $sidebarOnLeft} push-5 last{/if}">
  {* Recommendations *}
  {if $topRecommendations}
    {foreach from=$topRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}

  {* Listing Options *}
  <div class="row-fluid resulthead">
      {if $failedDatabases}
      <div class="span12">
        <p class="alert alert-error">
          {translate text='Search failed in:'}<br/>
          {foreach from=$failedDatabases item=failed name=failedLoop}
            {$failed|escape}{if !$smarty.foreach.failedLoop.last}<br/>{/if}
          {/foreach}
        </p>
      {/if}
      {if $disallowedDatabases}
        <p class="alert notice">
          {translate text='metalib_not_authorized_results'}
          <br/>
          {foreach from=$disallowedDatabases item=failed name=failedLoop}
            {$failed|escape}{if !$smarty.foreach.failedLoop.last}<br/>{/if}
          {/foreach}
        </p>
      </div> 
      {/if}

      <div class="span12 alert alert-success well-small resultTerm">
      <h4>
      {if $lookfor == ''}{translate text="history_empty_search"}
      {else}
        {if $searchType == 'MetaLib'}{$lookfor|escape:"html"}
        {elseif $searchType == 'MetaLibAdvanced'}{translate text="Your search terms"} : "{$lookfor|escape:"html"}
        {elseif ($searchType == 'MetaLibAdvanced') || ($searchType != 'MetaLibAdvanced' && $orFilters)}
          {foreach from=$orFilters item=values key=filter}
          AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}
        {/if}
        {if $searchType == 'MetaLibAdvanced'}"{/if}
      {/if}
      </h4>
      </div>
      {if $spellingSuggestions}
        <div class="alert alert-info correction">
          <strong>{translate text='spell_suggest'}</strong>:
          {foreach from=$spellingSuggestions item=details key=term name=termLoop}
            <br/>{$term|escape} &raquo; {foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|escape}">{$word|escape}</a>{if $data.expand_url} <a href="{$data.expand_url|escape}"><img src="{$path}/images/silk/expand.png" alt="{translate text='spell_expand_alt'}"/></a> {/if}{if !$smarty.foreach.termLoop.last}, {/if}{/foreach}
          {/foreach}
        </div>
      {/if}
<!--
    </div>
-->
    {include file="Search/paging.tpl" position="Top"}
  </div>
  {* End Listing Options *}

  {if $subpage}
    <!-- START of: {$subpage} -->
    {include file=$subpage}
    <!-- END of: {$subpage} -->
  {else}
    {$pageContent}
  {/if}

  {include file="Search/paging.tpl"}

  <div class="row-fluid searchtools">
    <ul class="span12 unstyled inline well well-small">
      <li><strong>{translate text='Search Tools'}:</strong></li>
  {if $savedSearch}<li><a href="{$url}/MyResearch/SaveSearch?delete={$searchId}" class="delete">{translate text='save_search_remove'}</a></li>{else}<li><a href="{$url}/MyResearch/SaveSearch?save={$searchId}" class="add">{translate text="save_search"}</a></li>{/if}
      <li><a href="{$rssLink|escape}" class="feed">{translate text="Get RSS Feed"}</a></li>
      <li><a href="{$url}/Search/Email" class="mailSearch mail" id="mailSearch{$searchId|escape}" title="{translate text='Email this Search'}">{translate text="Email this Search"}</a></li>
      
    </ul>
  </div>

{* End Main Listing *}

{* Narrow Search Options *}
{*
<div class="span-5 {if $sidebarOnLeft}pull-18 sidebarOnLeft{else}last{/if}">
  {if $sideRecommendations}
    {foreach from=$sideRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}
</div>
*}
{* End Narrow Search Options *}

<div class="clear"></div>

{js filename="openurl.js"}
{* Fancybox for images *}
{js filename="init_fancybox.js"}


<!-- END of: MetaLib/list.tpl -->
