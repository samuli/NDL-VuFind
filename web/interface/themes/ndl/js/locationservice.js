/**
 * Scripts for NDL's Location Service
 */
$(document).ready(function() {
    var dialogWidth = $(window).width() * 0.8;
    var dialogHeight = $(window).height() * 0.8;
    $("#modalLocationService").dialog({
        autoOpen: false,
        modal: true,
        height: dialogHeight,
        width: dialogWidth,
    });

    $('.openLocationService').each( function(index, elem) {
        $(elem).click(function() {
            $('#locationServiceFrame').attr('src', $(this).attr("href")); 
            $('#locationServiceDirectLink').attr('href', $(this).attr("href")); 
            $('#modalLocationService').dialog('open');
            return false;
        });
    });
});
