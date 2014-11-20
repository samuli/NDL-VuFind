$(document).ready(function(){
    registerOnlinePayment();
});

function registerOnlinePayment() {
    $(".ajax_register_payment").show();
    
    $.ajax({
        url: path + '/AJAX/JSON_Transaction',
        data: {
            method: 'registerPayment',
            url: location.href
        },
        dataType: 'json',
        success: function(data) {
            if (data.status == 'OK') {
                location.href = path + '/MyResearch/Fines';
            } else {
                $(".ajax_register_payment").removeClass('ajax_register_payment');
                $('#onlinePaymentStatusSpinner').hide();
                $('#onlinePaymentStatus').html(data.data).show(); 
                $('#onlinePaymentStatus').removeClass('info').addClass('error');            
            }
        }
    });
}

