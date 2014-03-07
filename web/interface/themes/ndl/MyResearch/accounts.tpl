<!-- START of: MyResearch/accounts.tpl -->

{include file="MyResearch/menu.tpl"}

<div class="content myResearch accounts{if $sidebarOnLeft} last{/if}">
  {if empty($accounts)}
    <p class="noContentMessage">{translate text='You do not have any library cards'}</p>
  {else}
    <h2>{translate text='Linked Library Cards'}</h2>
    <table class="datagrid accountList" summary="{translate text='Library Cards'}">
    <tr class="librarycardSettings">
      <th>{translate text='Library'}</th>
      <th>{translate text='Library Card Name'}</th>
      <th class="alignMiddle">{translate text='Added'}</th>
      <th class="alignMiddle">{translate text='Actions'}</th>
    </tr>
    {foreach from=$accounts item=account}
      <tr>
        <td>
          {assign var=source value=$account.cat_username|regex_replace:'/\..*?$/':''}
          {translate text=$source prefix='source_'}
        </td>
        <td>
          {$account.account_name|escape}
        </td>
        <td  class="alignMiddle">{$account.created|escape}</td>
        <td class="alignMiddle">
          <a href="{$url}/MyResearch/Accounts?edit={$account.id|escape:"url"}" class="edit tool"></a>
          <a href="{$url}/MyResearch/Accounts?delete={$account.id|escape:"url"}" class="delete tool" onclick="return confirm('{translate text='confirm_delete_card'}');"></a>
        </td>
      </tr>
    {/foreach}
    </table>
  {/if}
  <form method="get" action="" id="add_form">
    <input type="hidden" name="add" value="1" />
    <input class="button buttonFinna" type="submit" value="{translate text='Link Library Card'}..." />
  </form>  
</div>
<div class="clear"></div>

<!-- END of: MyResearch/accounts.tpl -->
