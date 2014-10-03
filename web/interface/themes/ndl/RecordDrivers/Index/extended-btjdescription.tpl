<!-- START of: RecordDrivers/Index/extended-btjdescription.tpl -->

<tr valign="top" class="extendedBTJDescription" id="btjdescription" style="display: none;">
  <th>{translate text='Description'}: </th>
    <td id="btjdescription_text"><img src="{path filename="images/ajax_loading.gif"}" alt="{translate text='Loading data...'}"/>
      <script type="text/javascript">
        //<![CDATA[
       var path = {$path|@json_encode};
       var id = {$id|@json_encode};
       {literal}
       $(document).ready(function() {
         var url = path + '/AJAX/AJAX_Description?id=' + id;
         $("#btjdescription_text").load(url, function(response, status, xhr) {
           if (response.length != 0) {
             {/literal}{if $driver != 'AxiellWebServices'}{literal}
              $("#btjdescription").show();
             {/literal}{else}{literal}
               $(this).wrapInner('<div class="truncateField"></div>');
               $("#btjdescription").show();
               $(this).find('.truncateField').collapse({maxRows: 4, more: "{/literal}{translate text="more"}{literal}", less: "{/literal}{translate text="less"}{literal}"});
             {/literal}{/if}{literal}
           }
         });
       });
       //]]>
       {/literal}
  </script>
  </td>
</tr>

<!-- END of: RecordDrivers/Index/extended-btjdescription.tpl -->