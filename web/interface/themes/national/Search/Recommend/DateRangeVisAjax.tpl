<!-- START of: Search/Recommend/DateRangeVisAjax.tpl -->

{if $visFacets}
  <div class="resultDates">
    <div class="content">
        <div class="mainYearFormContainer2">
        {if $pageTemplate == 'home.tpl'}
          <form action="Search/Results?lookfor=&prefilter=-&SearchForm_submit={translate text="Find"}&retainFilters=0{if $filterList.$dateRange.0}{$filterList.$dateRange.0.removalUrl}{/if}" class="mainYearForm">
            <input id="mainYearFrom" type="text" value="{if $visFacets.search_sdaterange_mv.0 != "-9999"}{$visFacets.search_sdaterange_mv.0}{/if}">-
            <input id="mainYearTo" type="text" value="{if $visFacets.search_sdaterange_mv.1 != "9999"}{$visFacets.search_sdaterange_mv.1}{/if}">
            <input type="submit" value="{translate text='Search'}">
          </form>
          <script type="text/javascript">
            var visNationalHome = true;
          </script>
        {/if}
        </div>
        {* load jQuery flot *}
        <!--[if IE]>{js filename="flot/excanvas.min.js"}<![endif]--> 
        {js filename="flot/jquery.flot.js"}
        {js filename="flot/jquery.flot.selection.js"}
        {js filename="daterange_vis.js"}

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
                {/literal}
                visNavigation = 'filterField=search_sdaterange_mv&facetField=main_date_str&sdaterange[]={$filterField}&{$filterField}from='+padZeros(visDateStart)+'&{$filterField}to='+padZeros(visDateEnd)+'&{$searchParamsWithoutFilter|escape:'javascript'}';
                {literal}
              }
            } else {
                {/literal}
                visNavigation = '{$searchParams|escape:'javascript'}'; 
                {literal}
            }
            {/literal}
                            
            // Load the visualizer (see daterange_vis.js)
            loadVis(action, '{$filterField|escape:'javascript'}', '{$facetFields|escape:'javascript'}', visNavigation, '{$url}' {if $collectionName}, '{$collectionID|urlencode}', '{$collectionAction}'{/if});
            //]]>
          {literal} } {/literal}
        </script>
        </div>
    </div>

{/if}

<!-- END of: Search/Recommend/DateRangeVisAjax.tpl -->
