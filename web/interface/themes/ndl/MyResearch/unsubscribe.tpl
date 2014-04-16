<div class="content unsubscribe">
  <br>
  {if $success == true}
    {translate text="unsubscribe_successful"}
  {else}
  <p>{translate text="unsubscribe_confirmation"}</p><br> <a class="button buttonFinna" href="{$unsubscribeUrl|escape}">{translate text='Yes'}</a> <a class="button buttonFinna" href="{$url}">{translate text='No'}</a>
  {/if}
</div>