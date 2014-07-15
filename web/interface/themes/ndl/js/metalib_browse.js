$(document).ready(function() {
    metalibBrowseInit();
});

function metalibBrowseInit() {
    // Hide 'preserve filters' option from Metalib/Browse search box
    // The current option is used even when not shown.
    $('.keepFilters').addClass('offscreen');

    
    $("ul.recordSet li.result .heading").on('click', function() {
        var li = $(this).closest('.result');
        li.find('.moreinfo').slideToggle(200);
        li.find('.icon').toggleClass('open');
        return false;
    });
}
