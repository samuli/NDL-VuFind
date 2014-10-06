$(document).ready(function() {
    browseExtendedInit();
});

function browseExtendedInit() {    
    // Hide 'preserve filters' option from Metalib/Browse search box
    // The current option is used even when not shown.
    // Note: autocomplete menu toggles display property, so can't use show() here.
    $('.keepFilters').css('visibility', 'hidden');

    // Hide prefilter menu
    $('#searchForm .searchForm_filter').parent('div').hide();
    
    $("ul.recordSet li.result a.toggle").on('click', function() {
        browseExtendedShowMore($(this));
        return false;
    });


    // Reopen 'Show more' if we are returning from record page
    if (window.location.hash) {
        var rec = $("div.recordId[id='" + window.location.hash.substr(1) + "']");
        if (rec.length) {
            browseExtendedShowMore(rec.find('.snippet'));
        }
    }
}

function browseExtendedShowMore(obj) {
    var li = obj.closest('.result');
    li.find('.moreinfo').slideToggle(200);
    li.find('.icon').toggleClass('open');
    li.find('.truncateField').collapse({maxRows: 2, more: trMore, less: trLess});
}
