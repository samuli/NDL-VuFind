<div id="RSSFeed-{$rssId}"><div class="loading"></div></div>
<script type="text/javascript">{literal}
    $(document).ready(function() {
        $('#RSSFeed-{/literal}{$rssId}{literal}').load('{/literal}{$url}{literal}/AJAX/AJAX_RenderRSS', {id: '{/literal}{$rssId|escape url}{literal}'});        
    });{/literal}
</script>