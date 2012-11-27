<!-- START of: Record/feedback.tpl -->

{if $errorMsg}<div class="error">{$errorMsg|translate}</div>{/if}
{if $infoMsg}<div class="info">{$infoMsg|translate}</div>{/if}

<form action="{$url}{$formTargetPath|escape}" method="post"  name="feedbackRecord">
    <input type="hidden" name="id" value="{$id|escape}" />
    <input type="hidden" name="type" value="{$module|escape}" />
    <label class="displayBlock" for="feedback_to">{translate text='To'}: {translate text=facet_$institution} / {translate text=$datasource prefix='source_'}</label>
    <label class="displayBlock" for="feedback_from">{translate text='Email From'}:</label>
    <input id="feedback_from" type="text" name="from" size="40" class="{jquery_validation required='This field is required' email='Email address is invalid'}"{if $user->email} value="{$user->email}"{/if}/>
    <label class="displayBlock" for="feedback_message">{translate text='Message'}:</label>
    <textarea id="feedback_message" name="message" rows="3" cols="40"></textarea>
    <br/>
    <input class="button" type="submit" name="submit" value="{translate text='Send'}"/>
</form>

<!-- END of: Record/feedback.tpl -->
