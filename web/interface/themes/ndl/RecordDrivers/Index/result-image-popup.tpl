<div class="imagePopupHolder">
  <div class="image">
    <img src="{$img}" />
  </div>

  <div class="content">
    <h3 class="title">{$title}</h3>
    <div class="authorAndDates">
      {if $author}<p>{$author}</p>{/if}
      {foreach from=$dates item=item}
      <p>{$item}</p>
      {/foreach}      
    </div>
    {if $building}<div class="building">{$building}</div>{/if}
    {if $summary}
    <div class="summary">
      <h3>{translate text="Description"}</h3>
      {foreach from=$summary item=item}
      <p>{$item}</p>
      {/foreach}      
    </div>
    {/if}
    <div class="listNotes">
      <p class="heading">{translate text="Description"}:</p>
      <p class="text">{$listNotes}</p>      
    </div>    
    <div class="recordLink"><a href="{$url}">{translate text="To the record"}</a></div>
    <div class="imageRights">
      <div class="rights">
        <span>{translate text="Image Rights"}:</span> <a target="_blank" href="{$copyrightLink}">{$copyright}</a>
      </div>
      {if $copyrightDescription}
      <div class="moreLink copyrightLink"><a data-mode="1" href="#">Lisää</a></div>
      <div class="copyright">
        {foreach from=$copyrightDescription item=item}
        <p>{$item}</p>
        {/foreach}
        {if $copyrightLink && !$copyright}
        <a href="{$copyrightLink}">{translate text="See also"}</a>
        {/if}
      </div>
      <div class="lessLink copyrightLink"><a data-mode="0" href="#">vähemmän</a></div>
      {/if}
    </div>
  </div>

  <div style="clear: both;"></div>

</div>