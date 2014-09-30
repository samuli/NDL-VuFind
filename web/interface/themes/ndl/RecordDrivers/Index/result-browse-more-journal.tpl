<!-- START of: RecordDrivers/Index/result-browse-more-journal.tpl -->


<div class="grid_16">
  <table cellpadding="2" cellspacing="0" border="0" class="citation" summary="{translate text='Bibliographic Details'}">

  {if !empty($corePublications) && is_array($corePublications) && !empty($corePublications.0)}
    <tr valign="top" class="recordPublications">
      <th>{translate text='Published'}: </th>
      <td>
        {foreach from=$corePublications item=field name=loop}
          {$field|escape}<br/>
        {/foreach}
      </td>
    </tr>
    {/if}
    
    {if $recordLanguage}
    <tr valign="top" class="recordLanguage">
      <th>{translate text='Language'}: </th>
      <td>{foreach from=$recordLanguage item=lang}{translate text=$lang prefix='facet_'}<br/>{/foreach}</td>
    </tr>
    {/if}

    {if !empty($coreSubjects)}
    <tr valign="top" class="recordSubjects">
      <th>{translate text='Subjects'}: </th>
      <td>
        <div class="truncateField">
        {foreach from=$coreSubjects item=field name=loop}
        <div class="subjectLine">
          {assign var=subject value=""}
          {foreach from=$field item=subfield name=subloop}
            {if !$smarty.foreach.subloop.first} &#8594; {/if}
            {if $subject}
              {assign var=subject value="$subject $subfield"}
            {else}
              {assign var=subject value="$subfield"}
            {/if}
            <a title="{$subject|escape}" href="{$url}/Browse/Journal?lookfor=%22{$subject|escape:"url"}%22&amp;type=Subject" class="subjectHeading">{$subfield|escape}</a>
          {/foreach}
        </div>
        {/foreach}
        </div>
      </td>
    </tr>
    {/if}

    {if !empty($extendedISSNs)}
    {assign var=extendedContentDisplayed value=1}
    <tr valign="top" class="extendedISSNs">
      <th>{translate text='ISSN'}: </th>
      <td>
        {foreach from=$extendedISSNs item=field name=loop}
        {$field|escape}<br/>
      {/foreach}
      </td>
    </tr>
  {/if}

  </table>

  <div class="recordLink"><a href="{$url}/Record/{$summId|escape:'url'}">{translate text="Full Record"}</a></div>

  <div class="moreOptions"></div>


</div>
<!-- END of: RecordDrivers/Index/result-browse-more-journal.tpl -->
