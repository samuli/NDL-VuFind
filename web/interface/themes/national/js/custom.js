function customInit() {
    
    // Load background as soon as backgroundContainer is ready.
    $('.backgroundContainer').ready(function() {
        var bgChanged;
        if (typeof bgChanged === 'undefined') bgChanged = false;
        if (bgChanged === false) initBgSwitcher('/Content/headertexts','.backgroundContainer', userLang);
    });
}

$(document).ready(function() {
    initCarousel();
    initInfoBox();
});

// Load random header background and related info text
function initBgSwitcher(source, target, lang) {
    bgChanged = true;
    var randomNumber, content;
    
    // If cookies not set
    if ($.cookie('bgNumber') === null || $.cookie('infoText') === null || $.cookie('userLang') === null || $.cookie('userLang') != lang) {
        $.get(path+source, function(data) {
            // Get related info text from source
            texts = $(data).find('#headerTexts > div');
            if (texts.length > 0) {

                // Get random number from 0 to the number of elements found - 1
                randomNumber = Math.floor((Math.random()*texts.length)) + 1;
                content = texts.eq(randomNumber - 1).html();
                
                var expire = new Date();
                var minutes = 30;
                expire.setTime(expire.getTime() + (minutes * 60 * 1000));
                $.cookie('bgNumber', randomNumber, { expires: expire });
                $.cookie('infoText', content, { expires: expire });
                $.cookie('userLang', lang, { expires: expire });
                hide = true;
                fadeSpeed = 1000;

                performBgSwitch(target, randomNumber, content);
            }
        });
    }
    
    else {
        randomNumber = $.cookie('bgNumber');
        content = $.cookie('infoText');
        
        performBgSwitch(target, randomNumber, content);
    }


}

// Change background and info text
function performBgSwitch(target, randomNumber, content) {
    var fadeSpeed = 0;
    bgurl = "url('"+path+"/interface/themes/national/images/header_background_"
        + randomNumber+".jpg')";
    $(target).hide().css("background-image", bgurl).fadeIn(fadeSpeed);

    // Set infotext
    $('#header .infoBoxText').html(content); 
}

// Front page content carousel
function initCarousel() {
    var isVisible = $('#content-carousel').css('display') == 'none' ? false : true;
    if (isVisible) {
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
            $(this).children('.pickup-content').stop().animate({top:imgHeight-pickupHeight +1}, 300);
            if ($(this).index() == 0) $('#carousel h2.ribbon').stop()
                .animate({height:0,padding:'0 7px',opacity:0}, 400);
        }

        function slideOut() {
            $(this).children('.pickup-content').stop().delay(100).animate({top:topPosition}, 300);
            if ($(this).index() == 0) $('#carousel h2.ribbon').stop().delay(100)
                .animate({height:ribbonH,padding:'5px 7px',opacity:1}, 100);
        }

        $('#carousel li').hover(slideOver, slideOut);
        $('#carousel li').click(function() {
            var href = $(this).find('a').attr('href');
            window.location.href = href;
        })
    }
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

