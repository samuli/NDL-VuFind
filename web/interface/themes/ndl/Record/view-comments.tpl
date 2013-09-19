<!-- START of: Record/view-comments.tpl -->

<div class="content">
<div class="grid_24">
<ul class="commentList" id="commentList{$id|escape}">
{* Pull in comments from a separate file -- this separation allows the same template
   to be used for refreshing this list via AJAX. *}
{include file="Record/view-comments-list.tpl"}
</ul>
<form name="commentRecord" id="commentRecord" action="{$url}/Record/{$id|escape:"url"}/UserComments" method="post">
  {translate text='Rating by stars'}: <div id="starRating"></div>
  <input type="hidden" name="id" value="{$id|escape}"/>
  <input type="hidden" name="type" value="{if $ratingsDisabled}0{else}1{/if}"/>
  <input type="hidden" name="commentId" id="commentId" value="0" />
  <textarea id="comment" name="comment" rows="4" cols="50" class="{jquery_validation required='This field is required'}"></textarea>
  <br/><br/>
  <input type="submit" class="button buttonFinna" value="{if $ratingsDisabled}{translate text='Add your comment'}{else}{translate text='Add your rating'}{/if}"/>
  <input type="reset" class="button buttonFinna" value="{translate text='Reset'}"/>  
</form>
</div>
</div>
<!-- END of: Record/view-comments.tpl -->
{js filename="raty/jquery.raty.min.js"}
{literal}
<script type="text/javascript">
var baseUrl = "{/literal}{$url}{literal}";
var icons = {starHalf    : baseUrl+'/interface/themes/ndl/images/raty/star-half.png',
             starOff     : baseUrl+'/interface/themes/ndl/images/raty/star-off.png',
             starOn      : baseUrl+'/interface/themes/ndl/images/raty/star-on.png'
            };
            
$(document).ready(function() {
    $('#starRating').raty($.extend(icons, {half : true, scoreName : 'rating'}));
    
    $.each($('.starRatingReadOnly'), function() {
        $(this).raty($.extend(icons, {readOnly : true, half: true, score : $(this).attr('data-score')}));
    });
    // attach click event to the report inappropriate link
    $('a.inappropriateRecordComment').unbind('click').live('click', function(e) {
        var id = this.id.substr('inappropriateComment'.length);
        var $dialog = getPageInLightbox(this.href+'&lightbox=1', this.title, 'Record', 'inappropriate', id);
        e.preventDefault();
    });
});
</script>
{/literal}