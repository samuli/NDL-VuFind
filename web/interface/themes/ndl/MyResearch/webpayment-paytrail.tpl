{assign var=goToPaymentText value='webpayment_go_to_pay'}
{assign var=goToPaymentText value=$goToPaymentText|translate}
{assign var=paymentText value="$goToPaymentText $amountFormatted"}
<form id="paytrail_form" class="webpaymentForm" action="{$action_url|escape:"html"}" method="post">
    <img src="{$path}/images/paytrail-logo-200x200.png" id="paytrail-logo"/>
    <input name="MERCHANT_ID" type="hidden" value="{$merchant_id|escape:"html"}">
    <input name="AMOUNT" type="hidden" id="webpaymentAmount" value="{$paymentAmount|escape:"html"}">
    <input name="ORDER_NUMBER" type="hidden" id="webpaymentTransactionId" value="{$order_no|escape:"html"}">
    <input name="CURRENCY" type="hidden" value="{$currency|escape:"html"}">
    <input name="RETURN_ADDRESS" type="hidden" value="{$return_url|escape:"html"}">
    <input name="CANCEL_ADDRESS" type="hidden" value="{$cancel_url|escape:"html"}">
    <input name="NOTIFY_ADDRESS" type="hidden" value="{$notify_url|escape:"html"}">
    <input name="TYPE" type="hidden" value="{$interface_type|escape:"html"}">
    <input name="AUTHCODE" type="hidden" value="{$authcode|escape:"html"}">
    <input type="submit" name="pay" class="button buttonFinna" value="{$paymentText|escape:"html"}" />
    <!-- non-Paytrail-related fields -->
    <input name="webpaymentTransactionFee" type="hidden" id="webpaymentTransactionFee" value="{$transactionFee|escape:"html"}">
    {foreach from=$rawFinesData item=record name=fines}
      {if empty($record.title)}
        <input type="hidden" id="webpaymentFeeTitle{$smarty.foreach.fines.index}" value="{translate text='not_applicable'}" />
      {else}
        <input type="hidden" id="webpaymentFeeTitle{$smarty.foreach.fines.index}" value="{$record.title|escape:"html"}" />
      {/if}
      <input type="hidden" id="webpaymentFeeType{$smarty.foreach.fines.index}" class="webpaymentTransactionFine" value="{$record.fine|escape:"html"}" />
      <input type="hidden" id="webpaymentFeeBalance{$smarty.foreach.fines.index}" value="{$record.balance/100.00|escape:"html"}" />
      <input type="hidden" id="webpaymentFeeCurrency{$smarty.foreach.fines.index}" value="EUR" />
    {/foreach}
</form>
