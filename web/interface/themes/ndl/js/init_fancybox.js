$(document).ready(function() {
    $('.fancybox').fancybox({ nextEffect: 'fade', prevEffect: 'fade' });
});

function launchFancybox(el) {
    var hrefs = new Array();
    hrefs.push($(el).attr('href'));
    var group = $(el).attr('rel');
    $('a[rel="'+group+'"]').each(function(){
        var href = $(this).attr('href').replace('&index=0', '');
        if ($.inArray(href, hrefs) === -1) {
            hrefs.push(href);
        }
    });
    $.fancybox.open(hrefs, { type: 'image', nextEffect: 'fade', prevEffect: 'fade' } );
}