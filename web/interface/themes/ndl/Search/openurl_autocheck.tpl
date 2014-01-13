<!-- START of: Search/openurl_autocheck.tpl -->

{if $openUrlAutoCheck}
{literal}
<script type="text/javascript">

$(document).ready(function() {
  $('a.openUrlEmbed').unbind('inview').one('inview', function() { $(this).trigger('click'); });
});
{/literal}
</script>
{/if}

<!-- END of: Search/openurl_autocheck.tpl -->
