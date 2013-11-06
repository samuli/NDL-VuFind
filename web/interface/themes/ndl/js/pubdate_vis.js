var visNavigation = '', visDateStart, visDateEnd, visMove;
var dateVisYearLimit =  new Date().getFullYear() + 5;

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
function loadVis(action, facetFields, searchParams, baseURL, collection, collectionAction) {
    
    // Build AJAX url
    var url = baseURL + '/AJAX/JSON_Vis?method=getVisData&facetFields=' + encodeURIComponent(facetFields) + '&' + searchParams;
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

                // Compare with the values set by the user
                if (val['min'] == 0 || visDateStart < dataMin) {
                  val['min'] = dataMin;
                }

                if (val['max'] == 0 || visDateEnd > dataMax) {
                  val['max'] = dataMax;
                }
                
                if (val['max'] > dateVisYearLimit) {
                    val['max'] = dateVisYearLimit;
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
                
                // Check for values outside the selected range and remove them
                for (i=0; i<val['data'].length; i++) {
                    if (val['data'][i][0] < val['min'] -5 || val['data'][i][0] > parseInt(val['max'], 10) + 5) {
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
                        min: val['min'],
                        max: val['max'],
                        tickDecimals: 0, 
                        font :{
                            size: 13,
                            family: "'helvetica neue', helvetica,arial,sans-serif",
                            color:'#fff',
                            weight:'bold'
                        }                   
                    },
                    selection: {mode: "x", color:'#00a3b5;', borderWidth:0},
                    yaxis: { min: 0, ticks: [] },
                    grid: { 
                        backgroundColor: null, 
                        borderWidth:0,
                        axisMargin:0,
                        margin:0
                    }
                };
                
                // Draw the plot
                var plot = $.plot(vis, [val], options);
                
                vis.bind("plotselected", function (event, ranges) {
                    from = Math.floor(ranges.xaxis.from);
                    to = Math.floor(ranges.xaxis.to);
                    (from != '-9999') ? $('#mainYearFrom').val(from) : $('#mainYearFrom').val();
                    (to != '9999') ? $('#mainYearTo').val(to) : $('#mainYearTo').val();
                });
                
                // Set pre-selections
                var preFromVal = ($('#mainYearFrom').val()) ? $('#mainYearFrom').val() : val['min'];
                var preToVal = ($('#mainYearTo').val()) ? $('#mainYearTo').val() : val['max'];

                if ($('#mainYearFrom').val() || $('#mainYearTo').val()) {
                    plot.setSelection({ x1: preFromVal , x2: preToVal});
                } 
                
                $('.dateVis').removeClass('loading');
                
            });
        }
    });
}