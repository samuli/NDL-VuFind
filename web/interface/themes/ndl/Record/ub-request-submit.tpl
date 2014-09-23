<!-- START of: Record/ub-request-submit.tpl -->

{if $user->cat_username}

  {if !$lightbox}
  <h2>{translate text='ub_request_place_text'}</h2>
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
  <div class="ub-request-form">

    <form name="requestForm" action="{$url|escape}/Record/{$id|escape}/UBRequest{$formURL|escape}#tabnav" method="post">
      {if $lightbox}
      <input type="hidden" name="lightbox" value="1" />
      <input type="hidden" name="placeRequest" value="1" />
      {/if}

      <p>{translate text="ub_request_instructions"}</p>

      <div>
        <strong>{translate text="ub_request_item"}:</strong><br/>
        <select name="gatheredDetails[itemId]">
          {foreach from=$items item=item}
          <option value="{$item.id|escape}"{if $gatheredDetails.itemId == $library.id} selected="selected"{/if}>{$item.name|escape}</option>
          {/foreach}
        </select>
      </div>

      <div>
        <strong>{translate text="ub_request_pickup_library"}:</strong><br/>
        {if $libraries|@count gt 1}
        <select id="pickupLibrary" name="gatheredDetails[pickupLibrary]">
          {foreach from=$libraries item=library}
          <option value="{$library.id|escape}"{if ($gatheredDetails.pickupLibrary && $gatheredDetails.pickupLibrary == $library.id) || (!$gatheredDetails.pickupLibrary && $library.isDefault)} selected="selected"{/if}>{$library.name|translate_prefix:'library_'|escape}</option>
          {/foreach}
        </select>
        {else}
        <input type="hidden" id="pickupLibrary" name="gatheredDetails[pickupLibrary]" value="{$libraries[0].id|escape}" />
        <p>{$libraries[0].name|translate_prefix:'library_'|escape}</p>
        {/if}
      </div>

      <div>
        <p id="pickupLocationLabel"><strong>{translate text="ub_request_pickup_location"}:</strong></p>
        <select id="pickupLocation" name="gatheredDetails[pickupLocation]">
        </select>
      </div>
      
      <div>
        <strong>{translate text="ub_request_required_by"}: </strong>
        <div id="requiredByHolder"><input id="requiredByDate" type="text" name="gatheredDetails[requiredBy]" value="{if $gatheredDetails.requiredBy}{$gatheredDetails.requiredBy|escape}{else}{$requiredBy}{/if}" size="10" /> <strong>({displaydateformat})</strong></div>
      </div>
      
      <input type="submit" class="button buttonFinna" name="placeRequest" value="{translate text="ub_request_submit_text'}"/>

    </form>

  </div>
  {/if}
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
    setUpUBRequestForm('{$id|escape}');
});
</script>

<!-- END of: Record/ub-request-submit.tpl -->
