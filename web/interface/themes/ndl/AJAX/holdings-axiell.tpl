<!-- START of: AJAX/holdings-axiell.tpl -->

{if $locationTreshold < $locationCount}
  {assign var="collapseLocations" value=true}
{/if}

{if $branchTreshold < $branchCount}
  {assign var="collapseBranch" value=true}
{/if}

<table class="resultHoldingsContainer">
  {if !$holdings}
    <tr><td><span>{translate text="No holdings information available"}</span></tr></td>
  {else}
    <tr class="resultHoldingsHeading">
      <th class="{if $collapseLocations}collapsible collapsed{/if}">
        {if $availableLocationCount > 0}
          <span class="availability available">{translate text="axiell_available"} {if $journal} {$availableCount} numeroa {else} {$branchCount} {translate text="axiell_branches_alt"}{/if}</span>
        {else}
          {if $closestDueDate != ''}
            <span class="availability checkedout">{translate text="status_Charged"}
              <span class="duedate">{translate text="Due Date"} {$closestDueDate}</span>
            </span>
          {elseif $itemStatusText == 'On Reference Desk'}
            <span class="availability available">{translate text="status_`$itemStatusText`"}</span>
          {else}
            <span class="availability checkedout">{translate text="status_`$itemStatusText`"}</span>
          {/if}
        {/if}
        {if $collapseLocations}<span class="arrowIndicator collapsed"></span>{/if}
      </th>
      <th>{translate text="Requests"} {$requestCount}, {translate text="axiell_items"} {$holdCount}</th>
    </tr>
    {foreach from=$holdings item=location name=locations}
      <tr class="{if $collapseLocations}collapsed{/if}">
        <td colspan="2">
          <table>
            <tr>
              <th class="{if $collapseBranch}collapsible collapsed{/if}"><span class="indent">{if $collapseBranch}<span class="arrowIndicator collapsed"></span>{/if}
                {$location.title} 
                {if $collapseBranch}
                  {if $location.status.availableCount > 0}
                     ({translate text="axiell_available"|lower} {$location.status.availableCount} {translate text="axiell_branches_alt"})
                  {elseif $location.status.text=="Closest due"}
                    ({translate text=$location.status.text} {$location.status.closestDueDate})
                  {else}
                    ({translate text="status_`$location.status.text`"})
                  {/if}
                {/if}
              </span></th>
              <th>{$location.callnumber}</th>
            </tr>
            {foreach from=$location.holdings item=holding name=holding}
              <tr class="{if $collapseBranch}collapsed{/if}">
                <td class="copyNumber">
                  <span class="holdingText indent {if $holding.availability || $holding.status=="On Reference Desk"}available{else}checkedout{/if}">
                    {if $journal}{$location.organisation}, {/if}{$holding.branch}, {$holding.department}{if $holding.location}, {$holding.location}{/if}
                  </span>
                </td>
                <td> 
                  {if $holding.available > 0}
                    {translate text="Available items"}: {$holding.available}
                  {else}
                    {if $holding.duedate != '' && !$holding.availability}
                      {translate text="Closest due"} {$holding.duedate}
                    {elseif $holding.ordered > 0}
                      {translate text="status_Ordered} {$holding.ordered}
                    {else}
                      {translate text="status_`$holding.status`"}
                    {/if}
                  {/if}
                </td>
              </tr>
            {/foreach}
          </table>
        </td>
      </tr> 
    {/foreach}
    {if $patronFunctions && $holdingTitleHold && $holdingTitleHold != 'block'}
      <tr>
        <td colspan="2">
          <div class="holdingsPlaceHold axiell">
            <a data-id="{$id}" class="button buttonFinna holdPlace" href="{$holdingTitleHold|escape}">{translate text="title_hold_place"}</a>
          </div>
        </td>
      </tr>
    {/if}
    <tr>
      <td colspan="2">
          <a class="moreHoldings" href="{$path}/Record/{$id|escape}#ui-tabs-1">{translate text="axiell_see_all_holdings"} »</a>
      </td>
    </tr>
  {/if}
</table>

<!-- END of: AJAX/holdings-axiell.tpl -->