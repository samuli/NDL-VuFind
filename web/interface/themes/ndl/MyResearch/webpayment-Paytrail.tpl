{assign var=goToPaymentText value='webpayment_go_to_pay'}
{assign var=goToPaymentText value=$goToPaymentText|translate}
{assign var=paymentText value="$goToPaymentText $amountFormatted"}

<form id="paytrail_form" class="webpaymentForm" action="{$url}/MyResearch/Fines" method="post">
  <img src="{$path}/images/paytrail-logo-200x200.png" id="paytrail-logo"/>
  <input name="sessionId" type="hidden" value="{$transactionSessionId}">
  <input name="pay" type="hidden" value="1">
  <input type="submit" name="pay" class="button buttonFinna" value="{$paymentText|escape:"html"}" />
</form>