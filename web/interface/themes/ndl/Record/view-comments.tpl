<!-- START of: Record/view-comments.tpl -->
<div id="commentsContainer">
<div class="content">
<div class="grid_24">
<ul class="commentList" id="commentList{$id|escape}">
{include file="Record/view-comments-list.tpl"}
</ul>
{if $user}
<form name="commentRecord" id="commentRecord" action="{$url}/Record/{$id|escape:"url"}/UserComments" method="post">
  <input type="hidden" name="recordId" value="{$id|escape}"/>
  <input type="hidden" name="commentId" value="0"/>
  <input type="hidden" name="type" value="{if $ratings}1{else}0{/if}"/>
  <div id="formContainer"{if $ratings && $commentedByUser} style="display:none"{/if}>
  {if $ratings}{translate text='Rating by stars'}: <div id="starRating"></div>{/if}
  <textarea id="comment" name="comment" rows="4" cols="50" class="{jquery_validation required='This field is required'}"></textarea>
  <br/><br/>
  <input type="submit" class="button buttonFinna" value="{if $ratings}{translate text='Add your rating'}{else}{translate text='Add your comment'}{/if}"/>
  <input type="reset" class="button buttonFinna" value="{translate text='Reset'}"/>  
  </div>
</form>
{else}
<div class="userMsg">
  <a href="{$path}/MyResearch/Home?followup=true&followupModule=Record&followupAction={$id}{'#commentstab'|escape:'url'}">{translate text="Login"}</a> {if $ratings}{translate text='rating_login'}{else}{translate text='comment_login'}{/if}
</div>
{/if}
</div>
</div>
<!-- END of: Record/view-comments.tpl -->
{literal}
<script type="text/javascript">
$(document).ready(function() {
    var icons = {starHalf    : path+'/interface/themes/ndl/images/raty/star-half.png',
                 starOff     : path+'/interface/themes/ndl/images/raty/star-off.png',
                 starOn      : path+'/interface/themes/ndl/images/raty/star-on.png'
                };
    {/literal}{if $ratings}{literal}
    $('#starRating').raty($.extend(icons, {half : true, scoreName : 'rating'}));
    $.each($('.starRatingReadOnly'), function() {
        $(this).raty($.extend(icons, {readOnly : true, half: true, score : $(this).attr('data-score')}));
    });
    {/literal}{/if}{literal}
});
</script>
{/literal}
</div>