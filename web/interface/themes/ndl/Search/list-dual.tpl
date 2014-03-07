<!-- START of: Search/list-dual.tpl -->
{* Fancybox for images *}
{js filename="init_fancybox.js"}

{js filename="search.js"}

<div id="dualResultsHeader" class="resultHeader">
  <div class="resultTerms">
    <div class="content">
      {if $searchType == 'advanced'}
      <div class="advancedOptions grid_24">
        <a href="{$path}/Search/Advanced?edit={$searchId}">{translate text="Edit this Advanced Search"}</a> |
        <a href="{$path}/Search/Advanced">{translate text="Start a new Advanced Search"}</a> |
        <a href="{$path}/">{translate text="Start a new Basic Search"}</a>
      </div>
      {/if}
      <div class="headerLeft">
	      <h2 class="searchTerms grid_12">
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
	      </h2>
	      {if $spellingSuggestions}
	      <div class="correction grid_24">
	        {translate text="spell_suggest"}:
	        {foreach from=$spellingSuggestions item=details key=term name=termLoop}
	          <span class="correctionTerms">{foreach from=$details.suggestions item=data key=word name=suggestLoop}<a href="{$data.replace_url|replace:"/Search/Results":"/Search/DualResults"|escape}">{$word|escape}</a>{if $data.expand_url} <a class="expandSearch" title="{translate text="spell_expand_alt"}" {* alt="{translate text="spell_expand_alt"}" NOT VALID ATTRIBUTE *} href="{$data.expand_url|replace:"/Search/Results":"/Search/DualResults"|escape}"></a> {/if}{if !$smarty.foreach.suggestLoop.last}, {/if}{/foreach}
	          </span>
	        {/foreach}
	      </div>
	      <div class="clear"></div>
	      {/if}
      </div>
    </div> {* content *}
  </div> {* resultTerms *}
</div> {* resultHeader *}

  {* tabNavi *}
  {if $searchType != 'advanced'}
    {include file="Search/tabnavi.tpl"}
  {/if}

{* Main Listing *}
<div id="dualResults" class="resultListContainer">
  <div class="content">


<div class="dualListHeader">
  <div class="leftColumn">
    <h3>{if $recordCount}<a href="{$more|escape}">{translate text="Local Records"}</a>{else}{translate text="Local Records"}{/if}</h3>
  </div>
  <div class="rightColumn">
    <h3>{if $recordCount}<a href="{$pci_more|escape}">{translate text="Primo Central"}</a>{else}{translate text="Primo Central"}{/if}</h3>
  </div>
  <p class="resultContentToggle upperToggle"><a href="#" class="toggleHeader">{translate text="More Information"}</a></p>
  <div class="resultContentList">
    <div class="leftColumn">
      {translate text="dualresults_solr_desc"}
    </div>
    <div class="rightColumn">
      {translate text="dualresults_primo_desc"}
    </div>
    <p class="resultContentToggle lowerToggle"><a href="#" class="toggleHeader">{translate text="More Information"}</a></p>
  </div>
  <hr class="dualRuler">
</div>


	  <div class="leftColumn">
	    {include file="Search/list-dual-solr.tpl"}
	  </div>
	  <div class="rightColumn" id="deferredResults">
	    <div class="resulthead">
	      <h3><a href="{$pci_more|escape}">{translate text="Primo Central"}</a></h3>
	      <i>{translate text="pci_results_description"}</i><br/><br/>
	      <script type="text/javascript">
	        document.write('<p class="iframe_loading"> {translate text="Loading"}...</p>');
	      </script>
	      <noscript>{translate text="Please enable Javascript to see results in this category."}</noscript>
	    </div>
  </div>

  <hr class="dualRuler">


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

  <script type="text/javascript">
{literal}
    $('.dualListHeader a.toggleHeader').click(function() {
        $('.dualListHeader .resultContentToggle.upperToggle').hide();
    });
    $('.dualListHeader .resultContentToggle.lowerToggle .toggleHeader').click(function() {
        $('.dualListHeader .resultContentToggle.upperToggle').show;
        $('.dualListHeader .resultContentToggle.upperToggle a.toggleHeader').trigger('click');
        $('.dualListHeader .resultContentToggle.upperToggle').delay(100).show(0);
    });
{/literal}
  </script>
</div>

<!-- END of: Search/list-dual.tpl -->
