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
        var amount = $('#webpaymentAmount').val();
        var transactionId = $('#webpaymentTransactionId').val();
        var transactionFee = 0;
        if ($('#webpaymentTransactionFee').length != 0) {
            transactionFee = $('#webpaymentTransactionFee').val();
        }
        var fines = [];
        $('.webpaymentTransactionFine').each(function(index, item) {
            var index = $(item).attr('id').replace('webpaymentFeeType', '');
            var title = $('#webpaymentFeeTitle' + index).val();
            var fee_type = $('#webpaymentFeeType' + index).val();
            var fee_amount = $('#webpaymentFeeBalance' + index).val();
            var fee_currency = $('#webpaymentFeeCurrency' + index).val();
            fines.push( {
                title: title,
                type: fee_type,
                amount: fee_amount,
                currency: fee_currency
            } );
        });

        //TODO: disable submit button ?
        $.ajax({
            url: path + '/AJAX/JSON_Transaction',
            data: {
                method: 'startTransaction',
                transaction_id: transactionId,
                amount: amount,
                transaction_fee: transactionFee,
                currency: 'EUR', //TODO: customize currency
                fines: fines
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
                        window.location.href = path + '/MyResearch/Fines'; //TODO: this is quite rough
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
