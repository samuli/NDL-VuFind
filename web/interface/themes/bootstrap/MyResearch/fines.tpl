<!-- START of: MyResearch/fines.tpl -->

{include file="MyResearch/menu.tpl"}

<div class="well-small myResearch finesList{if $sidebarOnLeft} last{/if}">
  <span class="lead">{translate text='Your Fines'}</span>
  {if $user->cat_username}
  <div class="resultHead"></div>
    {if empty($rawFinesData)}
      <p class="alert alert-info">{translate text='You do not have any fines'}</p>
    {else}
      <table class="table table-hover datagrid fines" summary="{translate text='Your Fines'}">
      <tr class="well">
        <th {*style="width:50%;"*}>{translate text='Title'}</th>
        <th>{translate text='Checked Out'}</th>
        <th>{translate text='Due Date'}</th>
        <th class="hidden-phone">{translate text='Fine'}</th>
        {* <th>{translate text='Fee'}</th> *}
        <th>{translate text='Balance'}</th>
      </tr>
      {foreach from=$rawFinesData item=record}
        <tr{if $record.fine == "Long Overdue"} class="warning"{/if}>
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
          <td>{$record.duedate|escape}{if $record.checkedOut} <span class="highlight">{translate text="fined_work_still_on_loan"}</span>{/if}</td>
          <td class="hidden-phone">{$record.fine|escape}</td>
          {* <td>{$record.amount/100.00|safe_money_format|escape}</td> *}
          <td style="text-align:right;">{$record.balance/100.00|safe_money_format|replace:"Eu":" €"|escape}</td>
        </tr>
      {/foreach}
      <tr{if $sum > 0} class="error"{/if}><td colspan="5" class="fineBalance" style="text-align: right;">{translate text='Balance total'}: &nbsp;<span class="lead">{$sum/100.00|safe_money_format|replace:"Eu":" €"|escape}</span></td></tr>
      </table>
    {/if}
  {else}
    {include file="MyResearch/catalog-login.tpl"}
  {/if}
</div>
<div class="clearfix"></div>

<!-- END of: MyResearch/fines.tpl -->
