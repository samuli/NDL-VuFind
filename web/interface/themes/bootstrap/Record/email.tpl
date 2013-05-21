<!-- START of: Record/email.tpl -->

{if $errorMsg}<div class="alert alert-error">{$errorMsg|translate}</div>{/if}
{if $infoMsg}<div class="alert alert-info">{$infoMsg|translate}</div>{/if}

<form action="{$url}{$formTargetPath|escape}" method="post" name="emailRecord" style="margin-bottom: 10px;">
    <input type="hidden" name="id" value="{$id|escape}" />
    <input type="hidden" name="type" value="{$module|escape}" />
    <label class="displayBlock" for="email_to"><strong>{translate text='To'}:</strong></label>
    <input id="email_to" type="text" name="to" class="span3 mainFocus {jquery_validation required='This field is required' email='Email address is invalid'}"/>
    <label class="displayBlock" for="email_from"><strong>{translate text='Email From'}:</strong></label>
    <input id="email_from" type="text" name="from" class="span3 {jquery_validation required='This field is required' email='Email address is invalid'}"{if $user->email} value="{$user->email}"{/if}/>
    <label class="displayBlock" for="email_message"><strong>{translate text='Message'}:</atrong></label>
    <textarea class="span3" id="email_message" name="message" rows="3"></textarea>
    <br/>
    <input class="btn btn-info" type="submit" name="submit" value="{translate text='Send'}"/>
</form>

<!-- END of: Record/email.tpl -->
