{if !empty($paidFines)}
  {assign var=no_title value='not_applicable'}
  {assign var=no_title value=$no_title|translate}
  <table class="onlinePaymentSummary">
  {foreach from=$paidFines item=fine}
    <tr>
      <td style="width: 50%">{if (empty($fine.title) || $fine.title==$no_title) && !empty($fine.fine)}{$fine.fine|escape}{else}{$fine.title|trim:'/:'|escape}{/if}</td>
      <td class="onlinePaymentSummaryAmount">{translate text="online_payment_paid"}&nbsp;{$fine.amount/100.00|safe_money_format|replace:"Eu":" €"|escape}</td>
    </tr>
  {/foreach}
  </table>
{/if}
