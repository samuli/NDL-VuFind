<!-- START of: MyResearch/list.tpl -->

{js filename="bulk_actions.js"}
{js filename="init_fancybox.js"}
{if $bookBag}
<script type="text/javascript">
vufindString.bulk_noitems_advice = "{translate text="bulk_noitems_advice"}";
vufindString.confirmEmpty = "{translate text="bookbag_confirm_empty"}";
vufindString.viewBookBag = "{translate text="View Book Bag"}";
vufindString.addBookBag = "{translate text="Add to Book Bag"}";
vufindString.removeBookBag = "{translate text="Remove from Book Bag"}";
vufindString.itemsAddBag = "{translate text="items_added_to_bookbag"}";
vufindString.itemsInBag = "{translate text="items_already_in_bookbag"}";
vufindString.bookbagMax = "{$bookBag->getMaxSize()}";
vufindString.bookbagFull = "{translate text="bookbag_full_msg"}";
vufindString.bookbagStatusFull = "{translate text="bookbag_full"}";
</script>
{/if}

{include file="MyResearch/menu.tpl"}

<div class="well-small myResearch">
  {if $errorMsg || $infoMsg}
  <div class="row-fluid">
    <div class="span12 resultHead">
      <div class="messages">
      {if $errorMsg}<p class="alert alert-error">{$errorMsg|translate}</p>{/if}
      {if $infoMsg}<p class="alert alert-info">{$infoMsg|translate}{if $showExport} <a class="save" target="_new" href="{$showExport|escape}">{translate text="export_save"}</a>{/if}</p>{/if}
      </div>
    </div>
  </div>
  {/if}
  <div class="row-fluid">
    <div id="sidebarFavoritesLists" class="span4">
    {if $listList}
      <h4 class="lead">{translate text='Your Lists'}</h4>
  {*
      <a href="{$url}/MyResearch/ListEdit" class="btn btn-small btn-success pull-right listAdd" id="listAdd" title="{translate text='Create a List'}"><i class="icon-plus-sign icon-white"></i>&nbsp;{translate text='Create a List'}</a-->
  <!--
      <p class="clearfix"></p>
  -->
  *}
      <ul class="unstyled">
        {foreach from=$listList item=listItem}
        <li>
          {if $list && $listItem->id == $list->id}
          <a href="{$url}/MyResearch/ListEdit" class="btn btn-small btn-success pull-right listAdd" id="listAdd" title="{translate text='Create a List'}"><i class="icon-plus-sign icon-white"></i>&nbsp;{translate text='Create a List'}</a> 
          <div class="well well-small selected">{$listItem->title|escape:"html"}&nbsp;<span class="favoritesCount">({$listItem->cnt})</span></div>
            {if $listEditAllowed}
          
          <div class="editList">
            <a class="btn btn-small edit" href="{$url}//MyResearch/EditList/{$list->id|escape:"url"}"><i class="icon-pencil"></i>&nbsp;{translate text="edit_list"}</a>
            <a class="btn btn-small btn-danger pull-right delete" href="{$url}/Cart/Home?listID={$list->id|escape}&amp;listName={$list->title|escape}&amp;origin=Favorites&amp;listFunc=editList&amp;deleteList=true"><i class="icon-remove icon-white"></i>&nbsp;{translate text="delete_list"}</a>
          </div>
            {/if}
          {else}
          <div class="well-small listItem"><a href="{$url}/MyResearch/MyList/{$listItem->id|escape:"url"}">{$listItem->title|escape:"html"}</a>&nbsp;<span class="favoritesCount">({$listItem->cnt})</span></div>
          {/if}
        </li>
       {/foreach}
      </ul>
    {/if}
    {if $tagList}
      <div class="clearfix">&nbsp;</div>
      <div>
        <span class="lead">{if $list}{translate text='Tags'}: {$list->title|escape:"html"}{else}{translate text='Your Tags'}{/if}</span>
        {if $tags}
        <ul>
          {foreach from=$tags item=tag}
          <li>{translate text='Tag'}: {$tag|escape:"html"}
            <a href="{$url}/MyResearch/{if $list}MyList/{$list->id}{else}Favorites{/if}?{foreach from=$tags item=mytag}{if $tag != $mytag}tag[]={$mytag|escape:"url"}&amp;{/if}{/foreach}">X</a>
          </li>
          {/foreach}
        </ul>
        {/if}
              
        <ul>
        {foreach from=$tagList item=tag}
          <li><a href="{$url}/MyResearch/{if $list}MyList/{$list->id}{else}Favorites{/if}?tag[]={$tag->tag|escape:"url"}{foreach from=$tags item=mytag}&amp;tag[]={$mytag|escape:"url"}{/foreach}">{$tag->tag|escape:"html"}</a> ({$tag->cnt})</li>
          {/foreach}
        </ul>
      </div>
    {/if}
      <div class="clearfix">&nbsp;</div>
    </div>

    <div class="span8 favoritesList last">
    {if $list && $list->id}
      <h4 class="lead myResearchTitle">{$list->title|escape:"html"}</h4>
      {if $list->description}<p class="favoritesDescription">{$list->description|escape}</p>{/if}
    {else}
      <span class="lead">{translate text='Your Favorites'}</span><br/>
    {/if}
    {if $resourceList}
      <div class="pull-left">
      {include file="Search/paging.tpl" position="Top"}
      </div>
      <div class="pull-right floatright small resultOptions">
        <form action="{$path}/Search/SortResults" method="post" class="form-inline pull-right">
          <label for="sort_options_1">{translate text='Sort'}
          <select id="sort_options_1" name="sort" class="selectpicker jumpMenu" data-style="btn-small">
          {foreach from=$sortList item=sortData key=sortLabel}
            <option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
          {/foreach}
          </select>
          </label>
          <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
        </form>
      </div>
      <div class="clearfix">&nbsp;</div>

    <form method="post" name="bulkActionForm" action="{$url}/Cart/Home">
      <input type="hidden" name="origin" value="Favorites" />
      <input type="hidden" name="followup" value="true" />
      <input type="hidden" name="followupModule" value="MyResearch" />
      <input type="hidden" name="followupAction" value="{if $list}MyList/{$list->id}{else}Favorites{/if}" />
      {if $list && $list->id}
      <input type="hidden" name="listID" value="{$list->id|escape}" />
      <input type="hidden" name="listName" value="{$list->title|escape}" />
      {/if}

          <table class="table table-hover">
            <tr>
              <th class="bulkActionButtons" style="vertical-align: middle;">
                <div class="text-center pull-left allCheckboxBackground"><input type="checkbox" class="selectAllCheckboxes" name="selectAll" id="addFormCheckboxSelectAll" />
                </div>
              </th>
              <th colspan="2" class="span11">
                <div class="text-right floatright">{translate text="with_selected"}:&nbsp;&nbsp; 
                {if $bookBag}
                  <a id="updateCart" class="bookbagAdd offscreen" href="">{translate text='Add to Book Bag'}</a>
                  <noscript>
                    <input type="submit"  class="button bookbagAdd" name="add" value="{translate text='Add to Book Bag'}"/>
                  </noscript>
                {/if}
                {if $listList}
                  <select name="move" class="selectpicker span3" data-style="btn-small">
                    <option value="">{translate text="move_to_list"}</option>
                    {foreach from=$listList item=listItem}
                      {if !$list || $listItem->id != $list->id}
                    <option value="{$listItem->id|escape}">{$listItem->title|escape:"html"}</option>
                      {/if}
                    {/foreach}
                  </select>
                  <select name="copy" class="selectpicker span3" data-style="btn-small">
                    <option value="">{translate text="copy_to_list"}</option>
                    {foreach from=$listList item=listItem}
                      {if !$list || $listItem->id != $list->id}
                    <option value="{$listItem->id|escape}">{$listItem->title|escape:"html"}</option>
                      {/if}
                    {/foreach}
                  </select>
                {/if}  
                  <input type="submit" class="btn btn-small btn-info button" name="email" value="{translate text='Email this'}" title="{translate text='Email this'}"/>
                  {if is_array($exportOptions) && count($exportOptions) > 0}
                  <input type="submit" class="btn btn-small btn-info input-small button" name="export" value="{translate text='export_expanding'}" title="{translate text='export_expanding'}"/>
                  {/if}
                  {if $listEditAllowed}<input id="delete_list_items_{if $list}{$list->id|escape}{/if}" type="submit" class="btn btn-small btn-danger button" name="delete" value="{translate text='Delete'}" title="{translate text='delete_selected'}"/>{/if}
                </div>
              </th>
            </tr>
          {foreach from=$resourceList item=resource name="recordLoop"}
            <tr class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
              <td colspan="3">
                <span class="recordNumber">{$recordStart+$smarty.foreach.recordLoop.iteration-1}</span>
                  {* This is raw HTML -- do not escape it: *}
                  {$resource}
              </td>
            </tr>
          {/foreach}


        </table>

    </form>
      <hr class="clearfix" />
      <div class="pull-left">
      {include file="Search/paging.tpl" position="Bottom"}
      </div>
    {else}
      <div class="alert alert-info noContentMessage">{translate text='You do not have any saved resources'}</div>
    {/if}
    </div>
  </div>
  <div class="clearfix">&nbsp;</div>
</div>
 


<!-- END of: MyResearch/list.tpl -->
