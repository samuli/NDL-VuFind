<!-- START of: Search/result-search-tools.tpl -->

<div class="resultSearchTools">
  <div class="content">
    <div class="searchtools">
      <ul>
        <li class="toolSavedSearch">
          {if $savedSearch}
            <span class="searchtoolsHeader"><a href="{$url}/MyResearch/SaveSearch?delete={$searchId}">{translate text='save_search_remove'}</a></span>
          {else}
            <span class="searchtoolsHeader"><a href="{$url}/MyResearch/SaveSearch?save={$searchId}">{translate text="save_search"}</a></span>
            <span class="searchtoolsText">
            </span>
          {/if}
        </li>
        <li class="toolRssLink">
          <span class="searchtoolsHeader"><a href="{$rssLink|escape}">{translate text="Get RSS Feed"}</a></span>
          <span class="searchtoolsText">
          </span>
        </li>
        <li class="toolMailSearch">
          <span class="searchtoolsHeader"><a href="{$url}/Search/Email" class="mailSearch mail" id="mailSearch{$searchId|escape}" title="{translate text='Email this Search'}">{translate text="Email this Search"}</a></span>
          <span class="searchtoolsText">
          </span>
        </li>
      </ul>  
    </div>
  </div>
</div>
          
<!-- END of: Search/result-search-tools.tpl -->