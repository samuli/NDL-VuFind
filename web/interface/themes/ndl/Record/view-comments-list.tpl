<!-- START of: Record/view-comments-list.tpl -->

{foreach from=$commentList item=comment}
  <li>
    <div class="posted">
      {if $comment->rating && !$ratingsDisabled}<div id="raty_{$comment->id}" class="starRatingReadOnly" data-score="{$comment->rating}"></div>{/if}
       <strong>{if $comment->fullname}{$comment->fullname|escape:"html"}{else}{$comment->username|strstr:'@':true|escape:"html"}{/if}</strong>
      {$comment->created|escape:"html"}
      {if $comment->user_id == $user->id}
        <a href="{$url}/Record/{$id|escape:"url"}/UserComments?edit={$comment->id}" id="recordCommentEdit{$comment->id|escape}" class="edit tool editRecordComment">{translate text='Edit'}</a>
        <a href="{$url}/Record/{$id|escape:"url"}/UserComments?delete={$comment->id}" id="recordComment{$comment->id|escape}" class="delete tool deleteRecordComment">{translate text='Delete'}</a>
      {/if}
    </div>
    <div id="comment{$comment->id}" class="comment">{$comment->comment|escape:"html"}</div><br>
    {if not $comment->id|in_array:$reported}
    <a href="{$url}/Record/{$id|escape:"url"}/UserComments?inappropriate={$comment->id}" title="{translate text="Report inappropriate comment"}" id="inappropriateComment{$comment->id|escape}" class="inappropriate tool inappropriateRecordComment">{translate text='Report inappropriate'}</a>
    {/if}
  </li>

{foreachelse}
  <li id="emptyListItem">{translate text='Be the first to leave a comment'}</li>
{/foreach}
<!-- END of: Record/view-comments-list.tpl -->
