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
    $(document).on('click touchstart', function(e) {
        $(".dropdown").trigger("toggle", [false]);
    });
    
    $(".dropdown dt a").not(".initDone").on('click touchstart', function(e) {
        $(".dropdown").each(function(ind,o) { 
            var parObj = $(e.target).parent().parent();
            if ($(this).get(0) != parObj.get(0)) {
                $(this).trigger("toggle", [false]);
            }
        });
        
        var dropdown = $(this).closest('dl.dropdown');
        dropdown.trigger("toggle", [!dropdown.data("menuOpen")]);

        // prevent event from bubbling to document.click
        return false;
    });

    $(".dropdown dd ul li a").not(".initDone").on('click touchstart', function(e) {
        var dropdown = $(this).closest('dl.dropdown');
        var text = $(this).html();
        dropdown.find('dt a').html(text);
        dropdown.find('dd ul').fadeOut(100);
        

        dropdown.trigger("truncate");

        // Get id of the hidden select element
        var source = dropdown.next('select');
        
        source.find('option').removeAttr('selected');
        source.find('option[value="'+$(this).find("span.value").text()+'"]').attr('selected', 'selected').change();

        e.preventDefault();
    });

    $(".dropdown").not(".initDone").data("menuOpen", 0);

    $(".dropdown").not(".initDone").on("toggle", function(e, mode) {
        var currentMode = $(this).data("menuOpen");
        if (currentMode == mode) {
          return;
        }

        var menu = $(this).find('dd ul');
        menu.stop().fadeTo(100, mode ? 1 : 0, function() { if (!mode) { menu.hide(); } });

        // send menuOpen/menuClose events
        var event = mode ? 'menuOpen' : 'menuClose';
        $(this).trigger(event);

        // save state
        $(this).data("menuOpen", mode ? 1 : 0);
    });

    $(".dropdown").not(".initDone").on("truncate", function(e) {
        var a = $(this).find('dt a');
        var txt = a.html();
        if (txt) {
            // link text is followed by a hidden <span> with the actual url, ignore this
            txt = txt.substring(0,txt.indexOf("<span"));
            // cut away already added &hellip;
            var pos = txt.indexOf("…");
            if (pos != -1) {
                txt = txt.substring(0,pos);
            }
            var maxLen = $(this).attr("truncateLength");    
            if (maxLen) {
                if (txt.length > maxLen) {
                    txt = txt.substring(0,maxLen-3) + "&hellip;";
                    a.html(txt);
                }
            }
        }
    });


    $(".dropdown").trigger("truncate");
    $(".dropdown dt a").removeClass("initDone").addClass("initDone");
    $(".dropdown dd ul li a").removeClass("initDone").addClass("initDone");
    $(".dropdown").removeClass("initDone").addClass("initDone");
}

// Function for creating dropdowns
function createDropdowns(){
    var counter = 0;
    $('.styledDropdowns, .searchForm_styled, .jumpMenu, .jumpMenuURL, .resultOptionLimit select').not('.stylingDone').each(function() { 
        var source = $(this);
        var selected = source.find("option:selected");
        var options = $("option", source);
        var idName = $(this).attr("id");
        var target = 'styled_'+idName+counter;
        counter++;
        
        var truncateLength = $(this).attr("truncateLength");
        var html = '<dl id="'+target+'" class="dropdown ' + idName + '"';
        if (truncateLength) {
            html += ' truncateLength="' + truncateLength + '"';
        }
        html += '></dl>';
        $(this).hide().addClass('stylingDone').before(html);

        var txt = selected.text();
        $('#'+target).append('<dt><a href="#">' + txt + 
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
