<!-- START of: RecordDrivers/Index/result-browse.tpl -->
<div class="recordId" id="record{$summId|escape}">
  <div class="grid_8 snippet">
    <p class="title recordTitle">
        <div class="grid_7b">
          <a class="toggle" href="#">
            <div class="icon"></div>            
            <h4>{if !empty($summHighlightedTitle)}{$summHighlightedTitle|addEllipsis:$summTitle|highlight}{elseif !$summTitle}{translate text='Title not available'}{else}{$summTitle|truncate:180:"..."|escape}{/if}</h4>
          </a>

          {if $showSavedLists}
          <div class="savedLists info hide" id="savedLists{$summId|escape}">
            <strong>{translate text="Saved in"}:</strong>
          </div>
          {/if}
          
        </div>
    </p>    
  </div>

  {include file="$snippet"}
  
  <div class="clear"></div>
  
  <div class="moreinfo">
    {include file="$more"}
  </div>

  <div class="clear"></div>
</div>
<!-- END of: RecordDrivers/Index/result-browse.tpl -->
