function customInit() {}

$(document).ready(function() {
    initCarousel();
    initInfoBox();
    initScrollBackground();
    initHomeBackgroundInfo();
});

// Front page content carousel
function initCarousel() {
    var topPosition = $('#carousel .pickup-content').css('top');
    $(window).resize(function () { 
        $('#carousel .pickup-content').removeAttr('style');
        topPosition = $('#carousel .pickup-content').css('top');  
    });    

    var ribbonH = $('#carousel h2.ribbon').height();
    $("#carousel").slides({
         play: 9000,
         pause: 9000,
         hoverPause: true
    });
    if ($("#carousel .slide").length > 1)
    $("#carousel a.prev, #carousel a.next").removeClass('disabled');


    function slideOver() {
        pickupHeight = $(this).children('.pickup-content').height();
        imgHeight = $(this).children('img').height();
        $(this).children('.pickup-content').stop().animate({top:imgHeight-pickupHeight +1}, 300).addClass('open');
        if ($(this).index() == 0) $('#carousel h2.ribbon').stop()
            .animate({height:0,padding:'0 7px',opacity:0}, 400);
    }

    function slideOut() {
        $(this).children('.pickup-content').stop().delay(100).animate({top:topPosition}, 300, function() {$(this).removeClass('open');});
        if ($(this).index() == 0) $('#carousel h2.ribbon').stop().delay(100)
            .animate({height:ribbonH,padding:'5px 7px',opacity:1}, 100);
    }

    $('#carousel li').hover(slideOver, slideOut);
    $('#carousel li').click(function() {
        var href = $(this).find('a').attr('href');
        window.location.href = href;
    });
}

// Home page header info box
function initInfoBox() {
    
    $('.toggleBox').click(function() {
        toggleInfoBox();
    });
}

function toggleInfoBox() {
    var box = $('.headerInfoBox');
    box.toggleClass('visible');
    var boxWidth = box.hasClass('visible') ? box.parent().width() : 25;
    var boxHeight = box.hasClass('visible') ? $('.infoBoxText').height() +30 : 25;
    $('.openInfoBox, .closeInfoBox, .infoBoxText').stop(true, true).toggle();
    box.stop(true, true).animate({ width: boxWidth, height: boxHeight}, 200);
    $('.infoBoxText').stop(true, true).vToggle().fadeToggle(300);
};

// Scroll the background (parallax) 
function initScrollBackground() {
  if (!isTouchDevice() && $('#header').height() > 400) {
   var backgroundheight = $('#header').height()+30;
   $(window).scroll(function () { 
   	 scrollTop = $(document).scrollTop();
   	    if ($(document).scrollTop() <= backgroundheight) {
   	 		$('.backgroundContainer').css('background-position', '50% '+scrollTop*0.5+'px');
   	    }
     });
  }
}

function initHomeBackgroundInfo() {
    var bgNumber = $('.backgroundContainer').attr('class').split(' ')[1].split('-')[1]
        $headerInfoBox = $('#header .infoBoxText');
    
    if ($headerInfoBox.length && typeof bgNumber !== 'undefined') {
        $.get(path+'/Content/headertexts', function(data) {
            var texts = $(data).find('#headerTexts > div');
            if (texts.length > 0) {
                var content = texts.eq(bgNumber - 1).html();
                $headerInfoBox.html(content);
            }
        });
    }
}
