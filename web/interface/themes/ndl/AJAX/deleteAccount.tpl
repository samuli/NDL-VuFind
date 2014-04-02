<!-- START of: AJAX/deleteAccount.tpl -->

<form name="deleteAccount">
  <h3>{translate text="delete_account_heading"}</h3>
  <p>{translate text="delete_account_text"}</p>

  <input type="hidden" id="token" value="{$token}" />
  <input class="button" type="reset" name="reset" value="{translate text='confirm_dialog_no'}"/>
  <input id="deleteAccountButton" class="button" type="submit" name="submit" value="{translate text='Delete'}"/>
</form>

<div id="deleteAccountNote" class="success">{translate text="delete_account_success"}</div>

<!-- END of: AJAX/deleteAccount.tpl -->