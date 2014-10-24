$(document).ready(function(){
    registerWebpayment();
});

function registerWebpayment() {
    $(".ajax_register_payment").show();
    
    $.ajax({
        url: path + '/AJAX/JSON_Transaction',
        data: {
            method: 'registerPayment',
            url: location.href
        },
        dataType: 'json',
        success: function(data) {
            $(".ajax_register_payment").removeClass('ajax_register_payment');
            $('#webpaymentStatusSpinner').hide();
            $('#webpaymentStatus').html(data.data).show();                
            if (data.status != 'OK') {
                $('#webpaymentStatus').removeClass('info').addClass('error');
            }

        }
    });
}

