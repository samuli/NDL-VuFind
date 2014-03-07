<!-- start of select-card.tpl -->

  <ul id="selectCard">
        <li class="selectText">{translate text="Select Card"}</li>
        <li class="menuLibCard">
  <form id="catalogAccountForm5" method="post" action="" class="show">
    <select id="catalogAccounts" name="catalogAccount" title="{translate text="Selected Library Card"}" class="jumpMenu" aria-label="{translate text='Select Card'}">
      {foreach from=$catalogAccounts item=accounts}
     	 <option value="{$accounts.id|escape}"{if $accounts.cat_username == $currentCatalogAccount} selected="selected"{/if}>		
     	 {$accounts.account_name|truncate:40:'...':true:false|escape} {if $accounts.account_name == ''}{assign var=sourceSelect value=$accounts.cat_username|regex_replace:'/\..*?$/':''}{translate text=$sourceSelect|truncate:40:'...':true:false|escape prefix='source_'}{/if}
     	 </option>
      {/foreach}
    </select>
    <noscript><input type="submit" value="{translate text="Set"}" /></noscript>
  </form>
  </li>
</ul>

<!-- end of select-card.tpl -->