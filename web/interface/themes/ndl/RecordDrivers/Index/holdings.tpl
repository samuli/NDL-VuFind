<!-- START of: RecordDrivers/Index/holdings.tpl -->

<div class="holdingsHeader clearfix">
  <div class="holdingsHoldingURLs">
  {if !empty($holdingURLs) || $holdingsOpenURL}
    <h5>{translate text="Internet"}</h5>
    {if !empty($holdingURLs)}
      {foreach from=$holdingURLs item=desc key=currentUrl name=loop}
        <a href="{$currentUrl|proxify|escape}" target="_blank">{$desc|translate_prefix:'link_'|escape}</a><br/>
      {/foreach}
    {/if}
    {if $holdingsOpenURL}
      {include file="Search/openurl.tpl" openUrl=$holdingsOpenURL}
    {/if}
  {/if}
  </div>
  <div class="holdingsHeaderLinks">
    {if $id|substr:0:7 == 'helmet.'}
      <span class="native_link">
        <a href="http://haku.helmet.fi/iii/encore/record/C|R{$id|substr:7|escape}" target="_blank">{translate text='Holdings details from'} HelMet</a><br/>
      </span>
    {/if}
    {assign var="ublink" value=false}
    {foreach from=$holdings item=holding}
      {if !$ublink}
        {foreach from=$holding item=row}
          {if !$ublink && $row.UBRequestLink}
            <a class="UBRequestPlace checkUBRequest" href="{$row.UBRequestLink|escape}"><span>{translate text="ub_request_check"}</span></a>
            {assign var="ublink" value=true}
          {/if}
        {/foreach}
      {/if}
    {/foreach}
  </div>
  <div class="holdingsPlaceHold">
    {if !$hideLogin && $offlineMode != "ils-offline"}
      {if ($driverMode  && !empty($holdings)) || $titleDriverMode}
        {if $showLoginMsg || $showTitleLoginMsg}
            <a class="button buttonFinna" href="{$path}/MyResearch/Home?followup=true&followupModule=Record&followupAction={$id}">{translate text="Login"}</a> {translate text="hold_login"}
        {/if}
        {if $user && !$user->cat_username}
            <a class="button buttonFinna" href="{$path}/MyResearch/Profile">{translate text="Add an account to place holds"}</a>
        {/if}
      {/if}
    {/if}
    {if $holdingTitleHold && $holdingTitleHold != 'block'}
        <a class="button buttonFinna holdPlace" href="{$holdingTitleHold|escape}">{translate text="title_hold_place"}</a>
    {/if}
    {if $holdingTitleHold == 'block'}
        {translate text="hold_error_blocked"}
    {/if}
  </div>
</div>

<div class="holdingsContainerHeader">
  <h5>{translate text=$source prefix='source_'}</h5>
</div>

<div class="holdingsContainer clearfix">
  {if !$holdings}
    <h5>{translate text="No holdings information available"}</h5>
  {/if}
  {foreach from=$holdings item=holding key=location name=holdings}
    {assign var=prevMfhdId value=''}
    {assign var="copyCount" value="0"}
    {foreach from=$holding item=row name=items}
      {assign var="itemsIteration" value=$smarty.foreach.items.iteration}
      {if $prevMfhdId != $row.mfhd_id}
        {assign var="showCopyTitle" value=1}
        
        {if $prevMfhdId}
          <tr class="avail"><td>{$availCount}</td></tr>
          </table>
        {/if}
        {assign var=prevMfhdId value=$row.mfhd_id}
        <table class="holdingsContainerHolding" id="holding_{$prevMfhdId}_{$itemsIteration}" cellpadding="2" cellspacing="0" border="0" class="citation" summary="{translate text='Holdings details from'} {translate text=$location}">
        <tr class="holdingsContainerHeading">

          
          <th colspan="2" class="location"><span class="arrowIndicator"></span>{$location|translate|escape}</th>
          <th colspan="2" class="holdingDetails">
            <span class="availability">{translate text="Available"}</span>
            <span class="returnDate">{translate text="Due"}:</span>
          </th>
          <th class="locationLink">
            {if $locationServiceUrl}
              <a class="openLocationService" href="{$locationServiceUrl}&callno={$row.callnumber|escape:'url'}">
              {$row.callnumber|escape}</a>
            {else}
              {$row.callnumber|escape}
            {/if}
          </th>
        </tr>
        <tr class="mobileLocation">          
          <td colspan="5" class="locationLink">
            {if $locationServiceUrl}
              <a class="openLocationService" href="{$locationServiceUrl}&callno={$row.callnumber|escape:'url'}">
              {$row.callnumber|escape}</a>
            {else}
              {$row.callnumber|escape}
            {/if}
          </td>
        </tr>
        
        
          {assign var="availCount" value=0}
          {if $row.summary}
            <tr>
              <td class="copyTitle">{translate text="Volume Holdings"}: </td>
              <td colspan="4">
                {foreach from=$row.summary item=summary}
                  {$summary|escape}<br>
                {/foreach}
              </td>
            </tr>
          {/if}
          {if $row.purchase_history}
            <tr>
              <td class="copyTitle">{translate text="Most Recent Received Issues"}: </td>
              <td colspan="4">
                {foreach from=$row.purchase_history item=row}
                  {$row.issue|escape}<br>
                {/foreach}
              </td>
            </tr>
          {/if}
          {if $row.notes}
            <tr>
              <td class="copyTitle">{translate text="Notes"}: </td>
              <td colspan="4">
                {foreach from=$row.notes item=data}
                  {$data|escape}<br>
                {/foreach}
              </td>
            </tr>
          {/if}
          {if $row.supplements}
            <tr>
              <td class="copyTitle">{translate text="Supplements"}: </td>
              <td colspan="4">
                {foreach from=$row.supplements item=supplement}
                  {$supplement|escape}<br>
                {/foreach}
              </td>
            </tr>
          {/if}
          {if $row.indexes}
            <tr>
              <td class="copyTitle">{translate text="Indexes"}: </td>
              <td colspan="4">
                {foreach from=$row.indexes item=index}
                  {$index|escape}<br>
                {/foreach}
              </td>
            </tr>
          {/if}
        {/if}
        {if $row.item_id}
          {if $copyCount == 5}<tr class="toggleCopyDetails"><td class="copyTitle"></td><td colspan="2"><strong><a href="#">{translate text="More Results"}</a></strong></td></tr>{/if}
          <tr class="copyDetails {if $showCopyTitle}{counter start=0 assign=copyCount}first{/if} {if $copyCount >= 5}hidden{/if}">
            {counter assign=copyCount}
            {if $showCopyTitle}<td class="copyTitle">{translate text="Copies"}{assign var="showCopyTitle" value=0}</td>
            {else}<td></td>{/if}
            <td class="copyNumber">{translate text="Copy"} {$row.number|escape}</td>
            <td colspan="3" class="copyInfo">
              {if $row.reserve == "Y"}
                {translate text="On Reserve - Ask at Circulation Desk"}
              {elseif $row.use_unknown_message}
                <span class="unknown">{translate text="status_unknown_message"}</span>
              {else}

                {if $row.availability}
                  {assign var=availCount value=$availCount+1}
                  {* Begin Available Items (Holds) *}
                  <span class="available">{translate text="Available"}</span>
                  {if $row.link}
                    <a class="holdPlace{if $row.check} checkRequest{/if}" href="{$row.link|escape}"><span>{if !$row.check}{translate text="Place a Hold"}{else}{translate text="Check Hold"}{/if}</span></a>
                  {/if}
                  {if $row.callSlipLink}
                    <a class="callSlipPlace{if $row.checkCallSlip} checkCallSlipRequest{/if}" href="{$row.callSlipLink|escape}"><span>{if !$row.checkCallSlip}{translate text="call_slip_place_text"}{else}{translate text="Check Call Slip Request"}{/if}</span></a>
                  {/if}

                {else}
                {* Begin Unavailable Items (Recalls) *}
                  <span class="checkedout">{translate text=$row.status prefix='status_'}</span>
                  {if $row.returnDate} <span class="statusExtra"><span class="returnDate">{$row.returnDate|escape}</span></span>
                  {/if}
                  {if $row.duedate}
                    <span class="statusExtra">{translate text="Due"}: <span class="returnDate">{$row.duedate|escape}</span></span>
                  {/if}
                  {if $row.requests_placed > 0}
                    <span>{translate text="Requests"}: {$row.requests_placed|escape}</span>
                  {/if}
                  {if $row.link}
                    <a class="holdPlace{if $row.check} checkRequest{/if}" href="{$row.link|escape}"><span>{if !$row.check}{translate text="Recall This"}{else}{translate text="Check Recall"}{/if}</span></a>
                  {/if}
                {/if}
              {/if}
            </td>
          </tr>
        {/if}
      {/foreach}
      <tr class="avail"><td>{$availCount}</td></tr>
      </table>
  {/foreach}
</div>

{literal}
<script type="text/javascript">
$(document).ready(function() {

  // IE8 compatible Date.now()
  Date.now = Date.now || function() { return +new Date; }; 

  /* Open volume details by clicking on the heading */
  $('.holdingsContainerHeading').click(function() {
    $(this).closest('table').toggleClass('active');
  })

  /* Show more/less copy information */
  $('.toggleCopyDetails a').click(function(e) {
    e.preventDefault();
    $(this).toggleClass('active');
    var $parentTr = $(this).closest('tr'),
        $copyDetails = $parentTr.siblings('.copyDetails'),
        openText = '{/literal}{translate text="More Results"}{literal}',
        closeText = '{/literal}{translate text="Fewer Results"}{literal}';

    // Change .hidden to .visible
    $copyDetails.each(function() {
      if ($(this).is('.hidden')) {
        $(this).removeClass('hidden').addClass('visible');
      } else if ($(this).is('.visible')) {
        $(this).removeClass('visible').addClass('hidden');
      }
    });

    // Move the toggler and change its content accordingly
    if ($(this).is('.active')) {
      $(this).text(closeText);
      $parentTr.insertAfter($copyDetails.last());
    } else {
      $(this).text(openText);
    }
  })

  /* Show copy details in the heading */
  $('.holdingsContainerHolding').each(function() {

    var availableCount = $(this).find('.avail td').text();
        $headingAvail = $(this).find('.holdingsContainerHeading .availability');
        iBlock = {'display': 'inline-block'},
        msg = '{/literal}{translate text="Available"}{literal}';

    /* If there are available copies, show the number */
    if (availableCount > 0) {
      $headingAvail.addClass('available');
      $headingAvail.text(availableCount + ' ' + $headingAvail.text().toLowerCase()).show();
    } else { /* If no available copies, get return dates */
      var prevDate, firstDate, firstDateText;
      $(this).find('.copyDetails .returnDate').each(function() {
        var returnDateSplit = $(this).text().split('.'); /* Split the date and build it anew */
        var returnDate = new Date(returnDateSplit[2], returnDateSplit[1] - 1, returnDateSplit[0]);
        if (typeof prevDate == 'undefined' || returnDate < prevDate) { 
          firstDate = returnDate; /* Get the closest date to today... */
          firstDateText = $(this).parent().prev('.checkedout').text(); /* ...and the accompanying text */
        }
        prevDate = firstDate;
      })

      /* If a return date exists */
      if (typeof firstDate != 'undefined') {
        var $dateTarget = $(this).find('.holdingDetails .returnDate');
        $dateTarget.append(' ' + firstDate.getDate() + '.' + 
          (firstDate.getMonth() + 1) + '.' +firstDate.getFullYear()).css(iBlock)

        $headingAvail.addClass('checkedout').text(firstDateText).css(iBlock);

      } else { /* Without a date, only show the checkedout message */
        var availText = $(this).find('.checkedout').text();
        if (availText != '') {
        $headingAvail.addClass('checkedout').text(availText).css(iBlock);
        } else { /* If no message found, print the default one */
          $headingAvail.addClass('available').text(msg).css(iBlock);
        }
      }
    }
  });

  $('a.holdPlace,a.callSlipPlace,a.UBRequestPlace').click(function() {
    var id = {/literal}'{$id}'{literal};
    var href = $(this).attr('href');
    var hashPos = href.indexOf('#');
    if (hashPos >= 0) {
      href = href.substring(0, hashPos);      
    }
    var $dialog = getPageInLightbox(href + '&lightbox=1', $(this).text(), 'Record', '', id);
    return false;
  });
});
</script>
{/literal}
<!-- END of: RecordDrivers/Index/holdings.tpl -->
