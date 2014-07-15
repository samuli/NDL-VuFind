$(document).ready(function() {
    $('.recordId').unbind('inview').one('inview', function() {
        checkMetaLibLinks($(this));
    });
});

function checkMetaLibLinks(obj) {
    var id = obj.attr('id').substr('record'.length);
    if (id.substr(0, 8) != 'metalib_') {
        id = null;
    }

    id = [id];

    if (id.length) {
    	// set the spinner going
        obj.find('.metalib_link').not('.iconsLeft').addClass('ajax_fulltext_availability');

        url = path + '/AJAX/JSON_MetaLib?method=getSearchLinkStatuses';
    	$.getJSON(url, {id:id}, function(response) {
            obj.find('.metalib_link').removeClass('ajax_fulltext_availability');
		    
            if (action != 'Browse') {
                if (response.status != 'OK') {		            
                    obj.find('.metalib_link').text("MetaLib link check failed.");		            
                    return;
                }
            }
            
            $.each(response.data, function(i, result) {
                var safeId = jqEscape(result.id);
                
                if (result.status == 'allowed') {
                    obj.find('#metalib_link_' + safeId).show();

                } else if (result.status == 'nonsearchable') {
                    obj.find('#metalib_link_ns_' + safeId).show();
                } else {
                    obj.find('#metalib_link_na_' + safeId).show();
                    
                    if (action == 'Browse') {
                        var icon = obj.find('.metalibSearchDisallow');
                        icon.css('visibility', 'visible');
                    }
                }
            });
        }).error(function() {
            obj.find('.metalib_link').removeClass('ajax_fulltext_availability');
            if (action != 'Browse') {
                obj.find('.metalib_link').text("MetaLib link check failed.");
            }
        });              
    }
}
