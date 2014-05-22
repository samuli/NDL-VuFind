{translate text="due_date_email_prefix"} {$loans|@count} {if $loanCount == 1}{translate text="due_date_email_suffix_singular"}{else}{translate text="due_date_email_suffix"}{/if}


{foreach from=$loans item=loan}
{$loan.title}
{translate text='Due Date'}: {$loan.dueDateFormatted}

{/foreach}

{translate text="due_date_email_link_title"}
{$url}/MyResearch/CheckedOut

{translate text="Unsubscribe description"}: 
{$unsubscribeUrl}



