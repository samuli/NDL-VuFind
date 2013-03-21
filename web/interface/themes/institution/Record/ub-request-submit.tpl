<!-- START of: Record/ub-request-submit.tpl -->

{if $user->cat_username}

  <h2>{translate text='ub_request_place_text'}</h2>

  {* This will always be an error as successes get redirected to MyResearch/Holds.tpl *}
  {if $results.status}
    <p class="error">{translate text=$results.status}</p>
  {/if}
  {if $results.sysMessage}
    <p class="error">{translate text=$results.sysMessage}</p>
  {/if}

  <div class="ub-request-form">

    <form action="{$url|escape}/Record/{$id|escape}/UBRequest{$formURL|escape}#tabnav" method="post">

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
        <select id="pickupLibrary" name="gatheredDetails[pickupLibrary]">
          {foreach from=$libraries item=library}
          <option value="{$library.id|escape}"{if ($gatheredDetails.pickupLibrary && $gatheredDetails.pickupLibrary == $library.id) || (!$gatheredDetails.pickupLibrary && $library.isDefault)} selected="selected"{/if}>{$library.name|translate_prefix:'library_'|escape}</option>
          {/foreach}
        </select>
      </div>

      <div>
        <span id="pickupLocationLabel"><strong>{translate text="ub_request_pickup_location"}:</strong></span><br/>
        <select id="pickupLocation" name="gatheredDetails[pickupLocation]">
        </select>
      </div>
      
      <div>
        <strong>{translate text="ub_request_required_by"}: </strong>
        <div id="requiredByHolder"><input id="requiredByDate" type="text" name="gatheredDetails[requiredBy]" value="{if $gatheredDetails.requiredBy}{$gatheredDetails.requiredBy|escape}{else}{$requiredBy}{/if}" size="8" /> <strong>({displaydateformat})</strong></div>
      </div>
      
      <div>
        <strong>{translate text="ub_request_comments"}:</strong><br/>
        <input type="text" name="gatheredDetails[comment]" size="100" maxlength="100" value="{$gatheredDetails.comment|escape}"></input>
      </div>

      <input type="submit" name="placeRequest" value="{translate text="ub_request_submit_text'}"/>

    </form>

  </div>
{else}
  {include file="MyResearch/catalog-login.tpl"}
{/if}

<!-- END of: Record/ub-request-submit.tpl -->
