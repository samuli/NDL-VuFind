{literal}
<script type="text/javascript">
$(document).ready(function() {
    // poll every 240 seconds
    var refreshTime = 240000;
    window.setInterval(function() {
        $.getJSON("{/literal}{$url}{literal}/AJAX/JSON_KeepAlive",
               {method: 'keepAlive'});
    }, refreshTime);
});
</script>
{/literal}