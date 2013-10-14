$(document).ready(function() {
    $(".fancybox-trigger").click(function(e) {
        e.preventDefault();
        $("a[href='" + $(this).attr('href') + "']").eq(0).click();
    });

    $('.fancybox').fancybox({ nextEffect: 'fade', 
                              prevEffect: 'fade',
                              afterLoad   : function() {
                                  var dates = $(this.element).data('dates');
                                  var photoTitle = $(this.element).data('title');
                                  var building = $(this.element).data('building');
                                  var author = $(this.element).data('author');
                                  var url = $(this.element).data('url');
                                  var linkText = $(this.element).data('linktext');
                                  this.title = '<h3 class="fancyTitle">'+photoTitle+'</h3>'
                                               +'<div class="fancyAuthor">'+author+'</div>'
                                               +'<div class="fancyBuilding">'+building+'</div>'
                                               +'<div class="fancyDates">'+dates+'</div>'
                                               +'<div class="fancyLink"><a href="'+url+'">'+linkText+'</a></div>';
                                               
                              },
                              helpers : {
                                  title: {type: 'inside'}                            
                              }
                    });
});

function launchFancybox(el) {
    var hrefs = new Array();
    hrefs.push($(el).attr('href').replace('&index=0', ''));
    var group = $(el).attr('rel');
    var dates = $(el).data('dates');
    var photoTitle = $(el).data('title');
    var building = $(el).data('building');
    var author = $(el).data('author');
    var url = $(el).data('url');
    var linkText = $(el).data('linktext')
    $('a[rel="'+group+'"]').each(function(){
        var href = $(this).attr('href').replace('&index=0', '');
        if ($.inArray(href, hrefs) === -1) {
            hrefs.push(href);
        }
    });
    $.fancybox.open(hrefs, 
                    {   type: 'image', 
                        nextEffect: 'fade', 
                        prevEffect: 'fade',
                        afterLoad   : function() {
                            this.title = '<h3 class="fancyTitle">'+photoTitle+'</h3>'
                                             +'<div class="fancyAuthor">'+author+'</div>'
                                             +'<div class="fancyBuilding">'+building+'</div>'
                                             +'<div class="fancyDates">'+dates+'</div>'
                                             +'<div class="fancyLink"><a href="'+url+'">'+linkText+'</a></div>';
                                         
                        },
                        helpers : {
                            title: {type: 'inside'}                            
                        }
                    }
    );
}