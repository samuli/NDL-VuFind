{assign var=goToPaymentText value='online_payment_go_to_pay'}
{assign var=goToPaymentText value=$goToPaymentText|translate}
{assign var=paymentText value="$goToPaymentText $amountFormatted"}

<form id="paytrail_form" class="onlinePaymentForm" action="{$url}/MyResearch/Fines" method="post">
  {image src="paytrail-logo.png" id="paytrail-logo" alt="Paytrail"}
  <input name="sessionId" type="hidden" value="{$transactionSessionId}">
  <input name="pay" type="hidden" value="1">
  <input type="submit" name="pay" class="button buttonFinna" value="{$paymentText|escape:"html"}" />
</form>
