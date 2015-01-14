<!-- START of: RecordDrivers/Index/extended-btjdescription.tpl -->



<script type="text/javascript">
//<![CDATA[
{literal}
$(document).ready(function() {
  loadRecordDescription('{/literal}{$id}{literal}', $('{/literal}{$descriptionHolder}{literal}'));
});
//]]>
{/literal}
</script>

<!--
<tr valign="top" class="extendedBTJDescription" id="description" style="display: none;">
    <td id="description_text" colspan="2"><img src="{path filename="images/ajax_loading.gif"}" alt="{translate text='Loading data...'}"/>
      <script type="text/javascript">
        //<![CDATA[
       var path = {$path|@json_encode};
       var id = {$id|@json_encode};
       {literal}
       $(document).ready(function() {
         var url = path + '/AJAX/AJAX_Description?id=' + id;
         $("#description_text").load(url, function(response, status, xhr) {
           if (response.length != 0) {
             {/literal}{if $driver != 'AxiellWebServices'}{literal}
              $("#description").show();
             {/literal}{else}{literal}
               $(this).wrapInner('<div class="recordSummary truncateField"></div>');
               $("#description").show();
               $(this).find('.truncateField').collapse({maxRows: 4, more: " ", less: " "});
             {/literal}{/if}{literal}
           }
         });
       });
       //]]>
       {/literal}
  </script>
  </td>
</tr>
-->

<!-- END of: RecordDrivers/Index/extended-btjdescription.tpl -->