$(document).ready(function() {
    $(".fancybox-trigger").click(function(e) {
        e.preventDefault();
        $("a[href='" + $(this).attr('href') + "']").eq(0).click();
    });

    $('.fancybox').fancybox({ 
        nextEffect: 'none', 
        prevEffect: 'none',
        autoSize: true,
        beforeLoad: function() {
            this.title = '&nbsp;';
        },
        
        afterLoad   : function() {
            $('.fancybox-skin').fadeTo(0, 0);

            var id = $(this.element).data('id');
            var listNotes = $(this.element).data('notes');

            $.ajax({
                dataType: 'json',
                data: {id:id},
                url: path + '/AJAX/JSON?method=getRecordData',
                success: function(response) {
                    if (response.status == 'OK') {
                        var data = response.data;

                        var dates = data.dates;
                        var photoTitle = data.title;

                        if (typeof(photoTitle) != 'undefined' && photoTitle.length > 100) {
                            photoTitle = photoTitle.substr(0,100) + '&hellip;';
                        }
  
                        var author = data.author;
                        var building = '';
                        if (!author) {
                            building = data.building;
                        }
                        var url = data.url;
                        if ((typeof(dates) != 'undefined' && dates != '') && (author != '')) {
                            var dot = '. ';
                        }
                        else {
                            var dot = '';
                        }
                        
                        var title = 
                            '<h3 class="fancyTitle">' + photoTitle + '</h3>';
                        
                        title 
                            += '<div class="fancyAuthorAndDates">' 
                            + (typeof(author) != 'undefined' ? author + dot : '') 
                            + (typeof(dates) != 'undefined' ? dates : '') 
                            + '</div>'
                        ;
                        
                        if (typeof(building) != 'undefined') {
                            title += '<div class="fancyBuilding">' + building + '</div>';
                        }
                        
                        
                        if (listNotes) {
                            title += '<div class="fancyNotes"><p class="heading">' + trListNotes + ':</p>';
                            notes = $('<div/>').text(listNotes).html(); // escape
                            title += '<p class="text">' + notes + '</p></div>';
                        }
                        
                        title += '<div class="fancyLink"><a href="' + url + '">'
                            + trToRecord
                            + '</a></div>'
                        ;                                              

                        if (typeof(data.rights) != 'undefined') {
                            var copyright = false;
                            var copyrightLink = false;
                            var copyrightDesc = false;
                            if (typeof(data.rights.copyright) != 'undefined') {
                                copyright = unescape(data.rights.copyright);
                            }
                            if (typeof(data.rights.link) != 'undefined') {
                                copyrightLink = unescape(data.rights.link);
                            }
                            if (typeof(data.rights.description) != 'undefined') {
                                copyrightDesc = data.rights.description;
                            }

                            title += '<div class="fancyImageRights"><div class="rights"><span>' + trImageRights + ':</span> ';
                            if (copyrightLink) {
                                title += '<a target="_blank" href="' + copyrightLink + '">';
                            }
                            if (copyright) {
                                title += copyright;
                            }
                            if (copyrightLink) {
                                title += '</a>';
                            }
                            title += '</div>';

                            if (copyrightDesc) {
                                desc = '';
                                $.each(copyrightDesc, function(ind, p) {
                                    if (ind > 0) {
                                        desc += '</p>';
                                    }
                                    desc += '<p>' + p;
                                });

                                if (copyrightLink && !copyright) {
                                    desc += ' <a href="' + copyrightLink + '">' + (copyright ? copyright : trSeeAlso) + '</a>';
                                }

                                desc += '</p>';
                                
                                title += '<div class="moreLink copyrightLink"><a data-mode="1" href="#">' + trMore + '</a></div>';
                                title += '<div class="copyright">' + desc + '</div>';
                                title += '<div class="lessLink copyrightLink"><a data-mode="0" href="#">' + trLess + '</a></div>';
                            }
                        }

                        $('.fancybox-title').html(title);
                        $.fancybox.update();
                        $('.fancybox-skin').delay(200).fadeTo(100, 1);

                        $(".fancyImageRights .copyrightLink a").on("click", function() {
                            var mode = $(this).data("mode") == 1;                                      
                            
                            var moreLink = $(".fancyImageRights .moreLink");
                            var lessLink = $(".fancyImageRights .lessLink");
                            
                            moreLink.toggle(!mode);
                            lessLink.toggle(mode);
                            
                            $(".fancyImageRights .copyright").toggle(mode);
                            return false;                                      
                        });

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
                    }
                }
            });
        },
        helpers : {
            title: {type: 'inside'}                            
        }
    });
});
