<!-- START of: MyResearch/fines.tpl -->
{if $registerPayment}
{js filename="online-payment.js"}
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
        <div class="error">{translate text="online_payment_fines_changed"}</div>
      {elseif $paymentNotPermittedInfo}
        <div class="error">{$paymentNotPermittedInfo|translate} {if $paymentNotPermittedMinimumFee}{$minimumFee/100.00|safe_money_format|replace:"Eu":" €"|escape}{/if}</div>
      {elseif $registerPayment}
          <span class="ajax_register_payment hide" id="onlinePaymentStatusSpinner">{translate text="Registering Payment"}</span>
          <div id="onlinePaymentStatus" class="info hide">
          </div>
      {elseif $paymentOk}
          <div class="info">{translate text='online_payment_successful'}</div>          
      {/if}

      <h2>{translate text='Your Fines'}: 
      {foreach from=$catalogAccounts item=account}
        {if $account.cat_username == $currentCatalogAccount}{$account.account_name|escape}{assign var=accountname value=$account.account_name|escape}{/if}
      {/foreach} 
      {assign var=source value=$user->cat_username|regex_replace:'/\..*?$/':''|translate_prefix:'source_'}
      {if $source != $accountname}
        {if !empty($accountname)}({/if}{$source}{if !empty($accountname)}){/if}</h2>
      {/if}
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
            <td class="fineTitle">
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
               {if $record.id}
               <a href="{$url}/Record/{$record.id|escape}">
               {/if}
               {$record.title|trim:'/:'|escape}
               {if $record.id}
               </a>              
               {/if}
            {/if}
            </td>
            <td>{$record.checkout|escape}</td>
            <td>{$record.duedate|escape}</td>
            <td class="fine">
              {if $record.institution_name}
                {translate text=$record.institution_name prefix='library_'}<br/>
              {/if}
              {translate text=$record.fine|escape prefix="status_"}
            </td>
            <td class="fineAmount" style="text-align:right;">
              {if $onlinePaymentEnabled && !$record.payableOnline}<span class="onlinePaymentNonpayableAmount">{/if}
              {$record.balance/100.00|safe_money_format|replace:"Eu":" €"|escape}
              {if $onlinePaymentEnabled && !$record.payableOnline}</span><div class="onlinePaymentRemark">{translate text='online_payment_nonpayable_fees'}</div>{/if}
            </td>
          </tr>
        {/foreach}
          <tr><td colspan="5" class="fineBalance">
          <div class="fineTotal">{translate text='Balance total'}: <span class="hefty">{$sum/100.00|safe_money_format|replace:"Eu":" €"|escape}</span></div>
          {if $onlinePaymentEnabled}          
             {if $paymentBlocked}
                <div class="onlinePaymentRemark">{$paymentNotPermittedInfo|translate} {if $paymentNotPermittedMinimumFee}{$minimumFee/100.00|safe_money_format|replace:"Eu":" €"|escape}{/if}</div>
             {else}
                {translate text='online_payment_payable_online'}: <span class="hefty">{$payableSum/100.00|safe_money_format|replace:"Eu":" €"|escape}</span>
                {if $transactionFee}
                <div class="onlinePaymentRemark" id="transactionFee">
                  {translate text='online_payment_transaction_fee'}: <span class="hefty">{$transactionFee/100.00|safe_money_format|replace:"Eu":" €"|escape}</span>
                </div>
                {/if}

               <div>
                  {assign var=amountFormatted value=$payableSum+$transactionFee}
                  {assign var=amountFormatted value=$amountFormatted/100.00|safe_money_format|replace:"Eu":" €"|escape}
                  {if $onlinePaymentForm}{include file=$onlinePaymentForm paymentAmountFormatted=$amountFormatted}{/if}
               </div>
             {/if}
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
