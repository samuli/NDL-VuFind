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

                                  this.title = '<h3 class="fancyTitle">'+photoTitle+'</h3>'
                                      +'<div class="fancyAuthorAndDates">'+author+dot+dates+'</div>'
                                      +'<div class="fancyBuilding">'+building+'</div>';

                                  if ($(this.element).data('notes')) {
                                      this.title += '<div class="fancyNotes"><p class="heading">' + trListNotes + ':</p>';
                                      this.title += '<p class="text">' + $(this.element).data('notes') + '</p></div>';
                                  }
                                  
                                  if ($(this.element).data('linktext')) {
                                      this.title += '<div class="fancyLink"><a href="'+url+'">'
                                          + $(this.element).data('linktext') 
                                          + '</a></div>'
                                      ;
                                  }

                                  // for screen readers
                                  if (window.location.href.toLowerCase().indexOf("&lng=en-gb") > -1) {
                                      var screenReaderMsg = "Image opened";
                                  }
                                  else if (window.location.href.toLowerCase().indexOf("&lng=sv") > -1) {
                                      var screenReaderMsg = "Bilden öppnas";
                                  }
                                  else {
                                      var screenReaderMsg = "Kuva avattu";
                                  }
                                  $('.fancybox-wrap').prepend('<span class="offscreen">'+screenReaderMsg+'</span>');
                              },
                              helpers : {
                                  title: {type: 'inside'}                            
                              }
                    });
});
