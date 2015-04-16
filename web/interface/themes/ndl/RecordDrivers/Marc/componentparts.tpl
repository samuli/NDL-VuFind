<!-- START of: RecordDrivers/Marc/componentparts.tpl -->

{assign var="havePresenters" value=false}
{assign var="haveDuration" value=false}
{foreach from=$componentparts item=componentpart}
  {if $componentpart.presenters}
    {assign var="havePresenters" value=true}
  {/if}
  {if $componentpart.duration}
    {assign var="haveDuration" value=true}
  {/if}
{/foreach}
<table cellpadding="0" cellspacing="0" border="0" class="display" id="componentparts" width="100%">
  <thead>
    <tr>
      <th>{translate text="No."}</th>
      <th>{translate text="Title and Authors"}</th>
{if $havePresenters}
      <th>{translate text="Presenters"}</th>
{/if}
{if $haveDuration}
      <th>{translate text="Playing Time"}</th>
{/if}
    </tr>
  </thead>    
  <tbody>
  {if !empty($componentparts)}
    {foreach from=$componentparts item=componentpart}
    <tr valign="top">
        <td>{$componentpart.number|escape}</td>
        <td>{if $componentpart.link}<a href="{$componentpart.link|escape}">{else}<span class="nonLinkedTitle">{/if}{$componentpart.title|escape}{if $componentpart.link}</a>{else}</span>{/if}<br/>
          {if $componentpart.uniformTitle}{$componentpart.uniformTitle|escape}<br/>{/if}
	        <span class="partAuthors{if !$componentpart.link || $componentpart.uniformTitle}Padded{/if}" title="{foreach from=$componentpart.otherAuthors item=author name=authorloop}{if $smarty.foreach.authorloop.iteration > 1} ; {/if}{$author|escape}{/foreach}">
	          {foreach from=$componentpart.otherAuthors item=author name=authorloop}{if $smarty.foreach.authorloop.iteration < 4}{if $smarty.foreach.authorloop.iteration > 1} ; {/if}{$author|escape}{/if}{if $smarty.foreach.authorloop.iteration == 4} ...{/if}{/foreach}
	        </span>
	      </td>
      {if $havePresenters}
        <td title="{foreach from=$componentpart.presenters item=author name=authorloop}{if $smarty.foreach.authorloop.iteration > 1} ; {/if}{$author|escape}{/foreach}">
          {foreach from=$componentpart.presenters item=author name=authorloop}{if $smarty.foreach.authorloop.iteration < 4}{if $smarty.foreach.authorloop.iteration > 1} ; {/if}{$author|escape}{/if}{if $smarty.foreach.authorloop.iteration == 4} ...{/if}{/foreach}
        </td>
      {/if}
      {if $haveDuration}
        <td>{$componentpart.duration|escape}</td>
      {/if}
    </tr>
    {/foreach}
  {/if}  
  </tbody>
</table>

{literal}
<script type="text/javascript" charset="utf-8">
    $('table#componentparts').dataTable({
        "iDisplayLength": 50, 
        "bStateSave": true,
        "fnStateSave": function (oSettings, oData) {
            localStorage.setItem( 'DataTables_'+window.location.pathname, JSON.stringify(oData) );
          },
    "fnStateLoad": function (oSettings) {
            var data = localStorage.getItem('DataTables_'+window.location.pathname);
            return JSON.parse(data);
          },
      "oLanguage": {
{/literal}
            "sSearch": "{translate text="component_parts_search"}",
            "sLengthMenu": "{translate text="component_parts_show_entries"}",
            "sInfoFiltered": "{translate text="component_parts_filtered"}",
            "sInfo": "{translate text="component_parts_entries_on_page"}",
{literal}
            "oPaginate": {
{/literal}
                "sNext": "{translate text="component_parts_next"}",
                "sPrevious": "{translate text="component_parts_previous"}"
{literal}
            }
        }        
  });
</script>
{/literal}

<!-- END of: RecordDrivers/Marc/componentparts.tpl -->
