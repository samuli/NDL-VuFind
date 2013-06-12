<!-- START of: Search/list-dual.tpl -->

{js filename="search.js"}

<div id="resultList" class="span12">      
  <div class="resulthead row-fluid">
    <div class="span12 alert alert-success well-small resultTerm">
      <h4 class="pull-left searchTerms">
      {if $lookfor == ''}{translate text="history_empty_search"}
      {else}
        {if $searchType == 'basic'}{translate text="Search"}: {$lookfor|escape:"html"}
        {elseif $searchType == 'advanced'}{translate text="Your search terms"} : "{$lookfor|escape:"html"}
        {elseif ($searchType == 'advanced') || ($searchType != 'advanced' && $orFilters)}
          {foreach from=$orFilters item=values key=filter}
          AND ({foreach from=$values item=value name=orvalues}{translate text=$filter|ucfirst}:{translate text=$value prefix='facet_'}{if !$smarty.foreach.orvalues.last} OR {/if}{/foreach}){/foreach}
        {/if}
        {if $searchType == 'advanced'}"{/if}
      {/if}
      </h4>
      <div class="pull-right">
        <a class="btn btn-small buttonSelected" href=".">{translate text="All Results"}</a>
        <a class="btn btn-small" href="{$more}">{translate text="Books etc."}</a>
        <a class="btn btn-small" href="{$pci_more}">{translate text="Articles, e-Books etc."}</a>
      </div>
    </div>

    <div class="row-fluid">
      {if $spellingSuggestions}
      <div class="alert alert-info correction well-small">
        <span class="label label-info">{translate text="spell_suggest"}</span>&nbsp;
        {foreach from=$spellingSuggestions item=details key=term name=termLoop}
          <span class="correctionTerms">
          {$term|escape} &raquo;
          {foreach from=$details.suggestions item=data key=word name=suggestLoop}
            <a href="{$data.replace_url|replace:"/Search/Results":"/Search/DualResults"|escape}">{$word|escape}</a>
            {if $data.expand_url}
            <a class="expandSearch" title="{translate text="spell_expand_alt"}" {* alt="{translate text="spell_expand_alt"}" NOT VALID ATTRIBUTE *} href="{$data.expand_url|replace:"/Search/":"/Resource/"|escape}"><i class="icon-zoom-in"></i></a>
            {/if}
            {if !$smarty.foreach.suggestLoop.last},
            {/if}
          {/foreach}
          </span>
        {/foreach}
      </div>
      {/if}
    </div>
  </div>
</div>


{* Main Listing *}
<div id="dualResults" class="row-fluid resultListContainer">
  <div class="span12 content">
    <div class="row-fluid">
	    <div class="span6 well-small leftColumn">
	      {include file="Search/list-dual-solr.tpl"}
	    </div>
	    <div class="span6 rightColumn" id="deferredResults">
	      <div class="resulthead">
	        <h4><a href="{$pci_more|escape}">{translate text="Articles, e-Books etc."}</a></h4>
	        <i>{translate text="pci_results_description"}</i><br/><br/>
	        <script type="text/javascript">
	          document.write('<p class="iframe_loading"> {translate text="Loading"}...</p>');
	        </script>
	        <noscript>{translate text="Please enable Javascript to see results in this category."}</noscript>
	      </div>
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
