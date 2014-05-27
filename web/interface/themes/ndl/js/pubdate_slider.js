$(document).ready(function(){
    // create the slider for the publish date facet
    var date = new Date();
    var endDate = date.getFullYear() + 2;
    $("#publishDateSlider").jslider({ from: startDate, to: endDate, 
                                      heterogeneity: ['0/'+startDate, '25/'+scale1, '50/'+scale2, '75/'+scale3], 
                                      scale: [startDate, '|', scale1, '|', scale2, '|', scale3, '|', endDate], 
                                      limits: false, step: 1, 
                                      dimension: '', 
                                      format: {locale: 'fi'},
                                      callback: function(){
                                        updateFields();
                                      }
        });
        // Set slider start point to starting year
        $("#publishDateSlider").jslider("value", startDate);

        $('#publishDatefrom, #publishDateto').change(function(){
            updateSlider();
        });

        $("form").submit(function() {
        	$('#publishDateSlider').attr("disabled", "disabled");
  	        return true; // ensure form still submits
   	    });

        
});

function updateFields() {
	var values = $("#publishDateSlider").jslider("value");	
	var limits = values.split(";");
    $('#publishDatefrom').val(limits[0]);
    $('#publishDateto').val(limits[1]);
}

function updateSlider() {
    var from = parseInt($('#publishDatefrom').val());
    var to = parseInt($('#publishDateto').val());
    var min = startDate;
    if (!from || from < min) {
        from = min;
    }

    if (to && from > to) {
        to = from;
    }
    
    // update the slider with the new min/max/values
    $("#publishDateSlider").jslider("value", from, to);	
}
