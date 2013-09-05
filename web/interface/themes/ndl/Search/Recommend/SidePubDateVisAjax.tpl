<!-- START of: Search/Recommend/SidePubDateVisAjax.tpl -->

{if $visFacets}
  <div class="resultDates">
    <div class="content">
        <div class="mainYearFormContainer2"></div>
        {* load jQuery flot *}
        <!--[if IE]>{js filename="flot/excanvas.min.js"}<![endif]--> 
        {js filename="flot/jquery.flot.js"}
        {js filename="flot/jquery.flot.selection.js"}
        {js filename="pubdate_vis.js"}

        {foreach from=$visFacets item=facetRange key=facetField}
          <div id="sidePubDateVis" class="{if $facetRange.label == "adv_search_year"}span-10{if $sidebarOnLeft} last{/if}{/if}">
              <div class="dateVisNavigation">
                  <div class="zoomIn"></div>
                  <div class="zoomOut"></div>
                  <div class="prev"></div>
                  <div class="next"></div>
              </div>
              <div class="dateVis"></div>
          </div>
        {/foreach}
        
        <script type="text/javascript">
          //<![CDATA[
          {literal} 
          
          // Prepare the visualizer
          function loadVisNow(action) { 
            $('.dateVis').addClass('loading');
              
            // Navigation: prev, next, out or in
            if (typeof action != 'undefined') {
              visDateStart = ($('#mainYearFromRange').val() != '') ? parseInt($('#mainYearFromRange').val(),10) : 0;
              visDateEnd = ($('#mainYearToRange').val() != '') ? parseInt($('#mainYearToRange').val(),10) : dateVisYearLimit;
                  
              // Require numerical values
              if (!isNaN(visDateStart) && !isNaN(visDateEnd)) {
                visMove = Math.ceil((visDateEnd - visDateStart) * .2);
                if (visMove < 1) visMove = 1; // Require >= 1 year movements

                // Changing the dates using the moveVis function above
                if (action == 'prev') {
                  moveVis('-','-');
                } else if (action == 'next') {
                  moveVis('+','+');
                } else if (action == 'zoomOut') {
                  moveVis('-','+');
                } else if (action == 'zoomIn') {

                  // Only allow zooming in if years differ
                  if (visDateStart != visDateEnd) {
                    moveVis('+','-');
                  }
                }

                // Make sure start <= end
                if (visDateStart > visDateEnd) {
                    visDateStart = visDateEnd;
                }

                // Create the string of date params
                visNavigation = '&filter%5B%5D=main_date_str%3A%22%5B'+padZeros(visDateStart)+'+TO+'+padZeros(visDateEnd)+'%5D%22&';
              }
            }
            {/literal}
                
            // Load the visualizer (see pubdate_vis.js)
            loadVis(action,'{$facetFields|escape:'javascript'}', visNavigation+'{$searchParams|escape:'javascript'}', '{$url}' {if $collectionName}, '{$collectionID|urlencode}', '{$collectionAction}'{/if});
            //]]>
          {literal} } {/literal}
        </script>
        </div>
    </div>

{/if}

<!-- END of: Search/Recommend/SidePubDateVisAjax.tpl -->
