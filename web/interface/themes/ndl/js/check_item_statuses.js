$(document).ready(function() {
    $('.recordId').unbind('inview').one('inview', function() {
        var id = $(this).attr('id').substr('record'.length);
        checkItemStatuses([id]);
    });

    selectItem();
});

function checkItemStatuses(id) {

    if (id.length) {
        $("div[id^='callnumAndLocation'] .ajax_availability").show();
        $.ajax({
            dataType: 'json',
            url: path + '/AJAX/JSON?method=getItemStatuses',
            data: {id:id},
            success: function(response) {
                if(response.status == 'OK') {
                    $.each(response.data, function(i, result) {
                        var safeId = jqEscape(result.id);
                        if (result.total && result.total > 0) {
                            $('#availableHoldings' + safeId + ' span.availableNumber').text(result.total);
                            $('#availableHoldings' + safeId).css('display', 'inline')
                        }
                        $('#record' + safeId + ' .dedupform').removeAttr('selected').
                            find('option[value="'+safeId+'"]').attr('selected', '1');
                        if (typeof(result.full_status) != 'undefined'
                            && result.full_status.length > 0
                            && $('#callnumAndLocation' + safeId).length > 0
                        ) {
                            // Full status mode is on -- display the HTML and hide extraneous junk:
                            $('#callnumAndLocation' + safeId).empty().append(result.full_status).show();
                            $('#callnumber' + safeId).hide();
                            $('#location' + safeId).hide();
                            $('.hideIfDetailed' + safeId).hide();
                        } else if (typeof(result.missing_data) != 'undefined'
                            && result.missing_data
                        ) {
                            // No data is available -- hide the entire status area:
                            $('#nodata' + safeId).show();
                            $('#callnumAndLocation' + safeId).hide();
                        } else if (result.locationList) {
                            // We have multiple locations -- build appropriate HTML and hide unwanted labels:
                            $('#callnumber' + safeId).hide();
                            if (result.truncated) {
                                $('#moredata' + safeId).show();
                            }
                            $('.hideIfDetailed' + safeId).hide();
                            $('#location' + safeId).hide();
                            var locationListHTML = "";
                            for (x=0; x<result.locationList.length; x++) {
                                locationListHTML += '<div class="itemLocationInfo"><span class="groupLocation">';
                                if (result.locationList[x].availability) {
                                    locationListHTML += '<span class="availableLoc">' 
                                        + result.locationList[x].location + '</span> ';
                                } else if (typeof(result.locationList[x].use_unknown_status) != 'undefined'
                                    && result.locationList[x].use_unknown_status
                                ) {
                                    if (result.locationList[x].location) {
                                        locationListHTML += '<span class="availableLoc">' 
                                            + result.locationList[x].location + '</span> ';
                                    }
                                } else {
                                    locationListHTML += '<span class="checkedoutLoc">'  
                                        + result.locationList[x].location + '</span> ';
                                }
                                locationListHTML += '</span>';
                                locationListHTML += '<span class="groupCallnumber">';
                                locationListHTML += (result.locationList[x].callnumbers) 
                                     ?  '('+result.locationList[x].callnumbers+')' : '';
                                locationListHTML += '</span></div>';
                            }
                            $('#locationDetails' + safeId).show();
                            $('#locationDetails' + safeId).empty().append(locationListHTML);
                        } else {
                            // Default case -- load call number and location into appropriate containers:
                            $('#callnumber' + safeId).empty().append(result.callnumber);
                            if (result.truncated) {
                                $('#moredata' + safeId).show();
                            }
                            $('#location' + safeId).empty().append(
                                result.reserve == 'true' 
                                ? result.reserve_message 
                                : result.location
                            );
                        }
                    });
                } else {
                    // display the error message on each of the ajax status place holder
                    $("div[id^='callnumAndLocation'] .ajax_availability").empty().append(response.data);
                }
                $("div[id^='callnumAndLocation'] .ajax_availability").removeClass('ajax_availability');
            }
        });
    }
}

function selectItem() {
    $('.dedupform').change(function() {
        var id = $(this).val();
        var location = $(this).find('option:selected').attr('class').split(' ')[1];
        $.cookie("preferredRecordSource", location);
        var recordContainer = $(this).closest('.result.recordId');
        var currentRecord = recordContainer.attr('id').substr('record'.length);
        
        // Update ids of elements
        recordContainer.attr('id', 'record'+id);
        recordContainer.find('[id*="'+currentRecord+'"]').each(function() {
            var oldId = $(this).attr('id');
            $(this).attr('id', oldId.replace(currentRecord, id));
        });

        // Update links as well
        recordContainer.find('a').each(function() {
            if (typeof $(this).attr('href') !== 'undefined') {
                $(this).attr('href', $(this).attr('href').replace(currentRecord, id));
            }
        })

        safeId = jqEscape(id);
        $('#locationDetails'+safeId+', #availableHoldings'+safeId+', #nodata'+safeId+', #moredata'+safeId).hide();
        $('#callnumAndLocation'+safeId).show();
        $('#location'+safeId).addClass('ajax_availability').show();

        checkItemStatuses([id]);
    })
    
}
