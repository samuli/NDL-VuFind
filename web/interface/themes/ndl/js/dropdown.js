// Original idea by Janko Jovanovic
// http://www.jankoatwarpspeed.com/post/2009/07/28/reinventing-drop-down-with-css-jquery.aspx
//
// Modifications by NDL

$(document).ready(function() {
    createDropdowns();
    initDropdowns();
});


function initDropdowns() {
    // Hide dropdown when clicking outside
    $(document).bind('click', function(e) {
        $(".dropdown dd ul").hide();

        // send menuClose events
        $(".dropdown").each(function(ind,obj) {
            if ($(this).data("menuOpen") === 1) {
                $(obj).trigger("menuClose");
            }
            $(obj).data("menuOpen", 0);
        });        
    });
    
    $(".dropdown dt a").bind('click', function(e) {
        var dropdown = $(this).closest('dl.dropdown');

        dropdown.find('dd ul').fadeToggle({duration:100});

        // send menuOpen/menuClose events
        var parent = $(this).parent().parent();
        var menuOpen = parent.data("menuOpen");
        
        var event = !(menuOpen === 1) ? 'menuOpen' : 'menuClose';
        if (typeof parent[event]) {
            parent.trigger(event);
        }
        // save state
        parent.data("menuOpen", menuOpen === 1 ? 0 : 1);
        
        return false;
    });

    $(".dropdown dd ul li a").bind('click', function(e) {
        var dropdown = $(this).closest('dl.dropdown');
        var text = $(this).html();
        dropdown.find('dt a').html(text);
        dropdown.find('dd ul').fadeOut(100);
        
        // Get id of the hidden select element
        var source = dropdown.next('select');
        
        source.find('option').removeAttr('selected');
        source.find('option[value="'+$(this).find("span.value").text()+'"]').attr('selected', 'selected').change();

        e.preventDefault();
    });
    $(".dropdown").data("menuOpen", 0);    
};

// Function for creating dropdowns
function createDropdowns(){
    var counter = 0;
    $('.styledDropdowns, .searchForm_styled, .jumpMenu, .resultOptionLimit select').not('.stylingDone').each(function() { 
        var source = $(this);
        var selected = source.find("option:selected");
        var options = $("option", source);
        var idName = $(this).attr("id");
        var target = 'styled_'+idName+counter;
        counter++;

        $(this).hide().addClass('stylingDone').before('<dl id="'+target+'" class="dropdown ' + idName + '"></dl>');
        $('#'+target).append('<dt><a href="#">' + selected.text() + 
    '<span class="value">' + selected.val() + 
    '</span></a></dt>');
        $("#"+target).append('<dd><ul></ul></dd>');

        options.each(function(){
            if ($(this).text()) {
                $("#"+target+" dd ul").append('<li><a href="#" class="big">' + 
                    $(this).text() + '<span class="value">' + 
                    $(this).val() + '</span></a></li>');
            } else {
                $("#"+target+" dd ul").append('<li style="height: 2px"><hr/></li>');
            }
        });
    })
}
