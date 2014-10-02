$(document).ready(function() {
    // assign action to the openUrlWindow link class
    $('a.openUrlWindow').unbind('click').click(function(e){
        var params = extractParams($(this).attr('class'));
        var settings = params.window_settings;
        window.open($(this).attr('href'), 'openurl', settings);
        e.preventDefault();
    });

    // assign action to the openUrlEmbed link class
    $('a.openUrlEmbed').unbind('click').click(function(e){
        $(this).unbind('inview');
        var params = extractParams($(this).attr('class'));
        var openUrl = $(this).children('span.openUrl:first').attr('title');
        $(this).hide();
        loadResolverLinks($('#openUrlEmbed'+params.openurl_id).show(), openUrl);
        e.preventDefault();
    });
});

function loadResolverLinks($target, openUrl) {
    if (module == 'Browse') {
        $target.hide();
        $target.closest('li.result').addClass('ajax_availability_browse');
    } else {
        $target.addClass('ajax_availability');
    }
    var url = path + '/AJAX/JSON?' + $.param({method:'getResolverLinks',openurl:openUrl});
    $.ajax({
        dataType: 'json',
        url: url,
        success: function(response) {
            $target.show();
            if (response.status == 'OK') {
                if (module == 'Browse') {
                    $target.closest('li.result').removeClass('ajax_availability_browse');
                } else {
                    $target.removeClass('ajax_availability');                    
                }
                $target.empty().append(response.data);
                link = $target.find('.openurl_more');

                if (module == 'Browse' && action == 'Journal') {
                    // Browse/Journal:
                    // - Move openurl 'More options' link to detailed view.
                    var more = $target.closest('.recordId').find('.moreinfo').find('.moreOptions');
                    if (more) {
                        moreOptions = $target.find('.openurl_more_full');
                        more.after(moreOptions);                        
                    }
                }

                link.click(function(e) {
                    var div = $(this).siblings('.openurlDiv');
                    var self = $(this);
                    self.toggleClass('expanded');
                    if (div.length > 0) {
                        div.slideToggle(150);
                    } else {
                    	div = $('<div/>').addClass('openurlDiv');
                        div.insertAfter(self);
                        $('<span class="iframe_loading"/>').insertAfter(self);
                    	iframe = $('<iframe/>');
                    	iframe.attr('class', 'openurlIframe');
                    	iframe.load(function() { $('.iframe_loading').remove(); });
                    	iframe.attr('src', self.attr('href'));
                    	div.append(iframe);
                    	div.append(self.siblings('.openurl_more_full').show());
                    }
                    e.preventDefault();
                });
            } else {
                if (module == 'Browse') {
                    $target.closest('li.result').removeClass('ajax_availability_browse');
                } else {
                    $target.removeClass('ajax_availability');
                } 
                $target.addClass('error').empty().append(response.data);
                $('.iframe_loading').removeClass('iframe_loading');
            }
        }
    });
}
