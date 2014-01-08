var visNavigation = '', visDateStart, visDateEnd, visMove;

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
    var url = baseURL + '/AJAX/JSON_DateRangeVisPCI?method=getVisData&' + searchParams;

    // Store the searchterm(s) when no range set. See DateRangeVisAjax.tpl
    if (!(/creationdate/.test(self.location.href))) {
        localStorage.setItem('lookFor', searchParams);
    }

    if (typeof collection != 'undefined'){
        url+= '&collection=' + collection + '&collectionAction='+ collectionAction;
    }
    // AJAX call
    $.getJSON(url, function (data) {
        if (data.status == 'OK') {
            $.each(data['data'], function(key, val) {
                // Sort the array by year
                val['data'].sort(function(a, b) {
                    return a[0] - b[0];
                });
                var vis = $(".dateVis");

                // Get data limits & store them initially (see ndl.js)
                dataMin = parseInt(val['data'][0][0], 10);
                dataMax = parseInt(val['data'][val['data'].length - 1][0], 10);
                if (!(/creationdate/.test(self.location.href))) {
                    localStorage.setItem('PCIdataMin', dataMin);
                    localStorage.setItem('PCIdataMax', dataMax);
                }

                // National home page: render default view from 1800 to present
                /* No point having this with PCI
                if (typeof visNationalHome !== 'undefined' && visNationalHome) {
                    dataMin = 1800;
                }
                */

                // Compare with the values set by the user
                // and get correct range values since PCI returns values beyond selected

                if (val['min'] == "") {
                  if (/creationdate/.test(self.location.href)) {
                    if (localStorage.getItem('PCIfrom') == "") {
                      val['min'] = localStorage.getItem('PCIdataMin');
                    } else {
                      val['min'] = localStorage.getItem('PCIfrom');
                      localStorage.removeItem('PCIfrom');
                    }
                  } else {
                    val['min'] = dataMin;
                  }
                }

                if (val['max'] == "") {
                  if (/creationdate/.test(self.location.href)) {
                    if (localStorage.getItem('PCIto') == "") {
                      val['max'] = localStorage.getItem('PCIdataMax');
                    } else {
                      val['max'] = localStorage.getItem('PCIto');
                      localStorage.removeItem('PCIto');
                    }
                  } else {
                    val['max'] = dataMax;
                  }
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
                  if ((/creationdate/.test(self.location.href)) && (!(/TO/.test(self.location.href)))) {
                    visDateStart = localStorage.getItem('PCIdataMin');
                  } else {
                    visDateStart = parseInt(val['min'], 10);
                  }
                }
                
                var maxYear = new Date().getFullYear();
                
                if (typeof visDateEnd === 'undefined') {
                  if ((/creationdate/.test(self.location.href)) && (!(/TO/.test(self.location.href)))) {
                    visDateEnd = localStorage.getItem('PCIdataMax');
                  } else {
                    visDateEnd = parseInt(val['max'], 10);
                  }  
                    if (visDateEnd > maxYear) {
                        visDateEnd = maxYear;
                    }
                }
                
                /* Limit range to 0
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
                        margin:0
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
                
                vis.bind("plotselected", function (event, ranges) {
                    from = Math.floor(ranges.xaxis.from);
                    to = Math.floor(ranges.xaxis.to);

                    // Store the plot range
                    localStorage.setItem('PCIfrom', from);
                    localStorage.setItem('PCIto', to);

                    (from != '-9999') ? $('#mainYearFrom').val(from) : $('#mainYearFrom').val();
                    (to != '9999') ? $('#mainYearTo').val(to) : $('#mainYearTo').val();

                    $('body').click();
                });

                // Set pre-selections

                // Empty values get changed to original dataMin and dataMax
                if (val['min'] == "") {
                    val['min'] = localStorage.getItem('PCIdataMin');
                }
                if (val['max'] == "") {
                    val['max'] = localStorage.getItem('PCIdataMax');
                }

                var preFromVal = ($('#mainYearFrom').val()) ? $('#mainYearFrom').val() : val['min'];
                var preToVal = ($('#mainYearTo').val()) ? $('#mainYearTo').val() : val['max'];

                if (!(/TO/.test(self.location.href))) {
                    preFromVal = localStorage.getItem('PCIdataMin');
                    preToVal = localStorage.getItem('PCIdataMax');
                }

                $('#mainYearFrom').attr('value', val['min']);
                $('#mainYearTo').attr('value', val['max']);

                if (($('#mainYearFrom').val() || $('#mainYearTo').val()) &&
                (/creationdate/.test(self.location.href)) && (/TO/.test(self.location.href))) {
                    plot.setSelection({ x1: preFromVal , x2: preToVal});
//                    localStorage.removeItem('PCIfrom');
//                    localStorage.removeItem('PCIto');
                } 

                vis.removeClass('loading');

            });
        }
    });
}
