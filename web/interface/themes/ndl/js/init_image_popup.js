$(document).ready(function() {
    $(".imagePopup-trigger").click(function(e) {
        e.preventDefault();
        $(this).closest('.result').find('.imagelinks a').eq(0).click();
     });
});

$(document).ready(function() {
  $('.imagePopup').magnificPopup({
      type:'ajax',      
      //tLoading: '',
      callbacks: {
          ajaxContentAdded: function() {
              $(".imagePopupHolder .image img").one("load", function() {
                  resizeImagePopupContent();
               }).each(function() {
                  if(this.complete) {
                      $(this).load();
                  }
              });

              var notesHolder = $(".imagePopupHolder .content .listNotes");
              notesHolder.hide();
              
              var magnificPopup = $.magnificPopup.instance;
              var src = magnificPopup.currItem.src;

              var pattern = /id=([^&]*)/
              var res = pattern.exec(src);
              if (res && res.length > 1) {
                  var id = "record" + unescape(res[1]);
                  id = id.replace(/\+/g, "\\\+");
                  id = id.replace(/\./g, "\\\.");
                  id = id.replace(/:/g, "\\:");

                  var obj = $("#" + id);

                  var listNotes = obj.data("notes");
                  if (typeof(listNotes) != "undefined") {
                      notesHolder.show();
                      notesHolder.find(".text").html(listNotes);
                  }
              }

              $(".imagePopupHolder .imageRights .copyrightLink a").on("click", function() {
                  var mode = $(this).data("mode") == 1;                                      
                  
                  var moreLink = $(".imagePopupHolder .imageRights .moreLink");
                  var lessLink = $(".imagePopupHolder .imageRights .lessLink");
                  
                  moreLink.toggle(!mode);
                  lessLink.toggle(mode);
                  
                  $(".imagePopupHolder .imageRights .copyright").toggle(mode);
                  resizeImagePopupContent();

                  return false;                                      
              });
          },
          resize: function() {
              resizeImagePopupContent();
          }
      },
      gallery: {
          enabled: true,
          preload: [0,2],
          navigateByImgClick: true,
          arrowMarkup: '<button title="%title%" type="button" class="mfp-arrow mfp-arrow-%dir%"></button>', // markup of an arrow button
          tPrev: trPrev,
          tNext: trNext,
          tCounter: ''
      }
  });
});


function resizeImagePopupContent() {
    var content = $('.imagePopupHolder .content');
    content.css("height", "auto");
    
    if ($(window).width() > 800) {
        content.height(Math.max(content.height(), $('.imagePopupHolder .image').height()));                  
    }
}
