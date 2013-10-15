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