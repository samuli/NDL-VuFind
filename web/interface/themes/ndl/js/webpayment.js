$(document).ready(function(){
    registerWebpaymentActions();
    registerWebpayment();
});

function registerWebpaymentActions() {
    $('.webpaymentForm').submit(function(e){
        if ($('#webpaymentAmount').length == 0 || $('#webpaymentTransactionId').length == 0) {
            return false;
        }
        var self = this;
        $.ajax({
            url: path + '/AJAX/JSON_Transaction',
            data: {
                method: 'startTransaction'
            },
            dataType: 'json',
            success: function(data) {
                if (data.status == 'OK') {
                    self.submit();
                } else {
                    $('table.fines').parent().prepend('<div class="webpaymentMessage info">' + data.data + '</div>');
                }
            }
        }) ;
        return false;
    });
}

function registerWebpayment() {
    if ($(".webpaymentMessage").length && $('.ajax_register_payment').length) {
        $(".ajax_register_payment").show();
        params = splitParamsToArray();
        var payment_id_param = params['payment_id_param'];
        delete params['payment_id_param'];
        $.ajax({
            url: path + '/AJAX/JSON_Transaction',
            data: {
                method: 'registerPayment',
                payment_id_param: payment_id_param,
                params: params
            },
            dataType: 'json',
            success: function(data) {
                $(".ajax_register_payment").removeClass('ajax_register_payment');
                $('#webpaymentStatusSpinner').hide();
                if (data.status == 'OK') {
                    if (data.data != '') {
                        $('#webpaymentRegisterStatus').replaceWith(data.data);
                        $('#webpaymentRegisterStatus').show();
                        $('.webpaymentMessage').removeClass('info').addClass('error');
                    } else {
                        $('#webpaymentStatus').show();
                    }
                } else {
                    $('#webpaymentRegisterStatus').replaceWith(data.data);
                    $('#webpaymentRegisterStatus').show();
                    $('.webpaymentMessage').removeClass('info').addClass('error');
                }
            }
        });
    }
}

function splitParamsToArray() {
    var x = location.search.substr(1).split('&');
    var a = {};
    $.each(x, function(i, v) {
        var p = v.split('=');
        a[ p[0] ] = decodeURIComponent(p[1].replace(/\+/g, " "));
    });
    return a;
}
