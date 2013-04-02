{assign var=status value="status_unknown_message"|translate}
{if $status}
<span class="unknown">{translate text="status_unknown_message"}</span>
{/if}