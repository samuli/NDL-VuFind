<!-- START of: Record/hold-submit.tpl -->

{if $user->cat_username}

<div class="clear"></div>

<div class="content">

  {if !$lightbox}
  <h2>{translate text='request_place_text'}</h2>
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
  <div class="hold-form">

    <form name="requestForm" action="{$url|escape}/Record/{$id|escape}/Hold{$formURL|escape}" method="post">
      {if $lightbox}
      <input type="hidden" name="lightbox" value="1" />
      <input type="hidden" name="placeHold" value="1" />
      {/if}

      {if is_array($requestGroups)}
      <div>
        <strong>{translate text="hold_request_group"}:</strong><br/>
        <select id="requestGroupId" name="gatheredDetails[requestGroupId]">
          {if $defaultRequestGroup === false}
          <option value=""{if !$gatheredDetails.requestGroupId} selected="selected"{/if}>{translate text='hold_select_request_group'}</option>
          {/if}
          {foreach from=$requestGroups item=requestGroup}
          <option value="{$requestGroup.id|escape}"{if ($gatheredDetails.requestGroupId && $gatheredDetails.requestGroupId == $requestGroup.id) || ($defaultRequestGroup !== false && !$gatheredDetails.requestGroupId && $requestGroup.isDefault)} selected="selected"{/if}>{$requestGroup.name|translate_prefix:'request_group_'|escape}</option>
          {/foreach}
        </select>
      </div>
      {/if}

      {if in_array("pickUpLocation", $extraHoldFields)}
        {if $gatheredDetails.pickUpLocation !=""}
          {assign var='selected' value=$gatheredDetails.pickUpLocation}
        {elseif $home_library != ""}
          {assign var='selected' value=$home_library}
        {else}
          {assign var='selected' value=$defaultPickUpLocation}
        {/if}
        <div>
        {if is_array($requestGroups)}
          <span id="pickupLocationLabel"><strong>{translate text="pick_up_location"}:</strong></span><br/>
          <select id="pickupLocation" name="gatheredDetails[pickUpLocation]" data-default="{$selected|escape}">
            {if $defaultPickUpLocation === false}
            <option value="" selected="selected">{translate text='hold_select_pickup_location'}</option>
            {/if}
          </select>
        {else}
          {if count($pickup) > 1}
            <strong>{translate text="pick_up_location"}:</strong><br/>
            <select name="gatheredDetails[pickUpLocation]">
            {foreach from=$pickup item=lib name=loop}
              <option value="{$lib.locationID|escape}" {if $selected == $lib.locationID}selected="selected"{/if}>{$lib.locationDisplay|escape}</option>
            {/foreach}
            </select>
          {else}
            <input type="hidden" name="gatheredDetails[pickUpLocation]" value="{$defaultPickUpLocation|escape}" />
          {/if}
        {/if}
        </div>
      {/if}

      {if in_array("requiredByDate", $extraHoldFields)}
        <div>
        <strong>{translate text="hold_required_by"}: </strong>
        <div id="requiredByHolder"><input id="requiredByDate" type="text" name="gatheredDetails[requiredBy]" value="{if $gatheredDetails.requiredBy !=""}{$gatheredDetails.requiredBy|escape}{else}{$defaultDuedate}{/if}" size="10" /> <strong>({displaydateformat})</strong></div>
        </div>
      {/if}

      {if in_array("comments", $extraHoldFields)}
        <div>
        <strong>{translate text="Additional information"}:</strong><br/>
        <textarea rows="3" cols="20" name="gatheredDetails[comment]">{$gatheredDetails.comment|escape}</textarea>
        </div>
      {/if}

      <input type="submit" class="button buttonFinna" name="placeHold" value="{translate text='request_submit_text'}"/>

    </form>

  </div>
  {/if}
</div>

{else}
  {include file="MyResearch/catalog-login.tpl"}
{/if}

<script type="text/javascript">
{literal}
$(document).ready(function(){
{/literal}
{if $lightbox}
    lightboxDocumentReady();
{/if}
    setUpHoldRequestForm('{$id|escape}');
});
</script>

<!-- END of: Record/hold-submit.tpl -->
