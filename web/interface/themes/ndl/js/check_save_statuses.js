$(document).ready(function() {
    checkSaveStatuses();
    // attach click event to the save record link
    $('a.saveRecord, a.saveMetaLibRecord, a.savePCIRecord').unbind('click').click(function(e) {
        var module = 'Record';
        if ($(this).hasClass('saveMetaLibRecord')) {
            module = 'MetaLib';
        } else if ($(this).hasClass('savePCIRecord')) {
            module = 'PCI';
        }
        var favContainer = $(this).parent();
        var id = this.id.substr('saveRecord'.length);
        var title = this.title;
        var idWithoutDots = id.replace(/\./g, '');
      
        if (listList.length > 0) {
            if (favContainer.find('.dropdown').length == 0) {
                // create the menu based on the listList array
                var listMenu = '<form class="addToFavoritesSelector"><select id="favSelector' + idWithoutDots + '" class="styledDropdowns">';
                for (var i = 0; i < listList.length; i++) {
                    listMenu += '<option value="' + listList[i][0] + '">' + listList[i][1] + '</option>';
                }
                listMenu += '</select></form>';
                favContainer.prepend(listMenu);

                // initialize NDL customizations
                createDropdowns();
                initDropdowns();
                
                // hide the menu button
                favContainer.find('dt a').hide();
            }
            

            // close all other dropdowns
            $(".dropdown").trigger("toggle", false);
            // open the menu
            favContainer.find('.dropdown').trigger("toggle", true);
            
            favContainer.find('li').unbind('click').click(function(e) {
                var listId = $(this).find('.value').text();
                var postparams = { list: listId };
                var $dialog = getLightbox(module, 'Save', id, null, title, module, 'Save', id, postparams);
            });
            
            // we have to stop propagation; otherwise the document click in dropdown.js
            // closes the menu we have just opened
            e.stopPropagation();
        } else {
            var $dialog = getLightbox(module, 'Save', id, null, title, module, 'Save', id);
        }
      
        e.preventDefault();
    });
});

function checkSaveStatuses() {
    var id = $.map($('.recordId'), function(i) {
        return $(i).attr('id').substr('record'.length);
    });
    if (id.length) {    
        $.ajax({
            dataType: 'json',
            url: path + '/AJAX/JSON?method=getSaveStatuses',
            data: {id:id},
            success: function(response) {
                if(response.status == 'OK') {
                    $('.savedLists > ul').empty();
                    $.each(response.data, function(i, result) {
                        var $container = $('#savedLists' + jqEscape(result.record_id));
                        var $ul = $container.children('ul:first');
                        if ($ul.length == 0) {
                            $container.append('<ul></ul>');
                            $ul = $container.children('ul:first');
                        }
                        var html = '<li><a href="' + path + '/MyResearch/MyList/' + result.list_id + '">' 
                                 + result.list_title + '</a></li>';
                        $ul.append(html);
                        $container.show();
                    });
                }
            }
        });
    }
}


