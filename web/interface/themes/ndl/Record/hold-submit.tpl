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

  {if $gatheredDetails}
  <div class="hold-form">

    <form name="requestForm" action="{$url|escape}/Record/{$id|escape}/Hold{$formURL|escape}" method="post">
      {if $lightbox}
      <input type="hidden" name="lightbox" value="1" />
      <input type="hidden" name="placeHold" value="1" />
      {/if}

      {if in_array("comments", $extraHoldFields)}
        <div>
        <strong>{translate text="Comments"}:</strong><br/>
        <textarea rows="3" cols="20" name="gatheredDetails[comment]">{$gatheredDetails.comment|escape}</textarea>
        </div>
      {/if}

      {if in_array("requiredByDate", $extraHoldFields)}
        <div>
        <strong>{translate text="hold_required_by"}: </strong>
        <div id="requiredByHolder"><input id="requiredByDate" type="text" name="gatheredDetails[requiredBy]" value="{if $gatheredDetails.requiredBy !=""}{$gatheredDetails.requiredBy|escape}{else}{$defaultDuedate}{/if}" size="10" /> <strong>({displaydateformat})</strong></div>
        </div>
      {/if}

      {if in_array("pickUpLocation", $extraHoldFields)}
        <div>
        {if count($pickup) > 1}
          {if $gatheredDetails.pickUpLocation !=""}
            {assign var='selected' value=$gatheredDetails.pickUpLocation}
          {elseif $home_library != ""}
            {assign var='selected' value=$home_library}
          {else}
            {assign var='selected' value=$defaultPickUpLocation}
          {/if}
          <strong>{translate text="pick_up_location"}:</strong><br/>
          <select name="gatheredDetails[pickUpLocation]">
          {foreach from=$pickup item=lib name=loop}
            <option value="{$lib.locationID|escape}" {if $selected == $lib.locationID}selected="selected"{/if}>{$lib.locationDisplay|escape}</option>
          {/foreach}
          </select>
        {else}
          <input type="hidden" name="gatheredDetails[pickUpLocation]" value="{$defaultPickUpLocation|escape}" />
        {/if}
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

{if $lightbox}
{literal}
<script type="text/javascript">
$(document).ready(function(){
    lightboxDocumentReady();
});
</script>
{/literal}
{/if}

<!-- END of: Record/hold-submit.tpl -->
