<!-- START of: Browse/alphabet.tpl -->

<ul class="browse">
  {foreach from=$letters item=letter}
    <li>
      <a href="" title="{$letter|escape}*" class="btn loadOptions query_field:{$query_field} facet_field:{$facet_field} facet_prefix:{$letter|escape} target:list4container">{$letter|escape}</a>
    </li>
  {/foreach}  
</ul>

<!-- END of: Browse/alphabet.tpl -->
