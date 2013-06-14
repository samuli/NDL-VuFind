<!-- START of: Search/Recommend/TopPubDateVisAjax.tpl -->

{if $visFacets}

    {* load jQuery flot *}
    <!--[if IE]>{js filename="flot/excanvas.min.js"}<![endif]--> 
    {js filename="flot/jquery.flot.js"}
    {js filename="flot/jquery.flot.selection.js"}
    {js filename="pubdate_vis.js"}
    <a class="toggleDateVis {if !empty($visFacets.main_date_str[0])}hidden{/if}">{translate text='Results timeline'}</a>
    {foreach from=$visFacets item=facetRange key=facetField}
      <div id="topPubDateVis" class="span12 last {if !empty($visFacets.main_date_str[0])}active{/if}">
        {* $facetRange.label *}
        <strong>{translate text=$facetRange.label}</strong>
        {* space the flot visualisation *}     
        <div id="datevis{$facetField}x" style="margin:0;padding:0;width:auto;height:80px;cursor:crosshair;position:relative;left:-3px;"></div>
        <div id="clearButtonText" style="display: none">{translate text="Clear"}</div>  
      </div>
    {/foreach}
    <script type="text/javascript">
      //<![CDATA[
      {literal} 
        function printVis() { 
            if ($('#topPubDateVis').is('.active')) {
                {/literal}
                loadVis('{$facetFields|escape:'javascript'}', '{$searchParams|escape:'javascript'}', '{$url}', {$zooming}{if $collectionName}, '{$collectionID|urlencode}', '{$collectionAction}'{/if});
                {literal} 
            }  
        }
        
        printVis();
          
        // Redraw visualizer on screen resize
        $(window).resize(function(){
          delay(function(){
            printVis();
          }, 250);
        });
        
        // Delay function to execute printVis only with the last call during resize
        var delay = (function(){
          var timer = 0;
          return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
          };
        })();
        
        // Toggle date visualizer visibility
        $('.toggleDateVis').click(function() {
            $('#topPubDateVis').addClass('active');
            printVis();
            $(this).hide();
        });
      {/literal}
      //]]>
    </script>

{/if}

<!-- END of: Search/Recommend/TopPubDateVisAjax.tpl -->
