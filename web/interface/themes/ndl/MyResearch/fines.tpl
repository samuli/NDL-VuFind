<!-- START of: MyResearch/fines.tpl -->

{include file="MyResearch/menu.tpl"}
<div class="myResearch finesList{if $sidebarOnLeft} last{/if}">
  <div class="content">
        
    {* NDLBlankInclude *}
    <div class="noContentMessage">{translate text='fines_instructions'}</div>
    {* /NDLBlankInclude *}
    {if empty($catalogAccounts)}
    	<p class="noContentMessage">{translate text='You do not have any library cards'}</p>
   			 <a class="button buttonFinna" type="button" href="{$url}/MyResearch/Accounts?add=1" />{translate text='Link Library Card'}...</a>
    {/if}
    {if !empty($catalogAccounts)}
    <div class="grid_24">
      {if $profile.blocks}
        {foreach from=$profile.blocks item=block name=loop}
          <p class="borrowingBlock"><strong>{translate text=$block|escape}</strong></p>
        {/foreach}
      {/if}
    <h2>{translate text='Your Fines'}: 
     {foreach from=$catalogAccounts item=account}
        	{if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
     {/foreach} 
            {if !empty($accountname)}({/if}{assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}{translate text=$source prefix='source_'}{if !empty($accountname)}){/if}
    </h2>
    {if $user->cat_username}
     {if empty($rawFinesData)}
      <p class="noContentMessage">{translate text='You do not have any fines'}</p>
     {else}

    
    <table class="datagrid fines" summary="{translate text='Your Fines'}">
      {if $driver == 'AxiellWebServices'}
        <tr>
          <th style="width:60%;">{translate text='Incident'}</th>
          <th>{translate text='Recording Date'}</th>
          <th>{translate text='Unpaid Fines'}</th>
        </tr>
        {foreach from=$rawFinesData item=record}
          <tr>
            <td class="axiellRecordFine">
              {translate text=$record.fine|escape prefix="status_"}. 
            </td>
            <td>{$record.duedate|escape}</td>
            <td>{$record.balance/100.00|safe_money_format|replace:"Eu":" €"|escape}</td>
          </tr>
        {/foreach}
        <tr><td colspan="5" class="fineBalance">{translate text='Balance total'}: <span class="hefty">{$sum/100.00|safe_money_format|replace:"Eu":" €"|escape}</span></td></tr>
      {else}
        <tr>
          <th style="width:50%;">{translate text='Title'}</th>
          <th>{translate text='Checked Out'}</th>
          <th>{translate text='Due Date'}</th>
          <th>{translate text='Fine'}</th>
          {* <th>{translate text='Fee'}</th> *}
          <th class="alignRight">{translate text='Balance'}</th>
        </tr>
        {foreach from=$rawFinesData item=record}
          <tr>
            <td>
          {if is_array($record.format)}
          {assign var=mainFormat value=$record.format.0} 
          {assign var=displayFormat value=$record.format|@end} 
          {else}
          {assign var=mainFormat value=$record.format} 
          {assign var=displayFormat value=$record.format} 
          {/if}
          <span class="icon format{$mainFormat|lower|regex_replace:"/[^a-z0-9]/":""} format{$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}" title="{translate text=$displayFormat prefix='format_'}">{*translate text=format_$displayFormat*}</span>
              {if empty($record.title)}
                {translate text='not_applicable'}
              {else}
                <a href="{$url}/Record/{$record.id|escape}">{$record.title|trim:'/:'|escape}</a>
              {/if}
            </td>
            <td>{$record.checkout|escape}</td>
            <td>{$record.duedate|escape}</td>
            <td class="fine">{translate text=$record.fine|escape prefix="status_"}</td>
            {* <td>{$record.amount/100.00|safe_money_format|escape}</td> *}
            <td style="text-align:right;">{$record.balance/100.00|safe_money_format|replace:"Eu":" €"|escape}</td>
          </tr>
        {/foreach}
        <tr><td colspan="5" class="fineBalance">{translate text='Balance total'}: <span class="hefty">{$sum/100.00|safe_money_format|replace:"Eu":" €"|escape}</span></td></tr>
      {/if}
    </table>
    {/if}
    {/if}
  {else}
    {include file="MyResearch/catalog-login.tpl"}
  {/if}
  </div>
</div>
</div>
<div class="clear"></div>

<!-- END of: MyResearch/fines.tpl -->
