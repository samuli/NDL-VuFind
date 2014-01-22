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
    
    // Add new favorite list functions
    $('#listAdd').click(function(e){
        e.preventDefault();
            toggleListAdd();
            $('#listAddForm #list_title').focus();
        
    });
        
    function toggleListAdd() {
        $('#listAdd').toggleClass('hidden');
        $('#listAddForm').toggleClass('hidden');
          
    }
    
    $('html').click(function() {
        if (!$('#listAddForm').hasClass('hidden')) {
            toggleListAdd();
            $('#listAddForm #list_title').val('');
        }
    });

    $('#listAdd, #listAddForm').click(function(event){
        event.stopPropagation();
    });
}
