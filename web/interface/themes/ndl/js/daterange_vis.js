var visNavigation = '', visDateStart, visDateEnd, visMove, visRangeSelected = false;

// Move dates: params either + or -
function moveVis(start,end) {
  var ops = {
    '+': function(a) { return a += visMove },
    '-': function(a) { return a -= visMove }
  };
  visDateStart = ops[start](visDateStart);
  visDateEnd = ops[end](visDateEnd);
}

// Date visualizer navigation
$(document).ready(function() {
    $('.dateVisNavigation div').click(function() {
      loadVisNow($(this).attr('class').split(' ')[0]);
    });
});

// Load the visualizer
function loadVis(action, filterField, facetField, searchParams, baseURL, collection, collectionAction) {
  
    // Build AJAX url
    var url = baseURL + '/AJAX/JSON_DateRangeVis?method=getVisData&' + searchParams;
    if (typeof collection != 'undefined'){
        url+= '&collection=' + collection + '&collectionAction='+ collectionAction;
    }
    // AJAX call
    $.getJSON(url, function (data) {
        if (data.status == 'OK') {
            $.each(data['data'], function(key, val) {
                
                var vis = $(".dateVis");
                
                // Get data limits
                dataMin = parseInt(val['data'][0][0], 10);
                dataMax = parseInt(val['data'][val['data'].length - 1][0], 10);
                
                // National home page: render default view from 1800 to present
                if (typeof visNationalHome !== 'undefined' && visNationalHome) {
                    dataMin = 1800;
                }

                // Compare with the values set by the user
                if (val['min'] == 0) {
                  val['min'] = dataMin;
                }

                if (val['max'] == 0) {
                  val['max'] = dataMax;
                }
                
                // Left & right limits have to be processed separately
                // depending on movement direction: when reaching the left limit while
                // zooming in or moving back, we use the max value for both
                if ((action == 'prev' || action == 'zoomIn') && val['min'] > val['max']) {
                  val['max'] = val['min'];
                  
                // Otherwise, we need the min value
                } else if (action == 'next' && val['min'] > val['max']) {
                  val['min'] = val['max']; 
                }

                if (typeof visDateStart === 'undefined') {
                    visDateStart = parseInt(val['min'], 10);
                }
                
                var maxYear = new Date().getFullYear();
                
                if (typeof visDateEnd === 'undefined') {
                    visDateEnd = parseInt(val['max'], 10);
                    
                    if (visDateEnd > maxYear) {
                        visDateEnd = maxYear;
                    }
                }
                
                 /* Limit range to 0 - now
                    (Disabled for now)
                
                visDateEnd = visDateEnd > maxYear ? maxYear : visDateEnd;
                visDateStart = visDateStart < -1000 ? 0 : visDateStart; */
                
                // Check for values outside the selected range and remove them
                for (i=0; i<val['data'].length; i++) {
                    if (val['data'][i][0] < visDateStart - 5 || val['data'][i][0] > visDateEnd + 5) {
                        // Remove this
                        val['data'].splice(i,1);
                        i--;
                    }
                }
               
                // Graph configuration
                var options = {
                    series: {
                        bars: { 
                            show: true,
                            color: "#00a3b5",
                            fillColor: "#00a3b5"
                        }
                    },
                    colors: ["#00a3b5"],
                    legend: { noColumns: 2 },
                    xaxis: { 
                        min: visDateStart,
                        max: visDateEnd,
                        tickDecimals: 0,                         
                        font :{
                            size: 13,
                            family: "'helvetica neue', helvetica,arial,sans-serif",
                            color:'#fff',
                            weight:'bold'
                        }                  
                    },
                    yaxis: { min: 0, ticks: [] },
                    grid: { 
                        backgroundColor: null, 
                        borderWidth:0,
                        axisMargin:0,
                        margin:0,
                        clickable:true
                    }
                };

                // Disable selection of time range (by dragging) when on Android
                // (otherwise the timeline component doesn't always get redrawn 
                // correctly after a selection has been made.) 
                var isAndroid = navigator.userAgent.match(/(android)/i);
                if (!isAndroid) {
                    options['selection'] = {mode: "x", color:'#00a3b5;', borderWidth:0};
                }

                // Draw the plot
                var plot = $.plot(vis, [val], options);
                
                // Bind events
                vis.unbind("plotclick").bind("plotclick", function (event, pos, item) {
                    if (!visRangeSelected) {
                        var year = Math.floor(pos.x);
                        $('#mainYearFrom, #mainYearTo').val(year);
                        plot.setSelection({ x1: year , x2: year});
                    }
                    visRangeSelected = false;
                });
                
                vis.unbind("plotselected").bind("plotselected", function (event, ranges) {
                    from = Math.floor(ranges.xaxis.from);
                    to = Math.floor(ranges.xaxis.to);
                    (from != '-9999') ? $('#mainYearFrom').val(from) : $('#mainYearFrom').val();
                    (to != '9999') ? $('#mainYearTo').val(to) : $('#mainYearTo').val();
                    $('body').click();
                    visRangeSelected = true;
                });
                
                // Set pre-selections
                var preFromVal = ($('#mainYearFrom').val()) ? $('#mainYearFrom').val() : val['min'];
                var preToVal = ($('#mainYearTo').val()) ? $('#mainYearTo').val() : val['max'];

                if ($('#mainYearFrom').val() || $('#mainYearTo').val()) {
                    plot.setSelection({ x1: preFromVal , x2: preToVal});
                } 
                
                vis.removeClass('loading');
                
            });
        }
    });
}