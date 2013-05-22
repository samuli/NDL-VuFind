<!-- START of: MyResearch/accounts.tpl -->

{include file="MyResearch/menu.tpl"}

<div class="well-small myResearch accounts{if $sidebarOnLeft} last{/if}">
  <span class="lead">{translate text='Library Cards'}</span>
  {if empty($accounts)}
    <br />
    {translate text='You do not have any library cards'}
  {else}
    <table class="table table-condensed table-hover datagrid accountList" summary="{translate text='Library Cards'}">
    <tr class="well">
      <th>{translate text='Name'}</th>
      <th class="hidden-phone">{translate text='Description'}</th>
      <th>{translate text='Added'}</th>
      <th>{translate text='Source'}</th>
      <th>{translate text='Actions'}</th>
    </tr>
    {foreach from=$accounts item=account}
      <tr>
        <td>
          {$account.account_name|escape}
        </td>
        <td class="hidden-phone">
          {$account.description|truncate:50:"..."|escape}
        </td>
        <td>{$account.created|escape}</td>
        <td>
          {assign var=source value=$account.cat_username|regex_replace:'/\..*?$/':''}
          {translate text=$source prefix='source_'}
        </td>
        <td>
          <a href="{$url}/MyResearch/Accounts?edit={$account.id|escape:"url"}" class="btn btn-mini edit tool" title="{translate text="Edit"}"><i class="icon-edit"></i></a>
          <a href="{$url}/MyResearch/Accounts?delete={$account.id|escape:"url"}" class="btn btn-mini btn-danger delete tool" onclick="return confirm('{translate text='confirm_delete'}');" title="{translate text="Delete"}"><i class="icon-remove icon-white"></i></a>
        </td>
      </tr>
    {/foreach}
    </table>
  {/if}
  <form method="get" action="" id="add_form">
    <input type="hidden" name="add" value="1" />
    <input class="btn btn-info button" type="submit" value="{translate text='Add'}..." />
  </form>  
</div>
<div class="clear"></div>

<!-- END of: MyResearch/accounts.tpl -->
