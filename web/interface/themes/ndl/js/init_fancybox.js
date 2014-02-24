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
                                  var author = $(this.element).data('author');
                                  var building = '';
                                  if (!author) {
                                    building = $(this.element).data('building');
                                  }
                                  var url = $(this.element).data('url');   
                                  if ((dates != '') && (author != '')) {
                                  	var dot = '. ';
                                  }
                                  else {
                                  	var dot = '';
                                  }
                                  if ($(this.element).data('linktext')) {
                                      var linkText = $(this.element).data('linktext');
                                      this.title = '<h3 class="fancyTitle">'+photoTitle+'</h3>'
                                                   +'<div class="fancyAuthorAndDates">'+author+dot+dates+'</div>'
                                                   +'<div class="fancyBuilding">'+building+'</div>'
                                                   +'<div class="fancyLink"><a href="'+url+'">'+linkText+'</a></div>';
                                  } else {
                                      this.title = '<h3 class="fancyTitle">'+photoTitle+'</h3>'
                                                   +'<div class="fancyAuthorAndDates">'+author+dot+dates+'</div>'
                                                   +'<div class="fancyBuilding">'+building+'</div>';
                                  }    
                                               
                              },
                              helpers : {
                                  title: {type: 'inside'}                            
                              }
                    });
});