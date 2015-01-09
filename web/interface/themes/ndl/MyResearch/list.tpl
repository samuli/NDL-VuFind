<!-- START of: MyResearch/list.tpl -->
<script type="text/javascript">
vufindString.error = "{translate text="An error has occurred"}";
vufindString.authError = "{translate text="You must be logged in first"}";
</script>
 
{js filename="bulk_actions.js"}
{js filename="init_image_popup.js"}
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

<div class="myResearch">
  <div class="content">
    <div class="grid_24">
      <div class="resultHead">
          <div class="messages {if !$errorMsg && !$infoMsg}hiddenElement{/if}">
              <p class="error {if !$errorMsg}hiddenElement{/if}">{if $errorMsg}{$errorMsg|translate}{/if}</p>
            {if $infoMsg}<p class="info">{$infoMsg|translate}{if $showExport} <a class="save" target="_new" href="{$showExport|escape}">{translate text="export_save"}</a>{/if}</p>{/if}
          </div>
      </div>
      <div class="favoritesList last" {if $list && $list->id}data-listid="{$list->id|escape:"url"}"{/if}>
        {if $list && $list->id}
          <div class="dynamicInput myResearchTitle clearfix autoSubmit notEmpty">
            <h2 class="transform">{if $list->title == 'My Favorites'}{translate text=$list->title}{else}{$list->title|escape:"html"}{/if}</h2>
            {if $listEditAllowed}<a class="icon edit" title="{translate text="edit_list"}" href="#"></a>
            <input class="hiddenElement" type="text" name="title_change" value="" />{/if}
          </div>
          <br>
          <div class="dynamicInput listDescription clearfix autoSubmit">
            <div data-placeholder="{translate text="Add list description"}" class="transform{if !$list->description} placeholder">{translate text="Add list description"}{else}">{$list->description|escape:"html"}{/if}</div>
            {if $listEditAllowed}<a class="icon {if !$list->description}add{else}edit{/if}" title="{if !$list->description}{translate text="Edit list description"}{else}{translate text="Add list description"}{/if}" href="#"></a>
              <textarea class="hiddenElement" rows="2" cols="50" type="text" name="description_change" value=""></textarea>{/if}
          </div>
        {else}
          <h2>{translate text='Your Favorites'}</h2>  
        {/if}
        {if $resourceList}
          <div class="recordNumbers">
            <span class="currentPage">{$recordStart}&#8201;-&#8201;{$recordEnd} /</span>
            <span class="resultTotals">{$recordCount} {translate text="records"}</span>
          </div>
          <div class="floatright small resultOptions">
            <form action="{$path}/Search/SortResults" method="post">
              <label for="sort_options_1">{translate text='Sort'}</label>
              <select id="sort_options_1" name="sort" class="jumpMenu">
                {foreach from=$sortList item=sortData key=sortLabel}
                  <option value="{$sortData.sortUrl|escape}"{if $sortData.selected} selected="selected"{/if}>{translate text=$sortData.desc}</option>
                {/foreach}
              </select>
              <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
            </form>
          </div>
          <div class="clear"></div>
          <div id="myFavoritesList">
          <form method="post" name="bulkActionForm" action="{$url}/Cart/Home">
            <input type="hidden" name="origin" value="Favorites" />
            <input type="hidden" name="followup" value="true" />
            <input type="hidden" name="followupModule" value="MyResearch" />
            <input type="hidden" name="followupAction" value="{if $list}MyList/{$list->id}{else}Favorites{/if}" />
            {if $list && $list->id}
              <input type="hidden" name="listID" value="{$list->id|escape}" />
              <input type="hidden" name="listName" value="{$list->title|escape}" />
            {/if}
            <div class="bulkActionButtons">
              <div>
                {if $bookBag}
                  <a id="updateCart" class="bookbagAdd offscreen" href="">{translate text='Add to Book Bag'}</a>
                  <noscript>
                    <input type="submit"  class="button bookbagAdd" name="add" value="{translate text='Add to Book Bag'}"/>
                  </noscript>
                {/if}
                <input type="submit" class="button buttonFinna" name="email" value="{translate text='Email this'}" title="{translate text='Email this'}"/>
                {if is_array($exportOptions) && count($exportOptions) > 0}
                  <input type="submit" class="button buttonFinna" name="export" value="{translate text=export_selected}..." title="{translate text='export_selected'}"/>
                {/if}
                {if $listList}
                  <dl class="dropdown dropdownStatic stylingDone copy_to_list ">
                    <dt><a href="#">{translate text="copy_to_list"}</a></dt>
                    <dd>
                      <ul>
                        {foreach from=$listList item=listItem}
                          {if !$list || $listItem->id != $list->id}
                            <li><a class="big" href="#"><span>{$listItem->title|escape:"html"}</span><span class="value">{$listItem->id|escape}</span></a></li>
                          {/if}
                        {/foreach}
                      </ul>
                    </dd>
                  </dl>
                  <select id="copy_to_list" name="copy" class="jumpMenu stylingDone" style="display:none;">
                    {foreach from=$listList item=listItem}
                      {if !$list || $listItem->id != $list->id}
                        <option value="{$listItem->id|escape}">{$listItem->title|escape:"html"}</option>
                      {/if}
                    {/foreach}
                  </select>
                {/if}  
                {if $listEditAllowed}
                  
                  <input id="delete_list_items_{if $list}{$list->id|escape}{/if}" type="submit" class="button buttonFinna" name="delete" value="{translate text='delete_selected'}" title="{translate text='delete_selected'}"/>
                {/if}
                <a href="#" class="button buttonFinna checkBoxDeselectAll">{translate text="Reset"}</a>
              </div>
              <div class="clear"></div>
            </div> 
            {if empty($pageLinks.pages)}
              {php}
                $pageLinks = $this->get_template_vars('pageLinks');
                $pageLinks['pages'] = 1;
                $this->assign('pageLinks', $pageLinks);
              {/php}
            {/if} 
            {include file="Search/paging.tpl" position="Top"}
            <div class="checkboxFilter favorites">
             <div class="allCheckboxBackground">
              <input type="checkbox" class="selectAllCheckboxes" name="selectAll" id="addFormCheckboxSelectAll" />
              <label for="addFormCheckboxSelectAll">{translate text="adv_search_select_all"}</label>
             </div>
            </div>
            <ul class="recordSet">
              {foreach from=$resourceList item=resource name="recordLoop"}
                <li class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
                  <span class="recordNumber">{$recordStart+$smarty.foreach.recordLoop.iteration-1}</span>
                  {* This is raw HTML -- do not escape it: *}
                  {$resource}
                </li>
              {/foreach}
            </ul>
          </form>
          <div class="resultOptionLimit"> 
            {if $limitList|@count gt 1}
              <form action="{$path}/Search/LimitResults" method="post">
                <label for="limit">{translate text='Results per page'}</label>
                <select class="jumpMenu" id="limit" name="limit">
                  {foreach from=$limitList item=limitData key=limitLabel}
                    <option value="{$limitData.limitUrl|escape}"{if $limitData.selected} selected="selected"{/if}>{$limitData.desc|escape}</option>
                  {/foreach}
                </select>
                <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
              </form> 
            {/if} 
          </div>
        </div>
        <div class="clear"></div>
        {include file="Search/paging.tpl" position="Bottom"}
        {else}
          <div class="noContentMessage">{translate text='You do not have any saved resources'}</div>
        {/if}
      </div>
      <div id="sidebarFavoritesLists">
        {if $listList}
          <span class="hefty">{translate text='Your Lists'}</span>
          <ul>
              <li class="hiddenElement sidebarListTemplate">
                  <div class="listItem"><div><a href="{$url}/MyResearch/MyList/"><span class="favoritesCount">(0)</span></a></div></div>
              </li>
            {foreach from=$listList item=listItem}
              <li>
                {if $list && $listItem->id == $list->id}
                  <div class="selected" data-list-id="{$list->id}">
                    <div>
                      <span class="publicStatus {if !$list->public == 1}hiddenElement{/if}"></span>
                      <span class="sidebarListTitle">{if $listItem->title == 'My Favorites'}{translate text=$listItem->title}{else}{$listItem->title|escape:"html"}{/if}</span>&nbsp;<span class="favoritesCount">({$listItem->cnt})</span>
                      {if $listEditAllowed}
                        <div class="editList">
                          <a class="icon delete" title="{translate text="delete_list"}" href="{$url}/Cart/Home?listID={$list->id|escape}&amp;listName={$list->title|escape}&amp;origin=Favorites&amp;listFunc=editList&amp;deleteList=true"></a>
                        </div>
                      {/if}
                    </div>
                    <div class="listVisibility">
                      {translate text="Visibility"}
                      <div class="dynamicInput dynamicRadioButton isListPublic">
                        <input id="list_public_1" type="radio" name="publicity_change" value="1" {if $list->public == 1}checked="checked"{/if}/> <label for="list_public_1">{translate text="Public"}</label>
                        <input id="list_public_0" type="radio" name="publicity_change" value="0" {if $list->public == 0}checked="checked"{/if}/> <label for="list_public_0">{translate text="Private"}</label> 
                      </div>
                      <div class="publicListURL {if $list->public == 0}hiddenElement{/if}">
                        {translate text="Public list URL"}
                        <div><a href="{$url}/List/{$list->id|escape:"url"}">{$url}/List/{$list->id|escape:"url"}</a></div>
                      </div>
                    </div>
                  </div>
                {else}
                  <div class="listItem"><div><a href="{$url}/MyResearch/MyList/{$listItem->id|escape:"url"}"><span class="publicStatus {if !$listItem->public == 1}hiddenElement{/if}"></span>{if $listItem->title == 'My Favorites'}{translate text=$listItem->title}{else}{$listItem->title|escape:"html"}{/if}&nbsp;<span class="favoritesCount">({$listItem->cnt})</span></a></div></div>
                {/if}
              </li>
            {/foreach}
          </ul>
          <div class="dynamicInput addNewList notEmpty">
            <div id="listAdd" data-placeholder="{translate text='Create a List'}"class="transform placeholder">{translate text='Create a List'}</div>
            <a class="listAdd add" title="{translate text="add_list"}" href="#"></a>
            <input class="hiddenElement" type="text" name="list_add" value="" />
          </div>
        {/if}
      </div>
    </div>
  </div>
  <div class="clear"></div>
</div>

<!-- END of: MyResearch/list.tpl -->
