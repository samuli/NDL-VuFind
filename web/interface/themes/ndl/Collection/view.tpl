<!-- START of: Collection/view.tpl -->

{js filename="ajax_common.js"}
{js filename="collection_record.js"}
{js filename="check_save_statuses.js"}
{js filename="init_image_popup.js"}
{if !empty($addThis)}
<script type="text/javascript" src="https://s7.addthis.com/js/250/addthis_widget.js?pub={$addThis|escape:"url"}"></script>
{/if}
<div id="collectionHeader">
  <div class="content"><h2>{translate text="Collection Items"}</h2></div>
</div>
<div class="content">
<div id="resultsCollection" class="resultListContainer">
  <div class="record" id="collection{$id|escape}">
    {if $errorMsg || $infoMsg}
    <div class="messages">
      {if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
      {if $infoMsg}<div class="userMsg">{$infoMsg|translate}</div>{/if}
    </div>
    {/if}
    <div class="divCoreMetadata recordId collectionID" id="record{$collectionID|escape}">
      {if $collThumbMedium}
      <div class="alignright">
        <a href="{$collThumbLarge}">
          <img id="fullRecBookCover" onload="checkFullRecImgSize();" style="display: block;" src="{$collThumbMedium}" alt="Collection Display Image">
        </a>
      </div>
      {/if}
      <h1>{$collTitle|escape}</h1>
      <p>{$collSummary|escape}</p>
    </div>
    <div style="clear: left;"></div>
    <span class="Z3988" title="{$openURL|escape}"></span>
    <p><a href="{$url}/Record/{$collectionID|urlencode}">{translate text="Collection Details"}</a></p>
  </div>
	
  <div id="tabnav" >
    <ul>
      <li class="icon collectionContent{if $tab == 'Home' || $tab == '' || $tab == 'list'} active{/if}">
        <a href="{$url}/Collection/{$collectionID|urlencode}/CollectionList{$filters}#tabnav" class="first holdingsView">{translate text='Collection Items'}</a>
      </li>
      {if $hasHierarchyTree}
      <li class="icon collectionHierarchy{if $tab == 'HierarchyTree'} active{/if}">
        <a href="{$url}/Collection/{$collectionID|urlencode}/HierarchyTree{$filters}#tabnav" class="first">{translate text='hierarchy_tree'}</a>
      </li>
      {/if}
      <li class="offscreen{if $tab == 'CollectionMap'} active{/if}" id ="collectionMapTab">
        <a href="{$url}/Collection/{$collectionID|urlencode}/CollectionMap{$filters}#tabnav" class="first">{translate text='Map'}</a>
      </li>
    </ul>
  </div>
  <div class="clear"></div>
  <div class="collectionDetails">
    {if $subpage}
      {include file=$subpage}
    {/if}
  </div>
  <div class="clear"></div>
</div>

<div id="sidebarCollection" class="last">
  {* Recommendations *}
  {if $sideRecommendations}
    {foreach from=$sideRecommendations item="recommendations"}
      {include file=$recommendations}
    {/foreach}
  {/if}
  {* End Recommendations *}
</div>
</div>
{include file="Search/paging.tpl" position="Bottom"}
<div class="clear"></div>

<!-- END of: Collection/view.tpl -->
