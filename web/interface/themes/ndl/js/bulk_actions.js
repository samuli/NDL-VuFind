$(document).ready(function(){
    registerBulkActions();
    registerFavoritesActions();
});

function registerBulkActions() {
    $('form[name="bulkActionForm"] input[type="submit"]').unbind('click').click(function(e){
        var ids = $.map($(this.form).find('input.checkbox_ui:checked'), function(i) {
            return $(i).val();
        });
        var action = $(this).attr('name');
        var message = $(this).attr('title');
        var id = '';
        var module = "Cart";
        switch (action) {
        case 'export':
            var postParams = {origin: 'Favorites', ids:ids, 'export':'1'};
            action = "Home";
            break;
        case 'delete':
            module = "MyResearch";
            action = "Delete";
            var postParams = {origin: 'Favorites', ids:ids, 'delete':'1'};
            id = $(this).attr('id');
            id = (id.indexOf('bottom_delete_list_items_') != -1) 
                ? id.replace('bottom_delete_list_items_', '')
                : id.replace('delete_list_items_', '');
            break;
        case 'email':
            action = "Home";
            var postParams = {origin: 'Favorites', ids:ids, email:'1'};
            break;
        case 'print': 
            var printing = printIDs(ids);
            if(printing) {
                return false;
            } else {
                action = "Home";
                var postParams = {origin: 'Favorites', error:'1'};
            }
            break;
        }
        getLightbox(module, action, id, '', message, '', '', '', postParams);
        e.preventDefault();
    });

    $('form[name="bulkActionForm"] select').change(function(){
        $(this).closest('form').submit();
    });
    
    // Support delete list button:
    $('.deleteList').unbind('click').click(function(e){
        var id = $(this).attr('id').substr('deleteList'.length);
        var message = $(this).attr('title');
        var postParams = {origin: 'Favorites', listID: id, deleteList: 'deleteList'};
        getLightbox('Cart', 'Home', '', '', message, 'MyResearch', 'Favorites', '', postParams);
        e.preventDefault();
    });
}

function registerFavoritesActions() {
  
    // Favorites toolbox toggler functions
    var favCheckboxes = $('.favoritesList .recordSet input[type="checkbox"]');
    favCheckboxes.change(function(){
        checkFavTools();
    }); 
    $('.selectAllCheckboxes').change(function() {
        if ($(this).is(':checked')) {
            toggleFavTools('show');
        } else {
            toggleFavTools('hide');
        }
    });
    $('.checkBoxDeselectAll').click(function(e) {
        e.preventDefault();
        $('.selectAllCheckboxes').click();
        if ($('.selectAllCheckboxes').is(':checked')) {
            $('.selectAllCheckboxes').click();
        }
    });
    function checkFavTools() {
        var mode = favCheckboxes.is(':checked') ? 'show' : 'hide';
        toggleFavTools(mode);
    }   
    function toggleFavTools(mode) {
        var tools = $('.favoritesList .bulkActionButtons, form[name="bulkActionForm"]');
        if (mode == 'show') {
            tools.addClass('visible');
        } else {
            tools.removeClass('visible');
        }
    }
        
    checkFavTools();
    
    // Store click target to check blur source
    var $clickTarget;
    $(document).mousedown(function(e) {
        $clickTarget = $(e.target);
    }).mouseup(function() {
        $clickTarget = null;
    });
    
    // Icon, placeholder click
    $(document).on('click', '.dynamicInput a, .dynamicInput .placeholder', function(e) {
        e.preventDefault();
        var $container = $(e.target).closest('.dynamicInput');
        var $text = $container.find('.transform');
        var autoFill = $text.is('.placeholder') ? false : $text.text().trim();
        $container.removeClass('hover indicate');
        // Display the form
        toggleDynamicInput($container, true, autoFill);
    });
    
    // Submit by pressing enter, cancel with esc
    $('.dynamicInput input').bind('keydown', function(e) {
        var code = e.keyCode || e.which; 
        var $container = $(this).closest('.dynamicInput');
        // Enter
        if (code  == 13) {      
            e.preventDefault();
            processDynamicInput($(this).closest('.dynamicInput'));
            $(this)[0].blur();
        // Esc
        } else if (code == 27) {
            e.preventDefault();
            toggleDynamicInput($container, false);
            $(this)[0].blur();
        }
    });
    
    // Visibility radio buttons
    $('.dynamicRadioButton input').change(function() {
        var $container = $(this).closest('.dynamicRadioButton'); 
        var value = $container.find('input:checked').val();
        
        $('.publicListURL').removeClass('hiddenElement').addClass('loading');
        processDynamicInput($container, value);
    });
    
    // Blur event
    $(document).on('blur', '.dynamicInput input:not([type="radio"])', function(e) {
        var $container = $(this).closest('.dynamicInput');
        // Process if icon clicked or autosubmit enabled
        if ($clickTarget && ($clickTarget[0] == $container.find('a')[0]
            || $container.is('.autoSubmit'))) {
            processDynamicInput($container);
        // Else hide the form
        } else if ($clickTarget) {
              toggleDynamicInput($container, false);
        }
        // Prevent bubbling
        e.stopPropagation();
    });

    // Input visibility toggler
    function toggleDynamicInput($container, show, autofill, newValue) {
        var $input = $container.find('input');
        var $text = $container.find('.transform');
        // Either populate or clean the input
        if (autofill) {
            $input.val(autofill);
        } else {
            $input.val('');
        }

        // Toggle visibility of labels and inputs
        $text.toggleClass('hiddenElement', show);
        $input.toggleClass('hiddenElement', !show);
        $container.add($input).toggleClass('ready', show);

        // Focus on the input if requested
        if (show) {
            $input.focus();
        } 
        
        // Update element text
        if (typeof newValue !== 'undefined') {
            var $icon = $container.find('.icon');
            if (newValue != '') {
                $text.text(newValue).removeClass('placeholder');
                $icon.removeClass('add').addClass('edit');
            } else {
                $text.text($text.data('placeholder')).addClass('placeholder');
                $icon.removeClass('edit').addClass('add');
            }
        }
    }
    
    // Save modified values in the database
    function processDynamicInput($container, value) {
        var $input = $container.find('input');  
        if (typeof value === 'undefined') {
            value = $input.attr('value').trim();
        }
        
        // Return if required & empty or unchanged value
        if ($container.is('.notEmpty') && value == '' 
            || value == $container.find('.transform').text()) {
            toggleDynamicInput($container, false);
            return;
        } 
        // Add loading class
        $container.find('input[type="text"]').addClass('loading');
        
        // Collect data
        var data = {}, response;
        data[$input.attr('name')] = value;    
        data['listId'] = $('.favoritesList').data('listid');
        data['recordId'] = $container.closest('.recordId').data('recordid'); 
        var url = path + '/AJAX/JSON_MyResearch?method=saveListData';
        
        $.getJSON(url, data, function(response) {
            // Return on status other than OK
            if (response.status != 'OK') {
                if (response.status == 'NEED_AUTH') {
                     printDynamicInputError(vufindString.authError);
                } else {
                     printDynamicInputError(vufindString.error);
                }
                return;
            } 
            // Remove loading class
            $container.find('input[type="text"]').removeClass('loading');
            // Clear previous error messages
            clearDynamicInputError();
            // Auto submit
            if ($container.is('.autoSubmit')) {
                toggleDynamicInput($container, false, false, value);
            }
            // Add list
            if ($container.is('.addNewList')) {
                dynamicAddList(value, response.data);
                toggleDynamicInput($container, false);
            }
            // Visibility
            if ($container.is('.isListPublic')) {
                $('#sidebarFavoritesLists .selected .publicStatus')
                    .toggleClass('hiddenElement');
                $('.publicListURL').removeClass('loading')
                    .toggleClass('hiddenElement', value==0);
            }
        }).error(function() {
            printDynamicInputError(vufindString.error);
        });    
    }
    
    // Add list helper
    function dynamicAddList(listName, listId) {
        var $template = $('#sidebarFavoritesLists li.sidebarListTemplate').clone()
            .removeClass('hiddenElement sidebarListTemplate');
        // Set list text
        var $listLink = $template.find('a');
        var linkHtml = listName + ' ' + $listLink.html();
        $listLink.attr('href', $listLink.attr('href')+listId).html(linkHtml);
        $template.appendTo($('#sidebarFavoritesLists ul'));
    }

    // Title change listener
    $('.myResearchTitle h2').bind("DOMSubtreeModified",function(){
        $('.sidebarListTitle').text($(this).text());
    });
    
    // Entry description listener
    $('.listEntryDescription .transform').bind("DOMSubtreeModified",function(){
        $(this).prev('.subject').toggleClass('hiddenElement', $(this).hasClass('placeholder'));
    });
    
    // Hover styles 
    $('.dynamicInput a').mouseenter(function() {
        var cl = $(this).is('.edit') ? 'hover indicate' : 'hover';
        $(this).closest('.dynamicInput').addClass(cl);
    }).mouseleave(function() {
        $(this).closest('.dynamicInput').removeClass('hover indicate')
    });
    
    // Errors
    function printDynamicInputError(msg) {
        $('.resultHead .messages, .resultHead .error').removeClass('hiddenElement');
        $('resultHead .error').html(msg);
        $('html, body').animate({
            scrollTop: $('.resultHead').offset().top - 20
        }, 100);
    }
    function clearDynamicInputError() {
        $('.resultHead .messages, .resultHead .error').addClass('hiddenElement');
    }
}
