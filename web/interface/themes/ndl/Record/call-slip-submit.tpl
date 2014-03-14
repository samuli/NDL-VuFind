<!-- START of: Record/call-slip-submit.tpl -->

{if $user->cat_username}

  {if !$lightbox}
  <h2>{translate text='call_slip_place_text'}</h2>
  {/if}

  {* This will always be an error as successes get redirected to MyResearch/Holds.tpl *}
  {if $results.status}
    <p class="error">{translate text=$results.status}</p>
  {/if}
  {if $results.sysMessage}
    <p class="error">{translate text=$results.sysMessage}</p>
  {/if}

  {if $helpText}
    <p class="helptext">{$helpText}</p>
  {/if}

  {if $gatheredDetails}
  <div class="call-slip-form">

    <form name="requestForm" action="{$url|escape}/Record/{$id|escape}/CallSlip{$formURL|escape}#tabnav" method="post">
      {if $lightbox}
      <input type="hidden" name="lightbox" value="1" />
      <input type="hidden" name="placeRequest" value="1" />
      {/if}

      <p>{translate text="call_slip_instructions"}</p>

      {if in_array("item-issue", $extraFields)}
      <div>
        <strong><input type="radio" id="callSlipItem" name="gatheredDetails[level]" value="copy"{if $gatheredDetails.level != 'title'} checked="checked"{/if}>{translate text="call_slip_selected_item"}</input></strong><br/>
        <strong><input type="radio" id="callSlipTitle" name="gatheredDetails[level]" value="title"{if $gatheredDetails.level == 'title'} checked="checked"{/if}>{translate text="call_slip_reference"}:</input></strong><br/>
        <div id="callSlipReference" class="reference">
          <span class="label">{translate text="call_slip_volume"}:</span> <input type="text" name="gatheredDetails[volume]" value="{$gatheredDetails.volume|escape}"></input><br/>
          <span class="label">{translate text="call_slip_issue"}:</span> <input type="text" name="gatheredDetails[issue]" value="{$gatheredDetails.issue|escape}"></input><br/>
          <span class="label">{translate text="call_slip_year"}:</span> <input type="text" name="gatheredDetails[year]" value="{$gatheredDetails.year|escape}"></input><br/>
        </div>
      </div>
      {/if}
      
      {if in_array("pickUpLocation", $extraFields)}
        {if $gatheredDetails.pickUpLocation !=""}
          {assign var='selected' value=$gatheredDetails.pickUpLocation}
        {elseif $home_library != ""}
          {assign var='selected' value=$home_library}
        {else}
          {assign var='selected' value=$defaultPickUpLocation}
        {/if}
        <div>
        {if count($pickup) > 1}
          <strong>{translate text="pick_up_location"}:</strong><br/>
          <select name="gatheredDetails[pickUpLocation]">
          {if $defaultPickUpLocation === false}
          <option value="" selected="selected">{translate text='hold_select_pickup_location'}</option>
          {/if}
          {foreach from=$pickup item=lib name=loop}
            <option value="{$lib.locationID|escape}" {if $selected == $lib.locationID}selected="selected"{/if}>{$lib.locationDisplay|escape}</option>
          {/foreach}
          </select>
        {else}
          <input type="hidden" name="gatheredDetails[pickUpLocation]" value="{$defaultPickUpLocation|escape}" />
        {/if}
        </div>
      {/if}
      
      {if in_array("comments", $extraFields)}
      <div>
        <strong>{translate text="call_slip_comments"}:</strong><br/>
        <input type="text" name="gatheredDetails[comment]" size="80" maxlength="100" value="{$gatheredDetails.comment|escape}"></input>
      </div>
      {/if}

      <input type="submit" class="button buttonFinna" name="placeRequest" value="{translate text="call_slip_submit_text'}"/>
      
    </form>

  </div>
  {/if}

{literal}
<script type="text/javascript">
$(document).ready(function() {
  $("input[type='radio']").change(function() {
    if ($('#callSlipItem').attr('checked') == 'checked') {
      $('#callSlipReference input').attr('disabled', 'disabled');
    } else {
      $('#callSlipReference input').removeAttr('disabled');
    }
  });
  $('#callSlipItem').trigger('change');
});
</script>
{/literal}

{else}
  {include file="MyResearch/catalog-login.tpl"}
{/if}

{if $lightbox}
{literal}
<script type="text/javascript">
$(document).ready(function(){
    lightboxDocumentReady();
});
</script>
{/literal}
{/if}

<!-- END of: Record/call-slip-submit.tpl -->
