<!-- START of: Content/about.sv.tpl -->

{assign var="title" value="Vad är Finna?"}
<div class="sectionsWithHeadings aboutpage">
{capture append="sections"}
<div class="grid_24 grid_24_inner">
<div class="grid_18 finnafititle">
	<img src="{$url}/interface/themes/ndl/images/finna-logo_black_notext.png" /><h2>Finna.fi</h2>
</div>
<div class="clear"></div>
<div class="finnafiimage responsiveColumns"><img src="{$url}/interface/themes/ndl/images/finnafrontpages/finnafi.jpg" id="finnafiscreenshot"/></div>
<div class="finnafitext">
<p>Finna.fi ger tillgång till material i Finlands <a href="{$url}/Content/Organisations">museer, bibliotek och arkiv</a>. </p> 
<p>Du kan bläddra bland och läsa <a href='{$url}/Search/Results?lookfor=&type=AllFields&prefiltered=-&filter[]=online_boolean%3A"1"&view=list'>material som finns på nätet</a>.</p>
<p>Du kan också bl.a. <a href="{$url}/MyResearch/Home">förnya lån och reservera material</a> i olika bibliotek på ett och samma ställe.</p>
<p>I Finna hittar du allt tillgängligt material som de medverkande organisationerna erbjuder med samma sökning.</p>
</div>
<div class="clear"></div>
{/capture}
{capture append="sections"}
<div class="grid_24 grid_24_inner">
<div class="grid_20 otherfinnasites">
	<h2>Andra Finna-söktjänster</h2>
    <p>Finna är en helhet av söktjänster, med många organisationsspecifika webbsidor utöver den nationella webbplatsen finna.fi. Sökningen på de olika organisationernas webbsidor begränsar sig i huvudsak till den aktuella organisationens material.</p>
</div>
<div class="clear"></div>
<div class="otherfinnascreenshots">
{include file="Content/finna-sites.tpl"}
</div>
<div class="clear"></div>
<div class="grid_20 otherfinnasites otherfinnasites_comment">
    <p><strong>Yrkeshögskole- och universitetsbibliotekens Finna-söktjänster</strong> innehåller internationellt, vetenskapligt och elektroniskt material som en utomstående aktör sammanställer och erbjuder biblioteken mot en avgift. Merparten av materialet får endast användas av högskolans studenter och anställda.</p>
</div>

</div>
<div class="clear"></div>
{/capture}
{capture append="sections"}
<div class="grid_20">
<h2>Finna är mer än en söktjänst</h2>

<p>Med Finna kan du inte bara hitta, utan också använda material. I Finna kan man bl.a. reservera material och förnya lån från följande <em>bibliotek</em>:</p>
<ul>
{foreach from=$loginTargets item=target}
<li>{translate text=$target prefix='source_'}</li>
{/foreach}
</ul>
<p>Om du har det aktuella bibliotekets lånekort kan du använda tjänsterna genom att <a href="{$url}/MyResearch/Home">logga in på Finna</a>.</p>
<p>Man kan ansöka om behörighet till vissa <em>arkivmaterial</em> via länkarna i posten.</p>
<p>I framtiden kommer man också att kunna använda <em>museernas</em> digitala tjänster i Finna.</p>
</div>
{/capture}
{capture append="sections"}
<div class="grid_20">
<h2>Om Finna</h2>

<h3>Rätt att använda materialet</h3>
<p>Finnas katalogiseringsinformation är fritt tillgänglig för alla, men användningen av digitala bilder, baksidestexter, digitalt innehåll som Finna länkar till och beskrivningar kan vara begränsad genom lag eller avtal. Läs <a href="{$url}/Content/terms_conditions#terms">mer om rätten att använda materialet</a>.</p>
<h3>Utvecklingen av Finna</h3>
<p>Finna är en tjänst som utvecklas stegvis allt eftersom nya organisationer ansluter sig. Betaversionen lanserades i december 2012 och den första egentliga versionen i oktober 2013. Om du inte hittar den information du söker i Finna i dag, kommer den kanske att finnas där i framtiden.</p>

<h3>Finnas ansvariga parter</h3>
<p>
Nationalbiblioteket ansvarar för utvecklingen och administrationen av Finna, men tjänsten utvecklas tillsammans med Finnas samarbetspartner. De <a href='{$url}/Content/Organisations'>arkiv, bibliotek och museer</a> som medverkar i Finna ansvarar för innehållet. Finna är en del av undervisnings- och kulturministeriets projekt <a href='http://www.kdk.fi/sv/information-om-projektet'>Det nationella digitala biblioteket</a> (NDL).
</p>
<h3>Finnas program</h3>
<p>Finna har skapats med hjälp av VuFind och andra program med öppen källkod, och Finnas källkod får användas fritt. Läs <a href="http://www.kdk.fi/fi/asiakasliittyma/ohjelmiston-kehittaeminen" target="_blank">mer om utvecklingen av programmet</a>.</p>
</div>
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}
</div>

<!-- END of: Content/about.sv.tpl -->
