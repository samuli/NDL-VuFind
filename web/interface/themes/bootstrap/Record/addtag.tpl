<!-- START of: Record/addtag.tpl -->

<form action="{$url}/Record/{$id|escape}/AddTag" method="post" name="tagRecord">
  <input type="hidden" name="submit" value="1" />
  <input type="hidden" name="id" value="{$id|escape}" />
  <label class="label" for="addtag_tag">{translate text="Tags"}:</label>
  <input id="addtag_tag" type="text" name="tag" value="" class="span4 mainFocus {jquery_validation required='This field is required'}"/>
  <p>{translate text="add_tag_note"}</p>
  <input class="btn btn-info" type="submit" value="{translate text='Add'}"/>
</form>

<!-- END of: Record/addtag.tpl -->
