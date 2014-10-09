$(document).ready(function() {
    $('.recordId').unbind('inview').one('inview', function() {
        checkMetaLibLinks($(this));
    });
});

function showMetaLibLink(obj) {    
    if (module == 'Browse') {
        obj.addClass("visible");
    } else {
        obj.show();
    }
}

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
		    
            if (module != 'Browse') {
                if (response.status != 'OK') {		            
                    obj.find('.metalib_link').text("MetaLib link check failed.");		            
                    return;
                }
            }
            
            $.each(response.data, function(i, result) {
                var safeId = jqEscape(result.id);
                
                if (result.status == 'allowed') {
                    showMetaLibLink(obj.find('#metalib_link_' + safeId));
                    
                    if (module == 'Browse') {
                        showMetaLibLink(obj.find('.metalibLinkContainer .metalib_link_ok'));
                    }
                } else if (result.status == 'nonsearchable') {
                    showMetaLibLink(obj.find('#metalib_link_ns_' + safeId));

                    if (module == 'Browse') {
                        obj.find('.metalibLinkContainer').css('display','none');
                    }
                } else {
                    showMetaLibLink(obj.find('#metalib_link_na_' + safeId));

                    if (module == 'Browse') {
                        showMetaLibLink(obj.find('#metalib_link_' + safeId));
                        showMetaLibLink(obj.find('.metalibSearchDisallow'));

                        showMetaLibLink(obj.find('.metalibLinkContainer .metalib_link_na'));
                        showMetaLibLink(obj.find('.metalibLinkContainer .metalib_link_ok'));
                    }
                }
            });
        }).error(function() {
            obj.find('.metalib_link').removeClass('ajax_fulltext_availability');
            if (module != 'Browse') {
                obj.find('.metalib_link').text("MetaLib link check failed.");
            }
        });              
    }
}
