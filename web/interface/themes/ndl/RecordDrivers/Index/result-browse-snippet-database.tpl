<!-- START of: RecordDrivers/Index/result-browse-snippet-database.tpl -->
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
           <a title="{$subject|escape}" href="{$url}/Browse/Database?lookfor=%22{$subject|escape:"url"}%22&amp;type=Subject" class="subjectHeading">{$subfield|translate|escape}</a><br />
          {/foreach}
      {/foreach}
    </p>
    {else}
    &nbsp;
    {/if}
  </div>

  <div class="grid_4">
    <div class="metalib_link {if $metalibEnabled}iconsLeft{else}iconsRight{/if}">
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
<!-- END of: RecordDrivers/Index/result-browse-snippet-database.tpl -->
