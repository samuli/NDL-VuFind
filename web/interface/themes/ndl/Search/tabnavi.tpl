<!-- START of: Search/tabnavi.tpl -->

<div class="ui-tabs ui-widget tabNavi searchIndex" role="navigation" aria-label="{translate text='Search Type Navigation'}">
  <div class="content">
    <div class="grid_24">
      <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix">

      {* Check from URI if in Advanced search *}
      {if strpos($smarty.server.REQUEST_URI, "Advanced") !== false}
        {* Advanced Search with possible PCI/MetaLib alternatives *}

        {* Tab: Solr Advanced*}
        <li class="active ui-state-default ui-corner-top{if $module=='Search'} ui-tabs-selected ui-state-active{/if}">
          <a id="booksTabAdvanced" href="{$path}/Search/Advanced">{translate text="Local Records"}</a>
        </li>

        {* Tab: PCI Advanced *}
        {if $pciEnabled}
        <li class="active ui-state-default ui-corner-top{if $module=='PCI' && $pageTemplate!='list-dual.tpl'} ui-tabs-selected ui-state-active{/if}">
          <a id="articlesTabAdvanced" href="{$path}/PCI/Advanced">{translate text="Primo Central"}</a>
        {/if}

        {* Tab: MetaLib Advanced *}
        {if $metalibEnabled && $lookfor ==''}
        <li class="active ui-state-default ui-corner-top{if $module=='MetaLib'} ui-tabs-selected ui-state-active{/if}"><a id="metalibTabAdvanced" href="{$path}/MetaLib/Advanced">{translate text="MetaLib Searches"}</a></li>
        {/if}
        {if $metalibEnabled && $lookfor !=''}
        <li class="active ui-state-default ui-corner-top{if $module=='MetaLib'} ui-tabs-selected ui-state-active{/if}"><a id="metalibTabAdvanced" href="{$path}/MetaLib/Advanced?lookfor={$lookfor|escape:"url"}&retainFilters=0">{translate text="MetaLib Searches"}</a></li>
        {/if}

      {else}
        {* Basic Search with possible PCI/MetaLib alternatives *}

        {* Tab: dualResults *}
        {if $dualResultsEnabled && $searchType != 'advanced'} {* Check not in advanced results *}
        <li class="active ui-state-default ui-corner-top{if $module=='Search' && $pageTemplate=='list-dual.tpl'} ui-tabs-selected ui-state-active{/if}">
          {if $module=="MetaLib"}
          <a id="allResultsTab" href="{$searchWithFilters|escape|replace:"/MetaLib/Search":"/Search/DualResults"|replace:"prefilter=":"prefiltered="}">
          {elseif $module=="PCI"}
          <a id="allResultsTab" href="{$searchWithFilters|escape|replace:"/PCI/Search":"/Search/DualResults"|replace:"prefilter=":"prefiltered="|replace:"view=grid":"view=list"|regex_replace:"/(&amp;)?limit=[0-9]*/":""}">
          {else}
          <a id="allResultsTab" href="{$searchWithFilters|escape|replace:"/Search/Results":"/Search/DualResults"|replace:"prefilter=":"prefiltered="|replace:"view=grid":"view=list"|regex_replace:"/(&amp;)?limit=[0-9]*/":""}">
          {/if}
          {translate text="Local and Primo"}</a>
        </li>
        {/if}

        {* Tab: Solr *}
        <li class="active ui-state-default ui-corner-top{if $module=='Search' && $pageTemplate!='list-dual.tpl'} ui-tabs-selected ui-state-active{/if}">
          {if $module=="MetaLib"}
          <a id="booksTab" href="{$searchWithFilters|escape|replace:"/MetaLib/Search":"/Search/Results"|replace:"prefilter=":"prefiltered="}">
          {else}
          <a id="booksTab" href="{$searchWithFilters|escape|replace:"/PCI/Search":"/Search/Results"|replace:"prefilter=":"prefiltered="}">
          {/if}
          {translate text="Local Records"}</a>
        </li>

        {* Tab: PCI *}
        {if $pciEnabled && $searchType != 'advanced'}
        <li class="active ui-state-default ui-corner-top{if $module=='PCI' && $pageTemplate!='list-dual.tpl'} ui-tabs-selected ui-state-active{/if}">
          {if $module=="MetaLib"}
          <a id="articlesTab" href="{$searchWithFilters|escape|replace:"/MetaLib/Search":"/PCI/Search"|replace:"prefilter=":"prefiltered="}">
          {else}
          <a id="articlesTab" href="{$searchWithFilters|escape|replace:"/Search/Results":"/PCI/Search"|replace:"/Search/DualResults":"/PCI/Search"|replace:"prefilter=":"prefiltered="}">
          {/if}
          {translate text="Primo Central"}</a>
        </li>
        {/if}

        {* Tab: MetaLib *}
        {if $metalibEnabled}
        <li class="active ui-state-default ui-corner-top{if $module=='MetaLib'} ui-tabs-selected ui-state-active{/if}">
          <a id="metalibTab" href="{$searchWithFilters|escape|replace:"/Search/Results":"/MetaLib/Search"|replace:"/Search/DualResults":"/MetaLib/Search"|replace:"/PCI/Search":"/MetaLib/Search"|replace:"prefilter=":"prefiltered="}">
          {translate text="MetaLib Searches"}</a></li>
        {/if}

      {/if}

      {if in_array('tabs', $contextHelp)}
         <li class="contextHelp"><span id="contextHelp_tabs" class="showHelp">{translate text="Search Tips"}</span></li>
      {/if}
      </ul>
    </div>
  </div>
</div>

<!-- END of: Search/tabnavi.tpl -->
