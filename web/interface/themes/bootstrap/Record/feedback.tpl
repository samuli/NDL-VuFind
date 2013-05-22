<!-- START of: Record/feedback.tpl -->

{if $errorMsg}<div class="alert alert-error">{$errorMsg|translate}</div>{/if}
{if $infoMsg}<div class="alert alert-info">{$infoMsg|translate}</div>{/if}

<form action="{$url}{$formTargetPath|escape}" method="post"  name="feedbackRecord">
    <input type="hidden" name="id" value="{$id|escape}" />
    <input type="hidden" name="type" value="{$module|escape}" />
    {assign var=sourceTranslated value=$datasource|translate_prefix:'source_'}
    {assign var=institutionTranslated value=$institution|translate_prefix:'facet_'}
    <label class="displayBlock" for="feedback_to"><strong>{translate text='To'}:</strong> {$institutionTranslated}{if $sourceTranslated != $institutionTranslated} / {$sourceTranslated}{/if}</label>
    <label class="displayBlock" for="feedback_from"><strong>{translate text='Email From'}:</strong></label>
    <input id="feedback_from" type="text" name="from" class="span3 {jquery_validation required='This field is required' email='Email address is invalid'}"{if $user->email} value="{$user->email}"{/if}/>
    <label class="displayBlock" for="feedback_message"><strong>{translate text='Message'}:</strong></label>
    <textarea id="feedback_message" class="span3" name="message" rows="3"></textarea>
    <br/>
    <input class="btn btn-info" type="submit" name="submit" value="{translate text='Send'}"/>
</form>

<!-- END of: Record/feedback.tpl -->
