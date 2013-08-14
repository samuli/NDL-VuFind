<!-- START of: Collection/view-hierarchyTree_JSTree.tpl -->

{js filename="jsTree/jquery.jstree.js"}
<script type="text/javascript">
{literal}$.jstree._themes = "{/literal}{path filename="jsTree/themes/"}";
</script>
{js filename="hierarchyTree_JSTree.js"}
<script type="text/javascript">
    vufindString.lightboxMode = false;
    vufindString.fullHierarchy = {if $treeSettings.fullHierarchyRecordView == true || $disablePartialHierarchy == true}true{else}false{/if};
    vufindString.showTree = "{translate text="hierarchy_show_tree"}";
    vufindString.hideTree = "{translate text="hierarchy_hide_tree"}";
</script>
{if $showTreeSelector}
  <div id="treeSelector">
  {foreach from=$hasHierarchyTree item=hierarchyTitle key=hierarchy}
    <a class="tree{if $hierarchyID == $hierarchy} currentTree{/if}" href="{$url}/Collection/{$id}/HierarchyTree?hierarchy={$hierarchy}">{$hierarchyTitle}</a>
  {/foreach}
  </div>
{/if}
{if $hierarchyID}
  	<div id="hierarchyTreeHolder">
  {if $showTreeSearch}
    <div id="treeSearch" class="span12">
      <div class="well well-small text-right">
        <span id="treeSearchNoResults" class="label label-important pull-left">{translate text="No results"}</span>
        <span id="treeSearchLoadingImg"><img src="{$path}/images/loading.gif"/></span>
        <input id="treeSearchText" class="input-medium" type="text" value="" />
        <select id="treeSearchType" name="type" class="selectpicker" data-style="btn-mini">
          <option value="AllFields">{translate text="All Fields"}</option>
          <option value="Title">{translate text="Title"}</option>
        </select>
        <input id="search" class="btn btn-info btn-mini" type="button" value="{translate text='Search'}" />
       </div>
    </div>
    <div id="treeSearchLimitReached" class="row-fluid">
      <span class="span12 alert">
        {translate text="Your search returned too many results to display in the tree. Showing only the first"} <strong>{$treeSearchLimit}</strong> {translate text="items. For a full search click"} <a id="fullSearchLink" href="{$treeSearchFullURL}" target="_blank">{translate text="here"}.</a>
      </span>
    </div>
	{/if}
    <div class="row-fluid">
    <div id="hierarchyTree" class="span12">
      <input type="hidden" value="{$id|escape}" class="hiddenRecordId" />
      <input type="hidden" value="{$hierarchyID|escape}" class="hiddenHierarchyId" />
      <input type="hidden" value="{$context|escape}" class="hiddenContext" />
      <noscript>
        {$hierarchyTree}
      </noscript>
    </div>
    </div>
  </div>
{/if}

  <div id="hierarchyRecord">
{if $collectionRecord}
  {if $collectionRecord == "unknown"}
    <h4>{translate text="Unknown Record"}</h4>
    <p class="alert alert-error">{translate text="We have been unable to locate record"} <strong>{$recordID}</strong></p>
  {else}
    <!-- START of: {$collectionRecord} -->
    {include file=$collectionRecord}
    <!-- END of: {$collectionRecord} -->
  {/if}
{/if}
  </div>

<div class="clearfix">&nbsp;</div>

<!-- END of: Collection/view-hierarchyTree_JSTree.tpl -->
