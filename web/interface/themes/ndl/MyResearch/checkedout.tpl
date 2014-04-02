<!-- START of: MyResearch/checkedout.tpl -->

{include file="MyResearch/menu.tpl"}

<div class="myResearch checkedoutList{if $sidebarOnLeft} last{/if}">
  <div class="content">
    {if empty($catalogAccounts)}
    	<p class="noContentMessage">{translate text='You do not have any library cards'}</p>
   			 <a class="button buttonFinna" type="button" href="{$url}/MyResearch/Accounts?add=1" />{translate text='Link Library Card'}...</a>
    {/if}
    {if !empty($catalogAccounts)}
  <div class="grid_24">
  <div class="resultHead">
  {if $errorMsg || $infoMsg}
    <div class="messages">
    {if $errorMsg}<p class="error">{$errorMsg|translate}</p>{/if}
    {if $infoMsg}<p class="info">{$infoMsg|translate}{if $showExport} <a class="save" target="_new" href="{$showExport|escape}">{translate text="export_save"}</a>{/if}</p>{/if}
    </div>
  {/if}
  {if $user->cat_username}
    <h2>{translate text='Your Checked Out Items'}:      
    {foreach from=$catalogAccounts item=account}
        	{if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
     {/foreach} 
            {if !empty($accountname)}({/if}{assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}{translate text=$source prefix='source_'}{if !empty($accountname)}){/if}</h2>
    {if $blocks}
      {foreach from=$blocks item=block}
        <p class="info">{translate text=$block}</p>
      {/foreach}
    {/if}
  </div>
    {if $transList}
    <table>
      {if $renewForm}
    <form name="renewals" action="{$url}/MyResearch/CheckedOut" method="post" id="renewals">

      
    <tr class="bulkActionButtons">
    	<th colspan="3"><h3 style="display:inline-block">{translate text="Checked Out Items"}</h3>
        <!-- <div class="allCheckboxBackground"><input type="checkbox" class="selectAllCheckboxes" name="selectAll" id="addFormCheckboxSelectAll" /></div> -->       
         <span style="float:right;vertical-align:middle">
          <input type="submit" class="button buttonFinna renew" name="renewSelected" value="{translate text="renew_selected"}" />
          <input type="submit" class="button buttonFinna renewAll" name="renewAll" value="{translate text='renew_all'}" />
         </span>
        </th>
       </tr> 
      {else}
      <tr class="bulkActionButtons">
      <th colspan="3"><h3 style="display:inline-block">{translate text="Checked Out Items"}</h3>
      </tr>
      {/if}

      {if $errorMsg}
      <tr><th colspan="3"><p class="error">{translate text=$errorMsg}</p></th></tr>
      {/if}
  
    
    <tr class="recordSet">
    {foreach from=$transList item=resource name="recordLoop"}
      <tr class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
      <th class="myCheckbox">
      

      {if $renewForm}
      <div class="checkboxFilter">
        <span class="resultCheckbox">
         {if $resource.ils_details.renewable && isset($resource.ils_details.renew_details)}
           
            <input type="checkbox" name="renewSelectedIDS[]" value="{$resource.ils_details.renew_details|escape}" class="checkbox" id="checkbox_{$resource.ils_details.renew_details|regex_replace:'/[^a-z0-9]/':''|escape}" />
             <label for="checkbox_{$resource.ils_details.renew_details|regex_replace:'/[^a-z0-9]/':''|escape}">{translate text="Select"} 
             
            {if !empty($resource.id)} 
              {$resource.title|escape}
            {else}
              {translate text='Title not available'}
            {/if}</label>
            <input type="hidden" name="renewAllIDS[]" value="{$resource.ils_details.renew_details|escape}" />
         {else}
      	 <p class="smallNotification">{translate text="Cannot renew"}<p>
         {/if}
        </span>
       </div>
      {else}
      <p class="smallNotification">{translate text="Cannot renew"}<p>
      {/if}
      </th>
        <td id="record{$resource.id|escape}">
        	{assign var=summImages value=$resource.summImages}
        	{assign var=summThumb value=$resource.summThumb}        	
        	{assign var=summId value=$resource.id}        	
			{assign var=img_count value=$summImages|@count}
			
         
          
            {* If $resource.id is set, we have the full Solr record loaded and should display a link... *}
            {if !empty($resource.id)}
              <a href="{$url}/Record/{$resource.id|escape:'url'}" class="title">{$resource.title|escape}</a>
            {* If the record is not available in Solr, perhaps the ILS driver sent us a title we can show... *}
            {elseif !empty($resource.ils_details.title)}
              {$resource.ils_details.title|escape}
            {* Last resort -- indicate that no title could be found. *}
            {else}
              {translate text='Title not available'}
            {/if}
            <br/>
            {if $resource.author}
              {translate text='by'}: <a href="{$url}/Search/Results?lookfor={$resource.author|escape:'url'}&amp;type=Author">{$resource.author|escape}</a><br/>
            {/if}
            {if $resource.tags}
              {translate text='Your Tags'}:
              {foreach from=$resource.tags item=tag name=tagLoop}
                <a href="{$url}/Search/Results?tag={$tag->tag|escape:'url'}">{$tag->tag|escape}</a>{if !$smarty.foreach.tagLoop.last},{/if}
              {/foreach}
              <br/>
            {/if}
            {if $resource.notes}
              {translate text='Notes'}: {$resource.notes|escape}<br/>
            {/if}
 			{if is_array($resource.format)}
			  {assign var=mainFormat value=$resource.format.0} 
			  {assign var=displayFormat value=$resource.format|@end} 
			{else}
			  {assign var=mainFormat value=$resource.format} 
			  {assign var=displayFormat value=$resource.format} 
			{/if}
			<span class="iconlabel format{$mainFormat|lower|regex_replace:"/[^a-z0-9]/":""} format{$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$displayFormat prefix='format_'}</span>
            {if $resource.ils_details.volume}
              <strong>{translate text='Volume'}:</strong> {$resource.ils_details.volume|escape}
              <br />
            {/if}

            {if $resource.ils_details.publication_year}
              <strong>{translate text='Year of Publication'}:</strong> {$resource.ils_details.publication_year|escape}
              <br />
            {/if}
        </td>
        <td class="dueDate floatright">
          <div class="checkedoutSource">
            {assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}
            {if $resource.ils_details.institution_name}
              <span>{translate text=$resource.ils_details.institution_name prefix='library_'}</span>
            {/if}
          </div>
            {if !empty($resource.ils_details.renewalCount)}
              <strong>{translate text='Renewed'}:</strong> {$resource.ils_details.renewalCount|escape}
              {if !empty($resource.ils_details.renewalLimit)} / {$resource.ils_details.renewalLimit|escape}{/if}
              <br />
            {/if}
            {assign var="showStatus" value="show"}
            {if $renewResult[$resource.ils_details.item_id]}
              {if $renewResult[$resource.ils_details.item_id].success}
                {assign var="showStatus" value="hide"}
                <strong>{translate text='Due Date'}: {$renewResult[$resource.ils_details.item_id].new_date}</strong>
                <div class="success">{translate text='renew_success'}</div>
              {else}
                <strong>{translate text='Due Date'}: {$resource.ils_details.duedate|escape} {if $resource.ils_details.dueTime} {$resource.ils_details.dueTime|escape}{/if}</strong>
                <div class="error">{translate text='renew_fail'}{if $renewResult[$resource.ils_details.item_id].sysMessage}: {$renewResult[$resource.ils_details.item_id].sysMessage|escape}{/if}</div>
              {/if}
            {else}
              <strong>{translate text='Due Date'}: {$resource.ils_details.duedate|escape} {if $resource.ils_details.dueTime} {$resource.ils_details.dueTime|escape}{/if}</strong>
              {if $showStatus == "show"}
                {if $resource.ils_details.dueStatus == "overdue"}
                  <div class="error">{translate text="renew_item_overdue"}</div>
                {elseif $resource.ils_details.dueStatus == "due"}
                  <div class="notice">{translate text="renew_item_due"}</div>
                {/if}
              {/if}
            {/if}

            {if $showStatus == "show" && $resource.ils_details.message}
              <div class="info">{translate text=$resource.ils_details.message}</div>
            {/if}
            {if $resource.ils_details.renewable && $resource.ils_details.renew_link}
              <a href="{$resource.ils_details.renew_link|escape}">{translate text='renew_item'}</a>
            {/if}

          </td> <!-- class="dueDate" -->
          <div class="clear"></div>
        </tr> <!-- record{$resource.id|escape} -->
    {/foreach}
    </table>
      {if $renewForm}
        </form>
      {/if}
    {else}
      <div class="noContentMessage">{translate text='You do not have any items checked out'}.</div>
    {/if}
    {/if}
  {else}
    {include file="MyResearch/catalog-login.tpl"}
  {/if}
  </div>
</div>
</div>

<div class="clear"></div>

<!-- END of: MyResearch/checkedout.tpl -->
