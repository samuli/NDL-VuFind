<!-- START of: Feedback/report-inappropriate.tpl -->
<div class="content">
<div class="grid_24">
{if not $submitted}
{if $errorMsg}<p class="error">{$errorMsg}</p>{/if}
<form id="inappropriateForm" action="" method="post" name="inappropriateComment">
    <input type="hidden" name="recordId" value="{$id}"></input>
    <input type="hidden" name="commentId" value="{$commentId}"></input>
    <label>{translate text='Choose'}:</label>
    <label for="inapp1"><input id="inapp1" type="radio" name="reason" checked="checked" value="{translate text='inappropriate_reason_1'}" /> {translate text='inappropriate_reason_1'}</label>
    <label for="inapp2"><input id="inapp2" type="radio" name="reason" value="{translate text='inappropriate_reason_2'}" /> {translate text='inappropriate_reason_2'}</label>
    <label for="inapp3"><input id="inapp3" type="radio" name="reason" value="{translate text='inappropriate_reason_3'}" /> {translate text='inappropriate_reason_3'}</label>
    <label for="inapp4"><input id="inapp4" type="radio" name="reason" value="{translate text='inappropriate_reason_4'}" /> {translate text='inappropriate_reason_4'}</label>
    <label for="inapp5"><input id="inapp5" type="radio" name="reason" value="{translate text='inappropriate_reason_5'}" /> {translate text='inappropriate_reason_5'}</label>
    <input type="submit" id="submit" name="submit" class="button buttonFinna" value="{translate text='Send'}" />
</form>
{else}
<p>{translate text="inappropriate_thankyou"}</p>
{/if}
</div>
</div>
{literal}
<script type="text/javascript">
    $(function() {
        registerAjaxInappropriateComment();
    });
</script
{/literal}
<!-- END of: Feedback/reportinappropriate.tpl -->
