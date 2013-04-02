<!-- START of: Metalib/record.tpl.tpl -->

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


<div class="resultLinks">
{if $errorMsg || $infoMsg || $lastsearch || $previousRecord || $nextRecord}
  <div class="content">
  {if $errorMsg || $infoMsg}
  <div class="messages">
    {if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
    {if $infoMsg}<div class="info">{$infoMsg|translate}</div>{/if}
  </div>
  {/if}
  {if $lastsearch}
    <div class="backToResults grid_12">
        <a href="{$lastsearch|escape}#record{$id|escape:"url"}"><div class="button buttonFinna icon"><span class="icon">&laquo</span></div>{translate text="Back to Search Results"}</a>
    </div>
  {/if}
  {if $previousRecord || $nextRecord}
    <div class="resultscroller grid_5 push_7">
    {if $previousRecord}<a href="{$url}/Record/{$previousRecord}" class="prevRecord icon"><span class="resultNav">&laquo;&nbsp;{translate text="Prev"}</span></a>
    {else}<span class="prevRecord inactive"><span class="resultNav">&laquo;&nbsp;{translate text="Prev"}</span></span>{/if}
    {$currentRecordPosition} / {$resultTotal}
    {* #{$currentRecordPosition} {translate text='of'} {$resultTotal} *}
    {if $nextRecord}<a href="{$url}/Record/{$nextRecord}" class="nextRecord icon"><span class="resultNav">{translate text="Next"}&nbsp;&raquo;</span></a>
    {else}<span class="nextRecord inactive"><span class="resultNav">{translate text="Next"}&nbsp;&raquo;</span></span>{/if}
	</div>
	{/if}
  </div>
{else}
  &nbsp;
{/if}
<div class="clear"></div>
</div>
<div class="record recordId" id="record{$id|escape}">

  <div class="content">
  <div id="resultMain">
  <div id="resultSide" class="grid_4">
    <div id="resultToolbar" class="toolbar">
      <ul>
        <li id="saveLink"><a href="{$url}/MetaLib/Save?id={$id|escape:"url"}" class="saveMetaLibRecord metalibRecord fav" id="saveRecord{$id|escape}" title="{translate text="Add to favorites"}">{translate text="Add to favorites"}</a></li>        
        {* SMS commented out for now
        <li><a href="{$url}/MetaLib/SMS?id={$id|escape:"url"}" class="smsRecord smsMetaLib sms" id="smsRecord{$id|escape}" title="{translate text="Text this"}">{translate text="Text this"}</a></li>
        *}

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
     
      <div class="clear"></div>
    </div>
  </div>

  <div class="grid_12 prefix_1">
    <div id="recordMetadata">
    <h1 class="recordTitle">{$record.Title.0|escape}</h1>
    {* End Title *}
    
    {* Display Abstract/Snippet *}
    {if $record.Abstract}
      <p class="snippet">{$record.Abstract.0|escape}</p>
    {elseif $record.Snippet.0 != ""}
      <blockquote>
        <span class="quotestart">&#8220;</span>{$record.Snippet.0|escape}<span class="quoteend">&#8221;</span>
      </blockquote>
    {/if}

    {* Display Main Details *}
    <table cellpadding="2" cellspacing="0" border="0" class="citation">
    
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
    
  </div>
  {* End Record *} 
  
  {* Add COINS *}  
  <span class="Z3988" title="{$record.openUrl|escape}"></span>
  </div>
</div>

<div class="clear"></div>

<!-- END of: Metalib/record.tpl.tpl -->