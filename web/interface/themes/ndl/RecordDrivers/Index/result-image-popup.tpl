<div class="imagePopupHolder {$recordType}">
  <div class="imagePopupContainer">
  <div class="image">
    <span class="loading">{translate text="Loading"}</span>
    <span class="noimage">{translate text="No Image"}</span>    
    {if $thumbLarge}
    <img src="{$thumbLarge}" />
    {elseif $img}

    {/if}
  </div>
  <div class="content">
    <h3 class="title">{$title}</h3>
    <div class="authorAndDates">
      <p>
      {if $author}{$author}{/if}
      {foreach from=$dates item=item}
      	{$item} 
      {/foreach}
      </p>      
    </div>
    {if $building}<div class="building">{$building}</div>{/if}
    <div class="summary">
      {if $recordType == 'marc'}
      <div>
      <img src="{path filename="images/ajax_loading.gif"}" alt="{translate text='Loading data...'}"/>
        <script type="text/javascript">
        //<![CDATA[
        var path = {$path|@json_encode};
        var id = {$id|@json_encode};
        
        {literal}
        $(document).ready(function() {          
          $(".imagePopupHolder .summary > div").load(path + '/AJAX/AJAX_Description?id=' + id, function(response, status, xhr) {
            if (response.length != 0) {
              resizeImagePopupContent();
            }
          })
        });
        {/literal}
        //]]>
        </script>
      </div>
      {elseif $summary}
      {foreach from=$summary item=item}
      <p>{$item}</p>
      {/foreach}
      {/if}
    </div>
    <div class="listNotes">
      <p><span class="heading">{translate text="Description"}</span><span class="notes-user"></span>:</p>
      <p class="text">{$listNotes}</p>      
    </div>
    <div class="recordLink"><a href="{$url}">{translate text="To the record"}</a></div>
    <div class="imageRights">
      <div class="rights">
        <span>{translate text="Image Rights"}:</span> <a target="_blank" href="{$copyrightLink}">{$copyright}</a>
      </div>
      {if $copyrightDescription}
      <div class="moreLink copyrightLink"><a data-mode="1" href="">Lisää</a></div>
      <div class="copyright">
        {foreach from=$copyrightDescription item=item}
        <p>{$item}</p>
        {/foreach}
        {if $copyrightLink && !$copyright}
        <a href="{$copyrightLink}">{translate text="See also"}</a>
        {/if}
      </div>
      <div class="lessLink copyrightLink"><a data-mode="0" href="">vähemmän</a></div>
      {/if}
    </div>
    <div style="clear: both;"></div>
</div>

  <div style="clear: both;"></div>
</div>
</div>