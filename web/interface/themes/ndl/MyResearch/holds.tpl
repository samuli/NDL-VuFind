<!-- START of: MyResearch/holds.tpl -->

{include file="MyResearch/menu.tpl"}

<div class="myResearch holdsList{if $sidebarOnLeft} last{/if} driver-{$driver}">
  <div class="content">
    {* NDLBlankInclude *}
    {assign var=hold_instructions value='hold_instructions'|translate}
    {if $hold_instructions} 
    <div class="noContentMessage">{$hold_instructions}</div>
    {/if}
    {* /NDLBlankInclude *}
    
      {if empty($catalogAccounts)}
    	<p class="noContentMessage">{translate text='You do not have any library cards'}</p>
   			 <a class="button buttonFinna" type="button" href="{$url}/MyResearch/Accounts?add=1" />{translate text='Link Library Card'}...</a>
      {/if}
  <div class="grid_24">
  {if $errorMsg}
     <div class="holdsMessage"><p class="error">{translate text=$errorMsg}</p></div>
  {/if}
  {if $user->cat_username}
  <div class="resultHead">
    {if $holdResults.success}
      <div class="holdsMessage"><p class="success">{translate text=$holdResults.status}</p></div>
    {/if}
    {if $callSlipResults.success}
      <div class="holdsMessage"><p class="success">{translate text=$callSlipResults.status}</p></div>
    {/if}
    {if $UBRequestResults.success}
      <div class="holdsMessage"><p class="success">{translate text=$UBRequestResults.status}</p></div>
    {/if}

    {if $cancelResults.count > 0}
      <div class="holdsMessage"><p class="info">{$cancelResults.count|escape} {translate text="hold_cancel_success_items"}</p></div>
    {/if}
    {if $cancelCallSlipResults.count > 0}
      <div class="holdsMessage"><p class="info">{$cancelCallSlipResults.count|escape} {translate text="call_slip_cancel_success_items"}</p></div>
    {/if}
    {if $profile.blocks}
      {foreach from=$profile.blocks item=block name=loop}
        <p class="borrowingBlock"><strong>{translate text=$block|escape}</strong></p>
      {/foreach}
    {/if}
    <h2>{translate text='Holds'}:
      {foreach from=$catalogAccounts item=account}
        {if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
      {/foreach} 
      {if !empty($accountname)}({/if}{assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}{translate text=$source prefix='source_'}{if !empty($accountname)}){/if}</h2>


    
  </div>
    {if $cancelForm && $recordList}
    
  <form name="cancelForm" action="{$url|escape}/MyResearch/Holds" method="post" id="cancelHold">
  <table>
    <tr class="bulkActionButtons"><th><h3>{translate text="Holds"}</h3></th>
        <!-- <div class="allCheckboxBackground"><input type="checkbox" class="selectAllCheckboxes" name="selectAll" id="addFormCheckboxSelectAll" /></div> -->
        <th class="alignRight"  colspan="2">
          <input type="submit" class="button buttonFinna holdCancel" name="cancelSelected" value="{translate text="hold_cancel_selected"}" onclick="return confirm('{translate text="confirm_hold_cancel_selected_text}')" />
          <input type="submit" class="button buttonFinna holdCancelAll" name="cancelAll" value="{translate text='hold_cancel_all'}" onclick="return confirm('{translate text="confirm_hold_cancel_all_text}')" />
        </th>
      </tr>
    {/if}


    {if is_array($recordList)}
    <tr class="recordSet">
    {foreach from=$recordList item=resource name="recordLoop"}
      <tr class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
       <th class="myCheckbox">
        {if $cancelForm && $resource.ils_details.cancel_details}
        <div class="checkboxFilter">
          <span class="resultCheckbox">
          	<input type="checkbox" name="cancelSelectedIDS[]" value="{$resource.ils_details.cancel_details|escape}" class="checkbox" id="{$resource.ils_details.cancel_details|escape}"/>
            <label for="{$resource.ils_details.cancel_details|escape}">{translate text="Select"} 
            {if !empty($resource.id)} 
              {$resource.title|escape}
            {else}
              {translate text='Title not available'}
            {/if}
            </label>         
    		<input type="hidden" name="cancelAllIDS[]" value="{$resource.ils_details.cancel_details|escape}" />
            {else}
      	 	<p class="smallNotification">{translate text="Cannot cancel"}<p>
          </span>
         </div>
        {/if}
       </th>
        <td id="record{$resource.id|escape}">
        	{assign var=summImages value=$resource.summImages}
        	{assign var=summThumb value=$resource.summThumb}        	
        	{assign var=summId value=$resource.id}        	
          {assign var=img_count value=$summImages|@count}
		
            {* If $resource.id is set, we have the full Solr record loaded and should display a link... *}
            {if !empty($resource.id)}
              <a href="{$url}/Record/{$resource.id|escape:"url"}" class="title">{$resource.title|escape}</a>
            {* If the record is not available in Solr, perhaps the ILS driver sent us a title we can show... *}
            {elseif !empty($resource.ils_details.title)}
              {$resource.ils_details.title|escape}
            {* Last resort -- indicate that no title could be found. *}
            {else}
              {translate text='Title not available'}
            {/if}
            <br/>
            {if $resource.author}
              {translate text='by'}: <a href="{$url}/Search/Results?lookfor={$resource.author|escape:"url"}&amp;type=Author">{$resource.author|escape}</a><br/>
            {/if}
            {if $resource.tags}
              <strong>{translate text='Your Tags'}:</strong>
              {foreach from=$resource.tags item=tag name=tagLoop}
                <a href="{$url}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape}</a>{if !$smarty.foreach.tagLoop.last},{/if}
              {/foreach}
              <br/>
            {/if}
            {if $resource.notes}
              <strong>{translate text='Notes'}:</strong> {$resource.notes|escape}<br/>
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
              <strong>{translate text='Volume'}:</strong> {$resource.ils_details.volume|escape}<br />
            {/if}

            {if $resource.ils_details.publication_year}
              <strong>{translate text='Year of Publication'}:</strong> {$resource.ils_details.publication_year|escape}<br />
            {/if}
            </td>
            <td class="dueDate floatright">
            {assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}
            {if $driver != 'AxiellWebServices'}{translate text=$source prefix='source_'},{/if}
            {* Depending on the ILS driver, the "location" value may be a string or an ID; figure out the best value to display... *}
            {assign var="pickupDisplay" value=""}
            {assign var="pickupTranslate" value="0"}
            {if isset($resource.ils_details.location)}
              {if $pickup}
                {foreach from=$pickup item=library}
                  {if $library.locationID == $resource.ils_details.location}
                    {assign var="pickupDisplay" value=$library.locationDisplay}
                    {assign var="pickupTranslate" value="1"}
                  {/if}
                {/foreach}
              {/if}
              {if empty($pickupDisplay)}
                {assign var="pickupDisplay" value=$resource.ils_details.location}
              {/if}
            {/if}
            {if $resource.ils_details.modifiable == true}
                <div class="changePickUpLocation">
                    <span id="pickUpLoader"></span>
                    <select id="pickUpLocation" data-reservationid="{if $resource.ils_details.reservation_id}{$resource.ils_details.reservation_id|escape}{/if}" data-created="{if $resource.ils_details.create}{$resource.ils_details.create}{/if}" data-expires="{if $resource.ils_details.expire}{$resource.ils_details.expire}{/if}">
                        {foreach from=$pickup item=library}
                        <option value="{$library.locationID|escape}" {if $library.locationDisplay == $resource.ils_details.location}selected="selected"{/if}>{$library.locationDisplay|escape}</option>
                        {/foreach}
                    </select>
                </div>
            {elseif !empty($pickupDisplay)}
              <strong>{translate text='pick_up_location'}:</strong>
              {if $pickupTranslate}{translate text=$pickupDisplay}{else}{$pickupDisplay|escape}{/if}
              <br />
            {/if}

            {if $resource.ils_details.create}<strong>{translate text='Created'}:</strong> {$resource.ils_details.create|escape},{/if}
            {if $resource.ils_details.expire}<strong>{translate text='Expires'}:</strong> {$resource.ils_details.expire|escape}{/if}
            <br />
            {if $resource.ils_details.in_transit}<strong>{translate text='In Transit To'}:</strong> {$resource.ils_details.in_transit|translate_prefix:'library_'|escape}
            <br />
            {/if}

            {foreach from=$cancelResults.items item=cancelResult key=itemId}
              {if $itemId == $resource.ils_details.item_id && $cancelResult.success == false}
                <div class="error">{translate text=$cancelResult.status}{if $cancelResult.sysMessage} : {translate text=$cancelResult.sysMessage|escape}{/if}</div>
              {/if}
            {/foreach}

            {if $driver == 'AxiellWebServices' && $resource.ils_details.type == inTransit}
              <span class="available">{translate text="In Transit"}
              </span>
            {/if}

            {if $resource.ils_details.available == true}
              <span class="available">{translate text="hold_available"}
                {if $driver == 'AxiellWebServices'}
                  <br>
                  <strong>{translate text="Pickup number"}:</strong> {$resource.ils_details.pickupnum}
                {/if}
                </span>
            {else}
              {if $resource.ils_details.position}
              <p class="positionDetails"><strong>{translate text='hold_queue_position'}:</strong> {$resource.ils_details.position|escape}</p>
              {/if}
            {/if}
            {if $resource.ils_details.cancel_link}
              <p><a href="{$resource.ils_details.cancel_link|escape}">{translate text='hold_cancel'}</a></p>
            {/if}

          </td> <!-- class="dueDate" -->
          <div class="clear"></div>
        </tr>
    {/foreach}
    </table>
    {if $cancelForm}
    </form>
    {/if}
    {else}
      <div class="noContentMessage">{translate text='You do not have any holds placed'}.</div>
    {/if}

    <div style="clear:both;padding-top: 2em;"></div>

  {* Call Slips *}
  {if $driver != 'AxiellWebServices'}
  <h2>{translate text='Call Slips'}:      {foreach from=$catalogAccounts item=account}
        	{if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
     {/foreach} 
            {if !empty($accountname)}({/if}{assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}{translate text=$source prefix='source_'}{if !empty($accountname)}){/if}
    </h2>
    {if is_array($callSlipList)}
  <form name="cancelCallSlipForm" action="{$url|escape}/MyResearch/Holds" method="post" id="cancelCallSlip">
  <table>
    <tr class="bulkActionButtons"><th><h3>{translate text="Call Slips"}</h3></th>
        <!-- <div class="allCheckboxBackground"><input type="checkbox" class="selectAllCheckboxes" name="selectAll" id="addFormCheckboxSelectAllCallSlips" /></div> -->
        <th class="alignRight"  colspan="2">
          <input type="submit" class="button buttonFinna holdCancel" name="cancelSelectedCallSlips" value="{translate text="call_slip_cancel_selected"}" onclick="return confirm('{translate text="confirm_call_slip_cancel_selected_text}')" />
          <input type="submit" class="button buttonFinna holdCancelAll" name="cancelAllCallSlips" value="{translate text='call_slip_cancel_all'}" onclick="return confirm('{translate text="confirm_call_slip_cancel_all_text}')" />
        </th>
      </tr>



    <tr class="recordSet">
    {foreach from=$callSlipList item=resource name="recordLoop"}
      <tr class="result{if ($smarty.foreach.recordLoop.iteration % 2) == 0} alt{/if}">
       <th class="myCheckbox">
        {if $resource.ils_details.cancel_details}
        <div class="checkboxFilter">
          <span class="resultCheckbox">
          <input type="checkbox" name="cancelSelectedCallSlipIDS[]" value="{$resource.ils_details.cancel_details|escape}" class="checkbox" id="{$resource.ils_details.cancel_details|escape}"/>
          <label for="{$resource.ils_details.cancel_details|escape}">{translate text="Select"} 
            {if !empty($resource.id)} 
              {$resource.title|escape}
            {else}
              {translate text='Title not available'}
            {/if}
          </label>
          <input type="hidden" name="cancelAllCallSlipIDS[]" value="{$resource.ils_details.cancel_details|escape}" />
          {else}
      	 	<p class="smallNotification">{translate text="Cannot cancel"}<p>
          </span>
        </div>
        {/if}
        </th>
        <td id="record{$resource.id|escape}">
          {assign var=summImages value=$resource.summImages}
          {assign var=summThumb value=$resource.summThumb}  
          {assign var=summId value=$resource.id}          
          {assign var=img_count value=$summImages|@count}

            {* If $resource.id is set, we have the full Solr record loaded and should display a link... *}
            {if !empty($resource.id)}
              <a href="{$url}/Record/{$resource.id|escape:"url"}" class="title">{$resource.title|escape}</a>
            {* If the record is not available in Solr, perhaps the ILS driver sent us a title we can show... *}
            {elseif !empty($resource.ils_details.title)}
              {$resource.ils_details.title|escape}
            {* Last resort -- indicate that no title could be found. *}
            {else}
              {translate text='Title not available'}
            {/if}
            <br/>
            {if $resource.author}
              {translate text='by'}: <a href="{$url}/Search/Results?lookfor={$resource.author|escape:"url"}&amp;type=Author">{$resource.author|escape}</a><br/>
            {/if}
            {if $resource.tags}
              <strong>{translate text='Your Tags'}:</strong>
              {foreach from=$resource.tags item=tag name=tagLoop}
                <a href="{$url}/Search/Results?tag={$tag->tag|escape:"url"}">{$tag->tag|escape}</a>{if !$smarty.foreach.tagLoop.last},{/if}
              {/foreach}
              <br/>
            {/if}
            {if $resource.notes}
              <strong>{translate text='Notes'}:</strong> {$resource.notes|escape}<br/>
            {/if}

            {if is_array($resource.format)}
              {assign var=mainFormat value=$resource.format.0} 
              {assign var=displayFormat value=$resource.format|@end} 
            {else}
              {assign var=mainFormat value=$resource.format} 
              {assign var=displayFormat value=$resource.format} 
            {/if}
            {if $displayFormat}
              <span class="iconlabel format{$mainFormat|lower|regex_replace:"/[^a-z0-9]/":""} format{$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}">{translate text=$displayFormat prefix='format_'}</span>
            {/if}

            {if $resource.ils_details.volume}
              <strong>{translate text='Volume'}:</strong> {$resource.ils_details.volume|escape}<br />
            {/if}

            {if $resource.ils_details.publication_year}
              <strong>{translate text='Year of Publication'}:</strong> {$resource.ils_details.publication_year|escape}<br />
            {/if}
            </td>
            <td class="dueDate floatright">
              {assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}
              {if $resource.ils_details.institution_name}
                {translate text=$resource.ils_details.institution_name prefix='library_'}
              {else}
                {translate text=$source prefix='source_'}
              {/if}
            {* Depending on the ILS driver, the "location" value may be a string or an ID; figure out the best value to display... *}
            {assign var="pickupDisplay" value=""}
            {assign var="pickupTranslate" value="0"}
            {if isset($resource.ils_details.location)}
              {if $pickup}
                {foreach from=$pickup item=library}
                  {if $library.locationID == $resource.ils_details.location}
                    {assign var="pickupDisplay" value=$library.locationDisplay}
                    {assign var="pickupTranslate" value="1"}
                  {/if}
                {/foreach}
              {/if}
              {if empty($pickupDisplay)}
                {assign var="pickupDisplay" value=$resource.ils_details.location}
              {/if}
            {/if}
            {if !empty($pickupDisplay)}
              , <strong>{translate text='pick_up_location'}:</strong>
              {if $pickupTranslate}{translate text=$pickupDisplay}{else}{$pickupDisplay|escape}{/if}
            {/if}
            <br />

            {if $resource.ils_details.created}<strong>{translate text='Created'}:</strong> {$resource.ils_details.created|escape}{/if}
            {if $resource.ils_details.processed}<br/><strong>{translate text='Processed'}:</strong> {$resource.ils_details.processed|escape}{/if}
            <br />

            {foreach from=$cancelCallSlipResults.items item=cancelResult key=itemId}
              {if $itemId == $resource.ils_details.item_id && $cancelResult.success == false}
                <div class="error">{translate text=$cancelCallSlipResult.status}{if $cancelResult.sysMessage} : {translate text=$cancelResult.sysMessage|escape}{/if}</div>
              {/if}
            {/foreach}

            {if $resource.ils_details.available}
              <span class="available">{translate text="call_slip_available"}</span>
            {/if}
            {if $resource.ils_details.cancelled}
              <span class="cancelled"><strong>{translate text="call_slip_cancelled"}:</strong> {$resource.ils_details.cancelled}</span>
            {/if}

          </td> <!-- class="duedate" -->
        </tr>
    {/foreach}
    </table>
    </form>
    {else}
      <div class="noContentMessage">{translate text='You do not have any requests placed'}.</div>
    {/if}
    {/if}
  {else}
    {include file="MyResearch/catalog-login.tpl"}
  {/if}
  </div>
</div>
</div>

<div class="clear"></div>

{literal}
<script type="text/javascript">
    $(document).ready(function(){
        $('select#pickUpLocation').change(function() {
            $('.holdsMessage').fadeOut(100);
            var pickup = $(this).val();
            var created = $(this).data('created');
            var expires = $(this).data('expires');
            var reservationId = $(this).data('reservationid');
            var url = path + '/AJAX/JSON_Hold?' + $.param({method:'changePickupLocation', pickup :pickup, created:created, expires:expires, reservationId:reservationId });
            $('#pickUpLoader').addClass('ajax_hold_request_loading');
            $.ajax({
                type: "GET",
                url: url,
                dataType: 'json',
            }).always(function() {
                $('#pickUpLoader').removeClass();
                if (!$('.holdsMessage').length ) {
                    $('.resultHead').append($('<div style="display:none;" class="holdsMessage"></div>'));
                }
            }).done(function(msg) {
                var holdsMsg = '';
                if (msg.status == 'OK') {
                    holdsMsg = '<p class="success">{/literal}{translate text="call_slip_change_success"}{literal}</p>';
                } else {
                    holdsMsg = '<p class="error">{/literal}{translate text="call_slip_change_fail"}{literal}</p>';
                }
                $('.holdsMessage').html(holdsMsg).fadeIn(100);
            }).error(function(msg) {
                $('.holdsMessage').html('<p class="error">{/literal}{translate text="call_slip_change_fail"}{literal}</p>').fadeIn(100);
            });
        });
    });
</script>
{/literal}

<!-- END of: MyResearch/holds.tpl -->
