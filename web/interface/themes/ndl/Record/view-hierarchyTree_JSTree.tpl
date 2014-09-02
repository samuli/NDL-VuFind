<!-- START of: Record/view-hierarchyTree_JSTree.tpl -->

<script type="text/javascript">
vufindString.moreLeaves = "{translate text="More"}...";
</script>
{js filename="hierarchyTree_JSTree.js"}
<div class="content">
  <div class="grid_24">
    {if $hierarchyID}
    <div id="hierarchyTreeHolder">
        <div id="hierarchyTree" class="hierarchyLoading"></div>
    </div>
    {/if}
  </div> 
</div>

{literal}
<script type="text/javascript">
// Get document id from smarty variable
var q = '{/literal}{$id}{literal}';

// Load initial hierarchy tree
$(function() { 
  initHierarchyTree(q);
});
</script>
{/literal}

<!-- END of: Record/view-hierarchyTree_JSTree.tpl -->
