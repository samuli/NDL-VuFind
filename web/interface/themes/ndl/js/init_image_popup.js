$(document).ready(function() {
    $(".imagePopup-trigger").click(function(e) {
         e.preventDefault();
         $("a[href='" + $(this).attr('href') + "']").eq(0).click();
     });
});

$(document).ready(function() {
  $('.imagePopup').magnificPopup({
      type:'ajax',      
      //tLoading: '',
      callbacks: {
          ajaxContentAdded: function() {
              var notesHolder = $(".imagePopupHolder .content .listNotes");
              notesHolder.hide();
              
              
              var magnificPopup = $.magnificPopup.instance;
              var src = magnificPopup.currItem.src;

              console.log("src: " + src);

              var pattern = /id=([^&]*)/
              var res = pattern.exec(src);
              if (res && res.length > 1) {
                  var id = "record" + unescape(res[1]);
                  id = id.replace(/\+/g, "\\\+");
                  id = id.replace(/\./g, "\\\.");
                  id = id.replace(/:/g, "\\:");

                  console.log("id: " + id);

                  var obj = $("#" + id);
                  console.log("obj: %o", obj.html);

                  var listNotes = obj.data("notes");
                  console.log("notes: " + listNotes);
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
                  return false;                                      
              });
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

