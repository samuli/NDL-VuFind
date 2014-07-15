<!-- START of: RecordDrivers/Index/result-browse.tpl -->

<div class="recordId" id="record{$summId|escape}">
  <div class="grid_8 heading">
    <a href="#" class="title recordTitle">
        <div class="grid_7b">
          <div class="icon"></div>

          <h4>{if !empty($summHighlightedTitle)}{$summHighlightedTitle|addEllipsis:$summTitle|highlight}{elseif !$summTitle}{translate text='Title not available'}{else}{$summTitle|truncate:180:"..."|escape}{/if}</h4>          
        </div>
    </a>    
  </div>
  
  <div class="grid_4 genre">
    {if !empty($coreGenres)}
    <p>
      {foreach from=$coreGenres item=field name=loop}
        {assign var=subject value=""}
          {foreach from=$field item=subfield name=subloop}
            {if !$smarty.foreach.subloop.first} &&#8594; {/if}
            {if $subject}
              {assign var=subject value="$subject $subfield"}
            {else}
              {assign var=subject value="$subfield"}
            {/if}
           <a title="{$subject|escape}" href="{$url}/MetaLib/Browse?lookfor=%22{$subject|escape:"url"}%22&amp;type=Subject" class="subjectHeading">{$subfield|translate|escape}</a><br />
          {/foreach}
      {/foreach}
    </p>
    {else}
    &nbsp;
    {/if}
  </div>

  <div class="grid_4">
    <div class="metalib_link iconsLeft">
      <ul>
      {foreach from=$summURLs key=recordurl item=urldesc}
      {if $recordurl != $urldesc}
        <li>
          <a href="{$recordurl|proxify|escape}" class="fulltext" target="_blank" title="{$urldesc|translate_prefix:'link_'|escape}">
            <span class="metalib_{$urldesc|lower|replace:' ':'_'}"></span>          
          </a>
        </li>
      {/if}
      {/foreach}
      </ul>
    </div>

    <div class="iconsRight">

      <div class="searchDisallow">
        <span class="metalib_link">
          <div>
            <span id="metalib_link_na_{$summId|escape}" title="{translate text='metalib_browse_search_authorization_note'}" class="metalibSearchDisallow metalib_link_na"></span>
            
          </div>
        </span>
      </div>

      {if $metalibEnabled}
      <div class="search">
        <span class="metalib_link">
          <div>
            <a title="{translate text='metalib_browse_search'}" alt="{translate text='metalib_browse_search'}" href="{$metalibSearch}set=_ird%3A{$summId|regex_replace:'/^.*?\./':''|escape}">
              <span id="metalib_link_{$summId|escape}" class="metalibSearch metalib_link_ok"></span>
            </a>
          </div>
        </span>
      </div>
      {/if}

    </div>
  </div>
  
  

  <div class="clear"></div>
  <div class="moreinfo">

    {if $summNonPresenterAuthors}      
    <div class="grid_8 authors">
      {translate text='Authors'}:
      {foreach from=$summNonPresenterAuthors item=field name=loop}
      <a href="{$url}/MetaLib/Browse?lookfor={$field.name|escape:"url"}&amp;type=Author">{$field.name|escape}{if $field.role}, {$field.role|escape}{/if}</a>{if !$smarty.foreach.loop.last} ; {/if}
    {/foreach}
    </div>
    {/if}        
      
    <div class="grid_8 summary">
      {if !empty($extendedSummary)}
      <p><strong>{translate text='Summary'}: </strong></p>
      <p>
        {foreach from=$extendedSummary item=field name=loop}
        {$field|escape}<br/>
      {/foreach}
      </p>
    {/if}
    </div>

    <div class="clear"></div>

    {if $metalibEnabled}
    <div class="grid_16 metalibLinkContainer">
      <div>
        <div>            
          <span class="metalib_link">
            <a alt="{translate text='Search in this database'}" href="{$metalibSearch}set=_ird%3A{$summId|regex_replace:'/^.*?\./':''|escape}">
              <span class="metalibSearch metalib_link_ok">{translate text='metalib_browse_search'}</span>
            </a>
            
            <span class="metalibSearchDisallow metalib_link_na">({translate text='metalib_browse_search_authorization_note'})</span>
          </span>
        </div>
      </div>
    </div>
    {/if}
    
  </div>

  <div class="clear"></div>

    
</div>

<!-- END of: RecordDrivers/Index/result-browse.tpl -->
