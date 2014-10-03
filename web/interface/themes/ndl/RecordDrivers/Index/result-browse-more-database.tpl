<!-- START of: RecordDrivers/Index/result-browse-more-database.tpl -->
    {if $summNonPresenterAuthors}      
    <div class="grid_8 authors">
      {translate text='Authors'}:
      {foreach from=$summNonPresenterAuthors item=field name=loop}
      <a href="{$url}/Browse/Database?lookfor={$field.name|escape:"url"}&amp;type=Author">{$field.name|escape}{if $field.role}, {$field.role|escape}{/if}</a>{if !$smarty.foreach.loop.last} ; {/if}
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
    <div class="grid_16 interfaceLinkContainer">
      <div>
      	<div class="metalib_link">
          {foreach from=$summURLs key=recordurl item=urldesc}
          {if $recordurl != $urldesc}
              <a href="{$recordurl|proxify|escape}" class="fulltext metalib_icon" target="_blank" title="{$urldesc|translate_prefix:'link_'|escape}">
                <span class="metalib_{$urldesc|lower|replace:' ':'_'}">{$urldesc|translate_prefix:'link_'|escape}</span>          
              </a>
          {/if}
          {/foreach}
      	</div>
      </div>
    </div>
    {if $metalibEnabled}
    <div class="grid_16 metalibLinkContainer">
      <div>
        <div class="metalibsearch">         
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
<!-- END of: RecordDrivers/Index/result-browse-more-database.tpl -->
