/**
 * Functions and event handlers specific to record pages.
 */
$(document).ready(function(){
    // register the record comment form to be submitted via AJAX
    registerAjaxCommentRecord();

    // bind click action to edit comment link
    $('a.editRecordComment').live('click', function(e){
        e.preventDefault();
        $('#formContainer').show();
        var id = this.id.substr('recordCommentEdit'.length);
        $('input[name="commentId"]').val(id);
        var comment = $('#comment' + id);
        comment.css('font-style', 'italic');
        $('textarea#comment').val(comment.text());
        
        var rating = $('#raty_' + id);
        if (rating.length) {
            $('#starRating').raty('score', rating.attr('data-score'));
            $('#formContainer').find("input[type='reset']").unbind('click').click(function() { $('#formContainer').hide(); });
        } else {
            $('#formContainer').find("input[type='reset']").unbind('click').click(function() { $("#commentRecord input[name='commentId']").val(0); });
        }
        
        $('html, body').animate({
            scrollTop: $("#comment").offset().top
        }, 500);
    });
    
    // attach click event to the report inappropriate link
    $('a.inappropriateRecordComment').unbind('click').live('click', function(e) {
        e.preventDefault();
        var id = $('input[name="recordId"]').val();
        var $dialog = getPageInLightbox(this.href+'&lightbox=1', this.title, 'Record', '', id);
    });
    
    // bind click action to reset comment link
    $(':reset').live('click', function(e){
        $('input#commentId').val(0);
        $('div.comment').css('font-style', 'normal');
    });

    // bind click action to export record menu
    $('a.exportMenu').click(function(e){
        toggleMenu('exportMenu');
        e.preventDefault();
    });

    // bind click action on toolbar links
    $('a.citeRecord').click(function(e) {
        var id = this.id.substr('citeRecord'.length);
        var $dialog = getLightbox('Record', 'Cite', id, null, this.title);
        e.preventDefault();
    });
    $('a.smsRecord').click(function(e) {
        var id = this.id.substr('smsRecord'.length);
        var module = 'Record';
        if ($(this).hasClass('smsSummon')) {
            module = 'Summon';
        } else if ($(this).hasClass('smsWorldCat')) {
            module = 'WorldCat';
        }
        var $dialog = getLightbox(module, 'SMS', id, null, this.title);
        e.preventDefault();
    });
    $('#addThis a.mail, a.mailRecord').click(function(e) {
        var id = this.id.substr('mailRecord'.length);
        var module = 'Record';
        if ($(this).hasClass('mailSummon')) {
            module = 'Summon';
        } else if ($(this).hasClass('mailWorldCat')) {
            module = 'WorldCat';
        } else if ($(this).hasClass('mailMetaLib')) {
            module = 'MetaLib';
        } else if ($(this).hasClass('mailPCI')) {
            module = 'PCI';
        }
        var $dialog = getLightbox(module, 'Email', id, null, this.title);
        e.preventDefault();
    });
    $('a.feedbackRecord').click(function(e) {
        var id = this.id.substr('feedbackRecord'.length);
        var $dialog = getLightbox('Record', 'Feedback', id, null, this.title);
        e.preventDefault();
    });
    $('a.tagRecord').click(function(e) {
        var id = this.id.substr('tagRecord'.length);
        var $dialog = getLightbox('Record', 'AddTag', id, null, this.title, 'Record', 'AddTag', id);
        e.preventDefault();
    });
    $('a.deleteRecordComment').live('click', function(e) {
        var commentId = this.id.substr('recordComment'.length);
        var recordId = $('input[name="recordId"]').val();
        deleteRecordComment(recordId, commentId);
        e.preventDefault();
    });
    
    // add highlighting to subject headings when mouseover
    $('a.subjectHeading').mouseover(function() {
        var subjectHeadings = $(this).parent().children('a.subjectHeading');
        for(var i = 0; i < subjectHeadings.length; i++) {
            $(subjectHeadings[i]).addClass('highlight');
            if ($(this).text() == $(subjectHeadings[i]).text()) {
                break;
            }
        }
    });
    $('a.subjectHeading').mouseout(function() {
        $('.subjectHeading').removeClass('highlight');
    });

    $('.similarItems').each(function() {
        var id = this.id.substr('similarItems'.length);
        $(this).load(path + '/AJAX/AJAX_SimilarItems', {id: id}, function(response, status, xhr) {
            if (status != 'success') {
                $(this).text('Failed to load similar items');
            }
        });
    });
    
    setUpCheckRequest();
    setUpCheckCallSlipRequest();
    setUpCheckUBRequest();
});

function setUpCheckRequest() {
    $('.checkRequest').unbind('inview').one('inview', function() {
        if ($(this).hasClass('checkRequest')) {
            $(this).addClass('ajax_hold_availability');
            checkRequestIsValid(this, this.href);
        }
    });
}

function checkRequestIsValid(element, requestURL) {
    var recordId = requestURL.match(/\/Record\/([^\/]+)\//)[1];
    var vars = {}, hash;
    var hashes = requestURL.slice(requestURL.indexOf('?') + 1).split('&');

    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        var x = hash[0];
        var y = hash[1]
        vars[x] = y;
    }
    vars['id'] = recordId;
    
    var url = path + '/AJAX/JSON?' + $.param({method:'checkRequestIsValid', id: recordId, data: vars});
    $.ajax({
        dataType: 'json',
        cache: false,
        url: url,
        success: function(response) {
            if (response.status == 'OK') {
                if (response.data.status) {
                    $(element).removeClass('checkRequest ajax_hold_availability').html(response.data.msg);
                } else {
                    $(element).remove();
                }
            } else if (response.status == 'NEED_AUTH') {
                $(element).replaceWith('<span class="holdBlocked">' + response.data.msg + '</span>');
            }
        }
    });   
}

function setUpCheckCallSlipRequest() {
    $('.checkCallSlipRequest').unbind('inview').one('inview', function() {
        if ($(this).hasClass('checkCallSlipRequest')) {
            $(this).addClass('ajax_call_slip_availability');
            checkCallSlipRequestIsValid(this, this.href);
        }
    });
}

function checkCallSlipRequestIsValid(element, requestURL) {
    var recordId = requestURL.match(/\/Record\/([^\/]+)\//)[1];
    var vars = {}, hash;
    var hashes = requestURL.slice(requestURL.indexOf('?') + 1).split('&');

    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        var x = hash[0];
        var y = hash[1]
        vars[x] = y;
    }
    vars['id'] = recordId;
    
    var url = path + '/AJAX/JSON_CallSlip?' + $.param({method:'checkRequestIsValid', id: recordId, data: vars});
    $.ajax({
        dataType: 'json',
        cache: false,
        url: url,
        success: function(response) {
            if (response.status == 'OK') {
                if (response.data.status) {
                    $(element).removeClass('checkCallSlipRequest ajax_call_slip_availability').html(response.data.msg);
                } else {
                    $(element).remove();
                }
            } else if (response.status == 'NEED_AUTH') {
                $(element).replaceWith('<span class="callSlipBlocked">' + response.data.msg + '</span>');
            }
        }
    });   
}

function setUpCheckUBRequest() {
    $('.checkUBRequest').each(function(i) {
        if ($(this).hasClass('checkUBRequest')) {
            $(this).addClass('ajax_ub_request_availability');
            checkUBRequestIsValid(this, this.href);
        }
    });
}

function checkUBRequestIsValid(element, requestURL) {
    var recordId = requestURL.match(/\/Record\/([^\/]+)\//)[1];
    var vars = {}, hash;
    var hashes = requestURL.slice(requestURL.indexOf('?') + 1).split('&');

    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        var x = hash[0];
        var y = hash[1]
        vars[x] = y;
    }
    vars['id'] = recordId;
    
    var url = path + '/AJAX/JSON_UBRequest?' + $.param({method:'checkRequestIsValid', id: recordId, data: vars});
    $.ajax({
        dataType: 'json',
        cache: false,
        url: url,
        success: function(response) {
            if (response.status == 'OK') {
                if (response.data.options && response.data.options['success'] !== false) {
                    $(element).removeClass('checkUBRequest ajax_ub_request_availability').html(response.data.msg);
                } else {
                    $(element).remove();
                }
            } else if (response.status == 'NEED_AUTH') {
                $(element).replaceWith('<span class="UBRequestBlocked">' + response.data.msg + '</span>');
            }
        }
    });   
}

function setUpUBRequestForm(recordId) {
    $("#pickupLibrary").change(function() {
        $("#pickupLocation option").remove();
        $("#pickupLocationLabel").addClass("ajax_ub_request_loading");
        var url = path + '/AJAX/JSON_UBRequest?' + $.param({method:'getPickupLocations', id: recordId, pickupLib: $("#pickupLibrary").val() });
        $.ajax({
            dataType: 'json',
            cache: false,
            url: url,
            success: function(response) {
                if (response.status == 'OK') {
                    $.each(response.data.locations, function() {
                        var option = $("<option></option>").attr("value", this.id).text(this.name);
                        if (this.isDefault) {
                            option.attr("selected", "selected");
                        }
                        $("#pickupLocation").append(option);
                    });
                }
                $("#pickupLocationLabel").removeClass("ajax_ub_request_loading");
            },
            fail: function() {
                $("#pickupLocationLabel").removeClass("ajax_ub_request_loading");
            }
        });   
        
    });
    $("#pickupLibrary").change();
}

function setUpHoldRequestForm(recordId) {
    $("#requestGroupId").change(function() {
        var $emptyOption = $("#pickupLocation option[value='']");
        $("#pickupLocation option[value!='']").remove();
        $("#pickupLocationLabel").addClass("ajax_hold_request_loading");
        var url = path + '/AJAX/JSON_Hold?' + $.param({method:'getPickupLocations', id: recordId, requestGroupId: $("#requestGroupId").val() });
        $.ajax({
            dataType: 'json',
            cache: false,
            url: url,
            success: function(response) {
                if (response.status == 'OK') {
                    var defaultValue = $("#pickupLocation").data('default');
                    $.each(response.data.locations, function() {
                        var option = $("<option></option>").attr("value", this.locationID).text(this.locationDisplay);
                        if (this.locationID == defaultValue || (defaultValue == '' && this.isDefault && $emptyOption.length == 0)) {
                            option.attr("selected", "selected");
                        }
                        $("#pickupLocation").append(option);
                    });
                }
                $("#pickupLocationLabel").removeClass("ajax_hold_request_loading");
            },
            fail: function() {
                $("#pickupLocationLabel").removeClass("ajax_hold_request_loading");
            }
        });   
        
    });
    $("#requestGroupId").change();
}

function registerAjaxCommentRecord() {
    $('form[name="commentRecord"]').live('submit', function(){
        if (!$(this).valid()) { return false; }
        var form = this;
        var id = form.recordId.value;
        var url = path + '/AJAX/JSON?' + $.param({method:'commentRecord',id:id});
        $(form).ajaxSubmit({
            url: url,
            dataType: 'json',
            success: function(response, statusText, xhr, $form) {
                if (response.status == 'OK') {
                    refreshCommentList(id);
                    if($('input[name="type"]').val() == 1) {
                        $('#formContainer').hide();
                    } else {
                        $(form).resetForm();
                    }
                } else if (response.status == 'NEED_AUTH') {
                    $dialog = getLightbox('AJAX', 'Login', id, null, 'Login');
                    $dialog.dialog({
                        close: function(event, ui) {
                            // login dialog is closed, check to see if we can proceed with followup
                            if (__dialogHandle.processFollowup) {
                                 // trigger the submit event on the comment form again
                                 $(form).trigger('submit');
                            }
                        }
                    });
                } else {
                    displayFormError($form, response.data);
                }
            }
        });
        return false;
    });
}

function registerAjaxInappropriateComment() {
    $('form[name="inappropriateComment"]').unbind('submit').on('submit', function(e){
        e.preventDefault();
        var form = this;
        var id = form.recordId.value;
        var url = path + '/AJAX/JSON?' + $.param({method:'inappropriateComment'});
        $(form).ajaxSubmit({
            url: url,
            dataType: 'json',
            success: function(response, statusText, xhr, $form) {
                if (response.status == 'OK') {
                    refreshCommentList(id);
                    $(form).resetForm();
                    refreshCommentList(id);                
                    hideLightbox();
                } else {
                    displayFormError($form, response.data);
                }
            }
        });
        return false;
    });
}

function refreshCommentList(recordId) {
    var url = path + '/AJAX/JSON?' + $.param({method:'getRecordCommentsAsHTML',id:recordId});
    $.ajax({
        dataType: 'json',
        url: url,
        success: function(response) {
            
            if (response.status == 'OK') {
                $('#commentsContainer').replaceWith(response.data);
                commentUl = 'ul[id="commentList'+ recordId + '"]';
                $('#commentCount').text($(commentUl + ' li:not(#emptyListItem)').length);
                var count = 0, total = 0, average = 0;
                $.each($('.starRatingReadOnly'), function() {
                    var stars = $(this).raty('score');
                    count++;
                    total = total + stars;
                });
                if (count>0) {
                    average = total/count
                }
                if ($('input[name="type"]').val() == 1) {
                    $('#ratingCount').text(count);
                    $('#averageRating').raty('readOnly', false);
                    $('#averageRating').raty('score', average.toFixed(2));
                    $('#averageRating').raty('readOnly', true);
                }
            }
        }
    });
}

function deleteRecordComment(recordId,commentId) {
    var url = path + '/AJAX/JSON?' + $.param({method:'deleteRecordComment',id:commentId});
    $.ajax({
        dataType: 'json',
        url: url,
        success: function(response) {
            if (response.status == 'OK') {
                refreshCommentList(recordId);
            }
        }
    });
}
