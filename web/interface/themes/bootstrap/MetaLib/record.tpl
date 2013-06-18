<!-- START of: MetaLib/record.tpl -->

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
{if $record.openUrl}
  {js filename="openurl.js"}
{/if}
{if $metalibEnabled}
  {js filename="metalib_links.js"}
{/if}

{*<div class="span-10{if $sidebarOnLeft} push-3 last{/if}">*}

{if $errorMsg || $infoMsg || $lastsearch || $previousRecord || $nextRecord}
<div class="row-fluid">

  {if $errorMsg || $infoMsg}
  <div class="span12 messages">
    {if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
    {if $infoMsg}<div class="info">{$infoMsg|translate}</div>{/if}
  </div>
  {/if}

  {if $lastsearch}
    <div class="span3 backToResults well-small">
        <a href="{$lastsearch|escape}#record{$id|escape:"url"}">&laquo; {translate text="Back to Search Results"}</a>
    </div>
  {/if}

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

  </div>
  {/if}

  </div>
{/if} {* $errorMsg || ... *}

<div class="row-fluid record recordId" id="record{$id|escape}">

  <div id="resultMain" class="span9">

  <div class="row-fluid">
    <div id="resultSide" class="span4">

      {* Display Cover Image *}
      {*
      <div class="coverImages clearfix">
        <a href="{$path}/bookcover.php?size=large{if $record.ISBN.0}&amp;isn={$record.ISBN.0|@formatISBN}{/if}{if $record.ContentType.0}&amp;contenttype={$record.ContentType.0|escape:"url"}{/if}" onclick="launchFancybox(this); return false;" rel="{$record.ID.0|escape:"url"}"><img alt="{translate text='Cover Image'}" src="{$path}/bookcover.php?size=small{if $record.ISBN.0}&amp;isn={$record.ISBN.0|@formatISBN}{/if}{if $record.ContentType.0}&amp;contenttype={$record.ContentType.0|escape:"url"}{/if}"/></a>
      </div>
      *}

      <div id="resultToolbar" class="toolbar alert alert-info">
        <ul class="unstyled">
          {* TODO: citations <li><a href="{$url}/MetaLib/Cite?id={$id|escape:"url"}" class="citeRecord metalibRecord cite" id="citeRecord{$id|escape}" title="{translate text="Cite this"}">{translate text="Cite this"}</a></li> *}
          <li id="saveLink"><a href="{$url}/MetaLib/Save?id={$id|escape:"url"}" class="saveMetaLibRecord metalibRecord add" id="saveRecord{$id|escape}" title="{translate text="Add to favorites"}">{translate text="Add to favorites"}</a></li>
          {* SMS commented out for now
          <li><a href="{$url}/MetaLib/SMS?id={$id|escape:"url"}" class="smsRecord smsMetaLib sms" id="smsRecord{$id|escape}" title="{translate text="Text this"}">{translate text="Text this"}</a></li> *}
          <li><a href="{$url}/MetaLib/Email?id={$id|escape:"url"}" class="mailRecord mailMetaLib mail" id="mailRecord{$id|escape}" title="{translate text="Email this"}">{translate text="Email this"}</a></li>
          {* TODO: export 
          {if is_array($exportFormats) && count($exportFormats) > 0}
          <li>
            <a href="{$url}/MetaLib/Export?id={$id|escape:"url"}&amp;style={$exportFormats.0|escape:"url"}" class="export exportMenu">{translate text="Export Record"}</a>
            <ul class="menu offscreen" id="exportMenu">
            {foreach from=$exportFormats item=exportFormat}
              <li><a {if $exportFormat=="RefWorks"}target="{$exportFormat}Main" {/if}href="{$url}/MetaLib/Export?id={$id|escape:"url"}&amp;style={$exportFormat|escape:"url"}">{translate text="Export to"} {$exportFormat|escape}</a></li>
            {/foreach}
            </ul>
          </li>
          {/if}
          *}
          {*
          <li><a href="{$url}/MetaLib/{$id|escape:"url"}/Email" class="mailRecord mailMetaLib mail" id="mailRecord{$id|escape}" title="{translate text="Email this"}">{translate text="Email this"}</a></li> *}
          {* AddThis for social sharing START *}
          {if !empty($addThis)}
        	  <li id="addThis">
            <div class="addthis_toolbox addthis_default_style ">
              <a href="{$url}/MetaLib/Email?id={$id|escape:"url"}" class="mailRecord mailMetaLib mail" id="mailRecord{$id|escape}" title="{translate text="Email this"}">{translate text="Email this"}</a>              <a class="icon addthis_button_facebook"></a>
              <a class="icon addthis_button_twitter"></a>
              <a class="icon addthis_button_google_plusone_share"></a>
            </div>
          </li>
          {/if}
          {* Addthis for social sharing END *}
        </ul>
        <div class="clear"></div>
      </div>
    </div>

  <div class="span8 record recordId" id="record{$id|escape}">

    <div class="alignright"><span class="{$record.ContentType.0|replace:" ":""|escape}">{$record.ContentType.0|escape}</span></div>

    {* Display Title *}
    <h4 class="alert alert-success recordTitle">{$record.Title.0|escape}</h4>
    {* End Title *}

    {js filename="init_fancybox.js"}
    {* End Cover Image *}
    
    {* Display Abstract/Snippet *}
    {if $record.Abstract}
      <p class="snippet">{$record.Abstract.0|escape}</p>
    {elseif $record.Snippet.0 != ""}
      <blockquote>
        <span class="quotestart">&#8220;</span>{$record.Snippet.0|escape}<span class="quoteend">&#8221;</span>
      </blockquote>
    {/if}

    {* Display Main Details *}
    <table cellpadding="2" cellspacing="0" border="0" class="table table-condensed table-hover text-left citation">
    
    {if $record.Author}
      <tr valign="top">
        <th>{translate text='Author'}: </th>
        <td>
      {foreach from=$record.Author item="author" name="loop"}
          <a href="{$url}/MetaLib/Search?type=Author&amp;lookfor={$author|escape:"url"}">{$author|escape}</a>{if !$smarty.foreach.loop.last},{/if} 
      {/foreach}
        </td>
      </tr>
    {/if}

    {if $record.AdditionalAuthors}
      <tr valign="top">
        <th>{translate text='Other Authors'}: </th>
        <td>
      {foreach from=$record.AdditionalAuthors item="author" name="loop"}
          {$author|escape}{if !$smarty.foreach.loop.last},{/if} 
      {/foreach}
        </td>
      </tr>
    {/if}

    {if $record.PublicationTitle}
      <tr valign="top">
        <th>{translate text='Publication'}: </th>
        <td>{$record.PublicationTitle.0|escape}</td>
      </tr>
    {/if}

    {assign var=pdxml value="PublicationDate_xml"}
    {if $record.$pdxml || $record.PublicationDate}
      <tr valign="top">
        <th>{translate text='Published'}: </th>
        <td>
      {if $record.$pdxml}
        {if $record.$pdxml.0.month}{$record.$pdxml.0.month|escape}/{/if}{if $record.$pdxml.0.day}{$record.$pdxml.0.day|escape}/{/if}{if $record.$pdxml.0.year}{$record.$pdxml.0.year|escape}{/if}
        {else}
          {$record.PublicationDate.0|escape}
        {/if}
        </td>
      </tr>
      {/if}

      {if $record.ISSN}
      <tr valign="top">
        <th>{translate text='ISSN'}: </th>
        <td>
        {foreach from=$record.ISSN item="value"}
          {$value|escape}<br/>
        {/foreach}
        </td>
      </tr>
      {/if}
      
      {if $record.RelatedAuthor}
      <tr valign="top">
        <th>{translate text='Related Author'}: </th>
        <td>
        {foreach from=$record.RelatedAuthor item="author"}
          {$author|escape}
        {/foreach}
        </td>
      </tr>
      {/if}

      {if $record.Language}
      <tr valign="top">
        <th>{translate text='Language'}: </th>
        <td>{$record.Language.0|escape}</td>
      </tr>
      {/if}

      {if $record.SubjectTerms}
      <tr valign="top">
        <th>{translate text='Subjects'}: </th>
        <td>
        {foreach from=$record.SubjectTerms item=field name=loop}
          {$field|escape}<br/>
        {/foreach}
        </td>
      </tr>
      {/if}

      {foreach from=$record.Notes item=field name=loop}
      <tr valign="top">
        <th>{if $smarty.foreach.loop.first}{translate text='Notes'}:{/if}</th>
        <td>{$field|escape}</td>
      </tr>
      {/foreach}

      {if $record.Source}
      <tr valign="top">
        <th>{translate text='Source'}: </th>
        <td>{$record.Source.0|escape}</td>
      </tr>
      {/if}

      {foreach from=$record.url key=recordurl item=urldesc}
      <tr valign="top">
        <th></th>
        <td><a href="{if $record.proxy}{$recordurl|proxify|escape}{else}{$recordurl|escape}{/if}" class="fulltext" target="_blank">{$urldesc|translate_prefix:'link_'|escape}</a></td>
      </tr>
      {/foreach}
      {if $openUrlBase && $record.openUrl}
      <tr valign="top">
        <th></th>
        <td>{include file="Search/openurl.tpl" openUrl=$record.openUrl}</td>
      </tr>
        {include file="Search/rsi.tpl"}
        {include file="Search/openurl_autocheck.tpl"}
      {/if}

    </table>
    {* End Main Details *}

    {* Display the lists that this record is saved to *}
	<div class="savedLists alert alert-info" id="savedLists{$id|escape}">
	  <strong>{translate text="Saved in"}:</strong>
	</div>    
  </div>
  {* End Record *} 
  
  {* Add COINS *}  
  <span class="Z3988" title="{$record.openUrl|escape}"></span>
</div>

<div class="span3 {if $sidebarOnLeft}pull-10 sidebarOnLeft{else}last{/if}">
  {if $bXEnabled}
    {include file="Record/bx.tpl"}
  {/if}
</div>

<div class="clearfix"></div>

<!-- END of: MetaLib/record.tpl -->
