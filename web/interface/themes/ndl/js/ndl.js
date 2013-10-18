/**
 * Initialize NDL theme specific functions
 */

$(document).ready(function() {
    initHeaderMenu();
    initContentMenu();
    initSidebarFacets();
    initDateVis();
    initFeedbackScroll();
    initFixedLimitSearch();
    initMetaLibLoadingIndicator();
    initCustomEyeCandy();
    initScrollRecord();
    initScrollMenu();
});

// Header menu
function initHeaderMenu() {
    // Catalog account -dropdown action is handled by the surrounding <form>
    // Persona logout is handled in persona.js
    $("#headerMenu .dropdown").not(".catalogAccount").on("menuClick", function(e,url) {
        if (url && url != "") { 
            document.location = url;
        }
    });
}

// Helper function: visibility toggler
jQuery.fn.vToggle = function() {
    return this.css('visibility', function(i, visibility) {
        return (visibility == 'visible') ? 'hidden' : 'visible';
    });
};

// Date range selector 
function initDateVis() {
    if (typeof(loadVisNow) == "function") { 
        // Load date visualizer
        detector = $('.resultDates .content');
        if (detector.length > 0)
            loadVisNow();
            prevWidth = detector.width();
            $(window).resize(function(){

                // Refresh on screen resize
                if(detector.width()!=prevWidth && typeof loadVisNow != 'undefined'){
                    prevWidth = detector.width();

                    loadVisNow();
            }

        });

        $('.dateVisHandle').click(function() {
            showDateVis();
        });

        function showDateVis() {
            var dateVis = $('.resultDates');

            var dateVisHeight = !dateVis.hasClass('expanded') ? 110 : 0;
           dateVis.stop(true, true).animate({ height: dateVisHeight}, 200, function() {
               dateVis.toggleClass('expanded');

           });
           $('.resultDatesHeader').toggleClass('expanded');
               $('div.dateVisHandle').not('.visible').fadeIn(300, function() {
                   $('div.dateVisHandle.visible').fadeOut(300);
                   $('div.dateVisHandle').toggleClass('visible');
                   $('.dateVisHelp').fadeToggle(200);
               });
        }
    }
}

//Check if user is viewing single record or search results and autoscroll to wanted location
function initScrollRecord() {
	var identifier = window.location.hash;
	if (($('div').hasClass('resultHeader') === true) && (identifier === "") && ($(window).scrollTop() === 0)) {
		$('html, body').animate({
      	 		  scrollTop: $("#searchFormHeader").offset().top - 10
    	}, 200);
	}
	if (($('div').hasClass('resultLinks') === true) && ($(window).width() < 721)) {
    	    window.location.hash = "results";
	}
} 


// Content pages menu 
function initContentMenu() {
    if ( $(".module-Content .main .menu").length > 0 ) {
        var menu = '<div class="content"><div class="grid_6"><ul>';

        $('.module-Content .main h2').each(function() {
            var text = $(this).text(); 
            menu += '<li>'+text+'</li>';
        });
        menu += '</ul></div></div>';

        $('.module-Content .main .menu').append(menu);
        $('.module-Content .main .menu li').click(function(event){		
            $('html,body').animate({
                scrollTop:$('h2:contains('+$(this).text()+')').offset().top - 10
            }, 500);
        });
    }
}

// Sidebar facets visibility toggler
function initSidebarFacets() {
    $('.sidegroup dl').each(function() {
        
        // Determine facet use by finding the indicator image
        if ($(this).find('img[alt="Selected"]').length > 0) {
                $(this).addClass('active');
        }

        // Mark dl collapsible
        $(this).addClass('collapsible');
    });
    
    // Toggle facet visibility by clicking its title
    $('.sidegroup dt').click(function() {
        
        // Get the facet container
        var parentDl = $(this).parent('dl');
        
        if (parentDl.hasClass('hierarcicalFacet')) {
            var target = parentDl.next('div.dynatree-facet');  
            var id = target.attr('id').substr('facet_'.length);
            enableDynatree(target, id, fullPath, action);
            parentDl.removeClass('hierarcicalFacet');
            parentDl.toggleClass('collapsed open');
        } else {
            // Do nothing if facet selected
            if (parentDl.find('img[alt="Selected"]').length > 0 || parentDl.hasClass('active')) return false;

            // Make sure this facet has options
            if (parentDl.find('dd').length > 0) {
                if (!parentDl.hasClass('timeline')) {
                // Slide them
                parentDl.children('dd').slideToggle(100);
                } else parentDl.children('dd').hide();

                // If user has clicked "more", hide the additional facets too
                if (!parentDl.next('dl').hasClass('offscreen') && parentDl.hasClass('open')) {
                    parentDl.next('dl[id*="Hidden"]').addClass('offscreen');
                    parentDl.find('dd[id*="more"]').hide();
                }
                
                // Finally, mark this facet container opened
                parentDl.toggleClass('open collapsed');
                if (!parentDl.hasClass('collapsed')) {
                    parentDl.removeClass('timeline');
                    if (parentDl.hasClass('year')) {
                        moveMainYearForm(parentDl);
                    }
                }
            }
            // Extend to dynamic facets (without dd children)
            else {
                parentDl.nextAll('div.dynatree-facet:first').slideToggle(100);
                parentDl.toggleClass('collapsed open');
            }
        }        
    });
    
    // Add clickable timeline icon function
    $('.timelineview').click(function(e) {
        e.stopPropagation();
        var parentDl = $(this).closest('dl.narrowList');
        if (!parentDl.hasClass('collapsed')) {
            parentDl.find('> dt').trigger('click');
        }
        parentDl.toggleClass('timeline');
        moveMainYearForm(parentDl);
	});
    
    // Keep main year form visible
    moveMainYearForm = function(el) {
        if (!el.hasClass('timeline')) {
            $('.mainYearForm').appendTo('.mainYearFormContainer1');
        } else {
            $('.mainYearForm').appendTo('.mainYearFormContainer2');
        }
    }
    
    $('.resultDates').click(function(e) {
        e.stopPropagation();
    })
    
    // Timeline search functionality
    $(".mainYearForm").submit(function(e){
        e.preventDefault();
        // Get dates, build query
        var from = $('.mainYearForm #mainYearFrom').val(),
            to = $('.mainYearForm #mainYearTo').val(),
            action = $('.mainYearForm').attr('action');
        if (action.indexOf("?") < 0) {
            action += '?'; // No other parameters, therefore add ?
        } else {
            action += '&'; // Other parameters found, therefore add &
        }
        var query = action + 'sdaterange[]=search_sdaterange_mv&';
                
        // Require numerical values
        if (!isNaN(from) && !isNaN(to)) {
            if (from == '' && to == '') { // both dates empty; use removal url
                query = action;
            } else if (from == '') { // only start date set
                query += 'search_sdaterange_mvto='+padZeros(to);
            } else if (to == '')  { // only end date set
                query += 'search_sdaterange_mvfrom='+padZeros(from);
            } else { // both dates set
                query += 'search_sdaterange_mvfrom='+padZeros(from)+'&search_sdaterange_mvto='+padZeros(to);
            }
            
            // Perform the new search
            window.location = query;   
        }
    });

    // PCI Timeline search functionality
    $(".mainYearFormPCI").submit(function(e){
        e.preventDefault();
        // Get dates, build query
        var from = $('.mainYearFormPCI #mainYearFromPCI').val(),
            to = $('.mainYearFormPCI #mainYearToPCI').val(),
            action = $('.mainYearFormPCI').attr('action');
        if (action.indexOf("?") < 0) {
            action += '?'; // No other parameters, therefore add ?
        } else {
            action += '&'; // Other parameters found, therefore add &
        }
        var query = action + 'filter[]=creationdate%3A';
                
        // Require numerical values
        if (!isNaN(from) && !isNaN(to)) {
            if (from == '' && to == '') { // both dates empty; use removal url
                query = action;
            } else if (from == '') { // only end date set
                query += '"'+padZeros(to)+'"';
            } else if (to == '')  { // only start date set
                query += '"'+padZeros(from)+'"';
            } else { // both dates set
                query += '"['+padZeros(from)+' TO '+padZeros(to)+']'+'"';
            }
            query += '&view=list&limit=10';

            // Perform the new search
            window.location = query;   
        }
    });


}

// Scroll the feedback button 
function initFeedbackScroll() {
   var navHeight = $('#nav').height();
   var feedbackButton = $('a.feedbackButton');
   $(window).scroll(function () { 
      if ($(document).scrollTop() >= navHeight) {
          feedbackButton.addClass('fixed');
      }
      else feedbackButton.removeClass('fixed');
   });
}

// Scroll the limit search button
// TODO: Test with Android devices and iOS < 5.0
function initFixedLimitSearch() {
   if ($('#sidebarFacets').length > 0) {
        var sidebarPos = $('#sidebarFacets').offset().top;
        var sidegroupTitleHeight = $('#sidebarFacets > .sidegroup:first-child > h4:first-child').height();
        var jumpToFacets = $('#sidebarFacets .jumpToFacets')
        
        $(window).scroll(function () { 
           sidebarPos = $('#sidebarFacets').offset().top; 
           if ($(document).scrollTop() + $(window).height() >= sidebarPos - 100) {
               jumpToFacets.fadeOut(200);
           }
           else jumpToFacets.fadeIn(200);
        });

        jumpToFacets.click( function() {
            $('html,body').animate({
             scrollTop:sidebarPos-5
                 }, 200);
        })
   }
   
}

// Padding function
function padZeros(number, length) {
    if (typeof length == 'undefined') {
        length = 4;
    }
    // Room for any leading negative sign
    var negative = false;
    if (number < 0) {
        negative = true;
        number = Math.abs(number);
    }
    var str = '' + number;
    while (str.length < length) {
        str = '0' + str;
    }
    return (negative ? '-' : '') + str;
}

// Metalib loading indicator
function initMetaLibLoadingIndicator() {
    $('.searchformMetaLib #searchForm_searchButton').click(function() {
        $('.searchFormWrapper .clear_input').addClass('metaLibLoading');
        $('#searchForm_input').css('color', '#aaa');
    });
}

// Custom jQuery effects
function initCustomEyeCandy() {
    
    // Slide record page thumbnail enlarge button up/down
    $('#thumbnail_link').hover(function() {
        $(this).children('span').stop().delay(100).animate({top:0}, 150);
    }, function() {
        $(this).children('span').stop().delay(100).animate({top:-50}, 150);
    });
}

// Toggle fixed menu bar
 function initScrollMenu() {
   if (document.querySelectorAll('div.menu').length >= 1) {
	$(window).on('scroll', function () {
		var menuSize	=	($(window).height()) - ($('.menu .grid_6').outerHeight()),
        scrollTop     = $(document).scrollTop(),
        elementOffset = $('.menu .content').offset().top,
        distance      = (elementOffset - scrollTop);
       if (distance < 0) {
         $('.menu .grid_6').addClass('fixed');
       }
 	   if ((distance > 0) || (menuSize < 0)) {
         $('.menu .grid_6').removeClass('fixed');
       }
    });
   }
 }


