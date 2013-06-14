<!-- START of: Record/view.tpl -->

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
{assign var=bookBagItems value=$bookBag->getItems()}
{/if}
{if isset($syndetics_plus_js)}
<script src="{$syndetics_plus_js}" type="text/javascript"></script>
{/if}
{if !empty($addThis)}
<script type="text/javascript" src="https://s7.addthis.com/js/300/addthis_widget.js#pub={$addThis|escape:"url"}"></script>
{/if}

{js filename="record.js"}
{js filename="check_save_statuses.js"}
{if $showPreviews}
  {js filename="preview.js"}
{/if}
{if $coreOpenURL || $holdingsOpenURL}
  {js filename="openurl.js"}
{/if}
{if $metalibEnabled}
{js filename="metalib_links.js"}
{/if}

{* <div class="span-10{if $sidebarOnLeft} push-5 last{/if}"> *}

{if $errorMsg || $infoMsg || $lastsearch || $previousRecord || $nextRecord}
<div class="row-fluid">

  {if $errorMsg || $infoMsg}
  <div class="span12 messages">
    {if $errorMsg}<div class="alert alert-error">{$errorMsg|translate}</div>{/if}
    {if $infoMsg}<div class="alert alert-info">{$infoMsg|translate}</div>{/if}
  </div>
  {/if}

  {if $lastsearch}
  <div class="span3 backToResults well-small">
    <a href="{$lastsearch|escape}#record{$id|escape:"url"}">&laquo;&nbsp;{translate text="Back to Search Results"}</a>
	</div>
  {/if}

{*
  {if $previousRecord || $nextRecord}
  <ul class="span9 pager">
    <li class="{if !$pageLinks.back} disabled{/if}">{if $pageLinks.back}{$pageLinks.back}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.prevImg}</span>{/if}</li>
    <li>&nbsp;  {$recordStart} - {$recordEnd} / {$recordCount} &nbsp;</li>
    <li class="{if !$pageLinks.next} disabled{/if}">{if $pageLinks.next}{$pageLinks.next}{else}<span class="pagingDisabled">{$pageLinks.pagerOptions.nextImg}</span>{/if}</li>
  </ul>
  {/if}
*}

  {if $previousRecord || $nextRecord}
  <div class="span6 resultscroller well-small">

    <ul class="pager">
      <li class="{if !$previousRecord} disabled{/if}">
      {if $previousRecord}
        <a href="{$url}/Record/{$previousRecord}" class="prevRecord">&larr;<span class="resultNav">&nbsp;{translate text="Prev"}</span></a>
      {else}
        <span class="pagingDisabled">&larr;&nbsp;{translate text="Prev"}</span>
      {/if}
      </li>
      <li>&nbsp;&nbsp;{$currentRecordPosition}&nbsp;<strong>/</strong>&nbsp;{$resultTotal}&nbsp;&nbsp;</li>
      <li class="{if !$nextRecord} disabled{/if}">
      {if $nextRecord}
        <a href="{$url}/Record/{$nextRecord}" class="nextRecord"><span class="resultNav">{translate text="Next"}&nbsp;</span>&rarr;</a>
      {else}
        <span class="pagingDisabled">{translate text="Next"}&nbsp;&rarr;</span>
      {/if}
      </li>
    </ul>

<!--
    {if $previousRecord}
    <a href="{$url}/Record/{$previousRecord}" class="prevRecord">&laquo;<span class="resultNav">&nbsp;{translate text="Prev"}</span></a>
    {else}
    <span class="prevRecord inactive">&laquo;<span class="resultNav">&nbsp;{translate text="Prev"}</span></span>
    {/if}
    {$currentRecordPosition} / {$resultTotal}
    {* #{$currentRecordPosition} {translate text='of'} {$resultTotal} *}

    {if $nextRecord}
    <a href="{$url}/Record/{$nextRecord}" class="nextRecord">
      <span class="resultNav">{translate text="Next"}&nbsp;</span>&raquo;
    </a>
    {else}
    <span class="nextRecord inactive">{translate text="Next"} &raquo;</span>
    {/if}
-->
	</div>
	{/if}


</div>
{/if} {* $errorMsg || ... *}

<div class="row-fluid record recordId" style="padding: 0" id="record{$id|escape}">

  <div id="resultMain" class="span9">

  <div class="row-fluid">
    <div id="resultSide" class="span4">
  
    {* Display Cover Image *}
    <div class="coverImages clearfix">
    {if $coreThumbMedium}


        {assign var=img_count value=$coreImages|@count}
        {if $img_count > 1}
          <div class="coverImageLinks">
        {foreach from=$coreImages item=desc name=imgLoop}
            <a href="{$path}/thumbnail.php?id={$id|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=large" class="title fancybox fancybox.image" onmouseover="document.getElementById('thumbnail').src='{$path}/thumbnail.php?id={$id|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=medium'; document.getElementById('thumbnail_link').href='{$path}/thumbnail.php?id={$id|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=large'; return false;" style="background-image:url('{$path}/thumbnail.php?id={$id|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=small');" rel="{$id|escape:"url"}"><span></span>
              {*if $desc}{$desc|escape}{else}{$smarty.foreach.imgLoop.iteration + 1}{/if
              <img src="{$path}/thumbnail.php?id={$id|escape:"url"}&index={$smarty.foreach.imgLoop.iteration-1}&size=small" />
              *}
            </a>
          {/foreach}
          </div>
        {/if}
        
        {if $coreThumbLarge}<a id="thumbnail_link" href="{$coreThumbLarge|escape}" onclick="launchFancybox(this); return false;" rel="{$id|escape:"url"}">{/if}
        <span></span><img id="thumbnail" alt="{translate text="Cover Image"}" class="recordcover" src="{$coreThumbMedium|escape}" style="padding:0" />
        {if $coreThumbLarge}</a>
        {js filename="init_fancybox.js"}
        {/if}
        
        {else}
        {* <img src="{$path}/bookcover.php" alt="{translate text='No Cover Image'}"> *}
    {/if}
    </div>
    {* End Cover Image *}
    <div class="clearfix"></div>  
    <div id="resultToolbar" class="toolbar alert alert-info">
      <ul class="unstyled">
        <li id="saveLink"><a href="{$url}/Record/{$id|escape:"url"}/Save" class="saveRecord add" id="saveRecord{$id|escape}" title="{translate text="Add to favorites"}">{*<i class="icon fav"></i>*}{translate text="Add to favorites"}</a></li>
        
        {* SMS commented out for now
        <li><a href="{$url}/Record/{$id|escape:"url"}/SMS" class="smsRecord" id="smsRecord{$id|escape}" title="{translate text="Text this"}"><i class="icon sms"></i>{translate text="Text this"}</a></li>
        *}
        {* Mail moved before addThis social media icons 
        <li><a href="{$url}/Record/{$id|escape:"url"}/Email" class="mailRecord mail" id="mailRecord{$id|escape}" title="{translate text="Email this"}">{translate text="Email this"}</a></li>
        *}
        <li><a href="{$url}/Record/{$id|escape:"url"}/Feedback" class="feedbackRecord" id="feedbackRecord{$id|escape}" title="{translate text="Send Feedback"}">{*<i class="icon mail"></i>*}{translate text="Send Feedback"}</a></li>
        {if is_array($exportFormats) && count($exportFormats) > 0}
        <li>
          <a href="{$url}/Record/{$id|escape:"url"}/Export?style={$exportFormats.0|escape:"url"}" class="exportMenu export">{*<i class="icon export"></i>*}{translate text="Export Record"} {image src="down.png" width="11" height="6" alt=""}</a>
          <ul class="menu offscreen" id="exportMenu">
          {foreach from=$exportFormats item=exportFormat}
            <li><a {if $exportFormat=="RefWorks"}target="{$exportFormat}Main" {/if}href="{$url}/Record/{$id|escape:"url"}/Export?style={$exportFormat|escape:"url"}">{translate text="Export to"} {$exportFormat|escape}</a></li>
          {/foreach}
            <li>
              <div class="qr_wrapper">
              <div id="qrcode"><span class="overlay"></span></div>
              {js filename="qrcodeNDL.js"}
              </div>
            </li>
          </ul>
        </li>
        {/if}
        {* Citation commented out for now
        <li><a href="{$url}/Record/{$id|escape:"url"}/Cite" class="citeRecord cite" id="citeRecord{$id|escape}" title="{translate text="Cite this"}">{translate text="Cite this"}</a></li> *}
        {* AddThis-Bookmark commented out
        {if !empty($addThis)}
        <li id="addThis"><a class="addThis addthis_button"" href="https://www.addthis.com/bookmark.php?v=250&amp;pub={$addThis|escape:"url"}">{translate text="Bookmark"}</a></li>
        {/if} *}
        {* AddThis for social sharing START *}
		{if !empty($addThis)}
		<li id="addThis">
        <div class="truncateField">
		 	<div class="addthis_toolbox addthis_default_style ">
        <a href="{$url}/Record/{$id|escape:"url"}/Email" class="mailRecord mail" id="mailRecord{$id|escape}" title="{translate text="Email this"}"></a>
				<a class="addthis_button_facebook"></a>
				<a class="addthis_button_twitter"></a>
				<a class="addthis_button_google_plusone_share"></a>
			</div>
		</div>
		</li>
        {/if}
        {* Addthis for social sharing END *}
        {if $bookBag}
        <li><a id="recordCart" class="{if in_array($id|escape, $bookBagItems)}bookbagDelete{else}bookbagAdd{/if} offscreen" href="">{translate text="Add to Book Bag"}</a></li>
        {/if}
      </ul>
      {if $bookBag}
      <div class="cartSummary">
      <form method="post" name="addForm" action="{$url}/Cart/Home">
        <input id="cartId" type="hidden" name="ids[]" value="{$id|escape}" />
        <noscript>
          {if in_array($id|escape, $bookBagItems)}
          <input id="cartId" type="hidden" name="ids[]" value="{$id|escape}" />
          <input type="submit" class="button cart bookbagDelete" name="delete" value="{translate text="Remove from Book Bag"}"/>
          {else}
          <input type="submit" class="button bookbagAdd" name="add" value="{translate text="Add to Book Bag"}"/>
          {/if}
        </noscript>
      </form>
      </div>
      {/if}
      <div class="clear"></div>
    </div>
      <div class="clear"></div>
      {* <div class="qr_wrapper">
      <div id="qrcode"><!-- span class="overlay"></span --></div>
      {js filename="qrcodeNDL.js"}
      </div> *}
  </div>
  
   {include file=$coreMetadata}
</div>  
  <a name="tabnav"></a>
    <div id="{if $dynamicTabs}dyn{/if}tabnav" class="row-fluid tabbable">
    {if !$dynamicTabs || ($tab != 'Hold' && $tab != 'CallSlip' && $tab != 'UBRequest')}
      <ul class="span12 nav nav-tabs">
        {if $hasHoldings}
        <li{if $tab == 'Holdings' || $tab == 'Hold' || $tab == 'CallSlip' || $tab == 'UBRequest'} class="active"{/if}>
          <a id="holdingstab" href="{$url}/Record/{$id|escape:"url"}/Holdings{if $dynamicTabs}?subPage=1{/if}#tabnav"><!--i class="icon-ok"></i>&nbsp;-->{translate text='Holdings'}</a>
        </li>
        {/if}
        {* Description moved to RecordDrivers/Index/core.tpl 
        <li id="description"{if $tab == 'Description'} class="active"{/if}>
          <a id="descriptiontab" href="{$url}/Record/{$id|escape:"url"}/Description{if $dynamicTabs}?subPage=1{/if}#tabnav">{translate text='Description'}</a>
        </li> *}
        {* TOC moved to core.tpl
        {if $hasTOC}
        <li id="toc{if $tab == 'TOC'} class="active"{/if}>
          <a id="toctab" href="{$url}/Record/{$id|escape:"url"}/TOC{if $dynamicTabs}?subPage=1{/if}#tabnav">{translate text='Table of Contents'}</a>
        </li>
        {/if}
        *}
        {* .active commented out: .ui-state-active takes care of it. *}
        {if $hasContainedComponentParts}
        <li{*if $tab == 'ComponentParts'} class="active"{/if*}>
          <a id="componentstab" href="{$url}/Record/{$id|escape:"url"}/ComponentParts{if $dynamicTabs}?subPage=1{/if}#tabnav" class="first"><!--i class="icon-align-justify"></i>&nbsp;-->{translate text='Contents/Parts'}</a>
        </li>
        {/if}
        <li{*if $tab == 'UserComments'} class="active"{/if*}>
          <a id="commentstab" href="{$url}/Record/{$id|escape:"url"}/UserComments{if $dynamicTabs}?subPage=1{/if}#tabnav"><!--i class="icon-comment"></i>&nbsp;-->{translate text='Comments'}</a>
        </li>
        {if $hasReviews}
        <li{*if $tab == 'Reviews'} class="active"{/if*}>
          <a id="reviewstab" href="{$url}/Record/{$id|escape:"url"}/Reviews{if $dynamicTabs}?subPage=1{/if}#tabnav"><!--i class="icon-star-empty"></i>&nbsp;-->{translate text='Reviews'}</a>
        </li>
        {/if}
        {if $hasExcerpt}
        <li{*if $tab == 'Excerpt'} class="active"{/if*}>
          <a id="excerpttab" href="{$url}/Record/{$id|escape:"url"}/Excerpt{if $dynamicTabs}?subPage=1{/if}#tabnav"><!--i class="icon-tasks"></i>&nbsp;-->{translate text='Excerpt'}</a>
        </li>
        {/if}
        {if $hasHierarchyTree}
          <li{*if $tab == 'Hierarchytree'} class="active"{/if*}>
            <a id="hierarchytab" href="{$url}/Record/{$id|escape:"url"}/HierarchyTree{if $dynamicTabs}?subPage=1{/if}#tabnav" class="first"><!--i class="icon-indent-left"></i>&nbsp;-->{translate text='hierarchy_tree'}</a>
          </li>
        {/if}
        {if $hasMap}
          <li{*if $tab == 'Map'} class="active"{/if*}>
            <a id="maptab" href="{$url}/Record/{$id|escape:"url"}/Map{if $dynamicTabs}?subPage=1{/if}#tabnav" class="first"><!--i class="icon-globe"></i>&nbsp;-->{translate text='Map View'}</a>
          </li>
        {/if}
        <li{*if $tab == 'Details'} class="active"{/if*}>
          <a id="detailstab" href="{$url}/Record/{$id|escape:"url"}/Details{if $dynamicTabs}?subPage=1{/if}#tabnav"><!--i class="icon-wrench"></i>&nbsp;-->{translate text='Staff View'}{*image src="silk/cog.png" width="16" height="16" alt="Staff View"*}</a>
        </li>
      </ul>
    {/if}
      <div class="clear"></div>
    </div>
  
    {if $dynamicTabs && $tab != 'Hold' && $tab != 'CallSlip' && $tab != 'UBRequest'}
    <div class="recordsubcontent">
          {include file="Record/view-dynamic-tabs.tpl"}
    </div>
    {else}
    <div class="recordsubcontent">
          {include file="Record/$subTemplate"}
    </div>
    {/if}
  
    {* Add COINS *}
    <span class="Z3988" title="{$openURL|escape}"></span>
  </div>
  

  <div id="resultSidebar" class="span3 {if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if}">
    <div class="similarItems well well-small" id="similarItems{$id}"><div class="sidegroup">{image src="ajax_loading.gif" width="16" height="16" alt="Loading..."}</div></div>
    
    {if $bXEnabled}
      {include file="Record/bx.tpl"}
    {/if}
  </div>
  <div class="clearfix"></div>
</div>

<!-- END of: Record/view.tpl -->
