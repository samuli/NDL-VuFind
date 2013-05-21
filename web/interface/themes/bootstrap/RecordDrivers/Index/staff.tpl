<!-- START of: RecordDrivers/Index/staff.tpl -->

<div style="overflow:hidden;">
  <table class="citation">
    {foreach from=$details key='field' item='values'}
      <tr>
        <th>{$field|escape}</th>
        <td>
          {foreach from=$values item='value'}
            {if is_array($value)}
              {foreach from=$value key=key item=subValue}
                {$key|escape} = {$subValue|escape}<br />
              {/foreach}
            {else}
            {$value|escape}<br />
            {/if}
          {/foreach}
        </td>
      </tr>
    {/foreach}
  </table>
</div>

{* To avoid needing to modify vufind/web/services/Record/record-marc.xsl
   which is a common file and not limited to this theme *}
<script type="text/javascript">
    $('.citation').addClass('table table-condensed table-hover');
</script>

<!-- END of: RecordDrivers/Index/staff.tpl -->
