<!-- START of: Record/view-comments-list.tpl -->

{foreach from=$commentList item=comment}
  <li>
    <div class="posted">
      {if $comment->rating && $ratings}<div id="raty_{$comment->id}" class="starRatingReadOnly" data-score="{$comment->rating}"></div>{/if}
       <div class="commentDetails">
           <strong>{if $comment->fullname}{$comment->fullname|escape:"html"}{else}{$comment->email|strstr:'@':true|replace:':':''|escape:"html"}{/if}</strong>
      {$comment->created|escape:"html"}
      {if $comment->user_id == $user->id}
        <a href="{$url}/Record/{$id|escape:"url"}/UserComments?edit={$comment->id}" id="recordCommentEdit{$comment->id|escape}" class="editRecordComment">{translate text='Edit'}</a>
        <a href="{$url}/Record/{$id|escape:"url"}/UserComments?delete={$comment->id}" id="recordComment{$comment->id|escape}" class="deleteRecordComment">{translate text='Delete'}</a>
      {/if}
      </div>
    </div>
    <div id="comment{$comment->id}" class="comment">{$comment->comment|escape:"html"}</div><br>
    {if not $comment->id|in_array:$reported}
    <a href="{$url}/Record/{$id|escape:"url"}/UserComments?inappropriate={$comment->id}" title="{translate text="Report inappropriate comment"}" id="inappropriateComment{$comment->id|escape}" class="inappropriate tool inappropriateRecordComment">{translate text='Report inappropriate'}</a>
    {/if}
  </li>

{foreachelse}
  <li id="emptyListItem">{if $ratings}{translate text='Be the first to leave a rating'}{else}{translate text='Be the first to leave a comment'}{/if}</li>
{/foreach}
<!-- END of: Record/view-comments-list.tpl -->
