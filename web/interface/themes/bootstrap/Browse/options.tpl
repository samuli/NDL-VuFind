<!-- START of: Browse/options.tpl -->

{if !empty($facets)}
<ul class="browse">
  {foreach from=$facets item=facet}
    <li>
      <a class="btn btn-mini pull-right viewRecords" href="{$url}/Search/Results?lookfor=%22{$facet.0|escape:'url'}%22&amp;type={$facet_field|escape:'url'}&amp;filter[]={$query|escape:'url'}">{translate text='View Records'}</a>
      {if $next_query_field}
        <a title="{$query|escape} AND {$next_query_field|escape}:&quot;{$facet.0|escape}&quot;" href="" class="btn btn-info loadOptions facet_field:{$next_facet_field} target:{$next_target}">{$facet.0|escape} ({$facet.1})</a>
      {else}
        <a title="&quot;{$facet.0|escape}&quot;" href="{$url}/Search/Results?lookfor=%22{$facet.0|escape:'url'}%22&amp;type={$facet_field|escape:'url'}&amp;filter[]={$query|escape:'url'}" class="btn btn-info">{$facet.0|escape} ({$facet.1})</a>
      {/if}
    </li>
  {/foreach}  
</ul>
{/if}

<!-- END of: Browse/options.tpl -->
