<!-- START of: MyResearch/fines.tpl -->
{if $registerPayment}
   {js filename="webpayment.js"}
{/if}


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
      {if $errorMsg || $infoMsg}
        <div class="messages">
        {if $errorMsg}<p class="error">{$errorMsg|translate}</p>{/if}
        {if $infoMsg}<p class="info">{$infoMsg|translate}</p>{/if}
        </div>
      {/if}
      {if $profile.blocks}
        {foreach from=$profile.blocks item=block name=loop}
          <p class="borrowingBlock"><strong>{translate text=$block|escape}</strong></p>
        {/foreach}
      {/if}
    {if $user->cat_username}
      {if $paymentFinesChanged}
        <div class="webpaymentMessage error">{translate text="webpayment_fines_changed"}</div>
      {elseif $paymentNotPermittedInfo}
        <div class="webpaymentMessage error">{$paymentNotPermittedInfo} {if $paymentNotPermittedMinimumFee}{$minimumFee|safe_money_format|replace:"Eu":" €"|escape}{/if}</div>
      {elseif $registerPayment}
          {if $registerPayment}
            <span class="ajax_register_payment hide" id="webpaymentStatusSpinner">{translate text="Registering Payment"}</span>
          {/if}
          <div id="webpaymentStatus" class="info hide">
          </div>
      {/if}

      <h2>{translate text='Your Fines'}: 
      {foreach from=$catalogAccounts item=account}
        {if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
      {/foreach} 
      {if !empty($accountname)}({/if}{assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''}{translate text=$source prefix='source_'}{if !empty($accountname)}){/if}
      </h2>
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
        <tr><td colspan="5" class="fineBalance">{translate text='Balance total'}: <span class="hefty">{$sum|safe_money_format|replace:"Eu":" €"|escape}</span></td></tr>
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
            <td class="fineTitle">
          {if is_array($record.format)}
          {assign var=mainFormat value=$record.format.0} 
          {assign var=displayFormat value=$record.format|@end} 
          {else}
          {assign var=mainFormat value=$record.format} 
          {assign var=displayFormat value=$record.format} 
          {/if}
          <span class="icon format{$mainFormat|lower|regex_replace:"/[^a-z0-9]/":""} format{$displayFormat|lower|regex_replace:"/[^a-z0-9]/":""}" title="{translate text=$displayFormat prefix='format_'}">{*translate text=format_$displayFormat*}</span>
             {if $record.id}
	         <a href="{$url}/Record/{$record.id|escape}">
	         {/if}
             {$record.title|trim:'/:'|escape}
             {if $record.id}
             </a>              
             {/if}
            </td>
            <td>{$record.checkout|escape}</td>
            <td>{$record.duedate|escape}</td>
            <td class="fine">{translate text=$record.fine|escape prefix="status_"}</td>
            <td class="fineAmount" style="text-align:right;">
              {if $webpaymentEnabled && !$record.payableOnline}<span class="webpaymentNonpayableAmount">{/if}
              {$record.balance/100.00|safe_money_format|replace:"Eu":" €"|escape}
              {if $webpaymentEnabled && !$record.payableOnline}</span><div class="webpaymentRemark">{translate text='webpayment_nonpayable_fee'}</div>{/if}
            </td>
          </tr>
        {/foreach}
          <tr><td colspan="5" class="fineBalance">
            {if $webpaymentEnabled}          
             {if $paymentBlocked}
                <div class="webpaymentRemark">{$paymentNotPermittedInfo} {if $paymentNotPermittedMinimumFee}{$minimumFee|safe_money_format|replace:"Eu":" €"|escape}{/if}</div>
             {else}
               {translate text='webpayment_payable_online'}: <span class="hefty">{$payableSum|safe_money_format|replace:"Eu":" €"|escape}</span>
               {if $transactionFee}
                  <div class="webpaymentRemark" id="transactionFee">
                    {translate text='webpayment_transaction_fee'}: <span class="hefty">{$transactionFee|safe_money_format|replace:"Eu":" €"|escape}</span>
                  </div>
               {/if}
               <div>
               {assign var=amountFormatted value=$payableSum+$transactionFee|safe_money_format|replace:"Eu":" €"|escape}
               {include file=$webpaymentForm paymentAmountFormatted=$amountFormatted}
             </div>
            {/if}
         {else}
           {translate text='Balance total'}: <span class="hefty">{$sum|safe_money_format|replace:"Eu":" €"|escape}</span
         {/if}
        </td></tr>
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
