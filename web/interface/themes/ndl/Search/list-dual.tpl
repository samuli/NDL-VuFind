<!-- START of: Search/list-dual.tpl -->

{js filename="search.js"}

<div id="dualResultsHeader" class="resultHeader">
  <div class="resultTerms">
    <div class="content">
      <div class="headerLeft">
	      <h3 class="searchTerms grid_12">
	      {if $lookfor == ''}{translate text="history_empty_search"}
	      {else}
	        {if $searchType == 'basic'}{$lookfor|escape:"html"}
	        {elseif $searchType == 'advanced'}{translate text="Your search terms"} : "{$lookfor|escape:"html"}
	        {elseif ($searchType == 'advanced') || ($searchType != 'advanced' && $orFilters)}
	          {foreach from=$orFilters item=values key=filter}
	          AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}
	        {/if}
	        {if $searchType == 'advanced'}"{/if}
	      {/if}
	      </h3>
	      {if $spellingSuggestions}
	      <div class="correction grid_24">
	        {translate text="spell_suggest"}:
	        {foreach from=$spellingSuggestions item=details key=term name=termLoop}
	          <span class="correctionTerms">{foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|replace:"/Search/Results":"/Search/DualResults"|escape}">{$word|escape}</a>{if $data.expand_url} <a class="expandSearch" title="{translate text="spell_expand_alt"}" {* alt="{translate text="spell_expand_alt"}" NOT VALID ATTRIBUTE *} href="{$data.expand_url|replace:"/Search/":"/Resource/"|escape}"></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}
	          </span>
	        {/foreach}
	      </div>
	      <div class="clear"></div>
	      {/if}
      </div>
      <div class="headerRight">
        <a class="button buttonFinna buttonSelected" href=".">{translate text="All Results"}</a>
        <a class="button buttonFinna" href="{$more}">{translate text="Books etc."}</a>
        <a class="button buttonFinna" href="{$pci_more}">{translate text="Articles, e-Books etc."}</a>
      </div>
    </div> {* content *}
  </div> {* resultTerms *}
</div> {* resultHeader *}

{* Main Listing *}
<div id="dualResults" class="resultListContainer">
  <div class="content">
	  <div class="leftColumn">
	    {include file="Search/list-dual-solr.tpl"}
	  </div>
	  <div class="rightColumn" id="deferredResults">
	    <div class="resulthead">
	      <h3><a href="{$pci_more|escape}">{translate text="Articles, e-Books etc."}</a></h3>
	      <i>{translate text="pci_results_description"}</i><br/><br/>
	      <script type="text/javascript">
	        document.write('<p class="iframe_loading"> {translate text="Loading"}...</p>');
	      </script>
	      <noscript>{translate text="Please enable Javascript to see results in this category."}</noscript>
	    </div>
  </div>
  </div>
  <script type="text/javascript">
    var url = path + "/AJAX/AJAX_PCI?method=pci&lookfor=" +
        "{$lookfor|escape:"url"|escape:"javascript"}";
    $("#deferredResults").load(url, {literal}function(responseText, textStatus) {
        if (textStatus == 'error') {
            $("#deferredResults .iframe_loading").text("Failed to load results").removeClass('iframe_loading');
        }
    }{/literal});
  </script>
</div>

<!-- END of: Search/list-dual.tpl -->
