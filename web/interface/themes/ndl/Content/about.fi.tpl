<!-- START of: Content/about.fi.tpl -->

{assign var="title" value="Mikä Finna on?"}
<div class="sectionsWithHeadings aboutpage">
{capture append="sections"}
<div class="grid_24 grid_24_inner">
<div class="grid_18 finnafititle">
	<img src="{$url}/interface/themes/ndl/images/finna-logo_black_notext.png" /><h2>Finna.fi</h2>
</div>
<div class="clear"></div>
<div class="finnafiimage responsiveColumns"><img src="{$url}/interface/themes/ndl/images/finnafrontpages/finnafi.jpg" id="finnafiscreenshot"/></div>
<div class="finnafitext">
<p>Finna.fi tuo Suomen <a href="https://www.finna.fi/Content/Organisations">museoiden, kirjastojen ja arkistojen</a> aineistot kaikkien saataville. </p> 
<p>Pääset selaamaan ja lukemaan <a href='https://www.finna.fi/Search/Results?lookfor=&type=AllFields&prefiltered=-&filter[]=online_boolean%3A"1"&view=list'>verkossa saatavilla</a> olevia aineistoja.</p>
<p>Voit myös mm. <a href="https://www.finna.fi/MyResearch/Home">uusia lainoja ja tehdä varauksia</a> eri kirjastojen aineistoihin yhdestä ja samasta paikasta.</p>
<p>Löydät finna.fi:stä samalla haulla kaikille avoimet aineistot, jotka mukana olevat organisaatiot tarjoavat.</p>
</div>
<div class="clear"></div>
{/capture}
{capture append="sections"}
<div class="grid_24 grid_24_inner">
<div class="grid_20 otherfinnasites">
	<h2>Muut Finna-hakupalvelut</h2>
    <p>Finna on hakupalvelujen kokonaisuus, johon kuuluu monia sivustoja valtakunnallisen finna.fi:n lisäksi. Organisaatiokohtaiset sivustot ovat rajattuja pääasiassa yhden organisaation aineistoihin.</p>
</div>
<div class="clear"></div>
<div class="otherfinnascreenshots">
{include file="Content/finna-sites.tpl"}
</div>
<div class="clear"></div>
<div class="grid_20 otherfinnasites otherfinnasites_comment">
    <p><strong>AMK- ja yliopistokirjastojen Finna-sivustot</strong> sisältävät kansainvälisiä, tieteellisiä, sähköisiä aineistoja, jotka ulkopuolinen toimija koostaa ja tarjoaa ja jotka ovat maksullisia kirjastoille. Valtaosa näistä on rajattu korkeakoulun opiskelijoiden ja henkilökunnan käyttöön.</p>
</div>

</div>
<div class="clear"></div>
{/capture}
{capture append="sections"}
<div class="grid_20">
<h2>Finna on muutakin kuin hakupalvelu</h2>

<p>Finnan avulla voit paitsi löytää, myös käyttää aineistoja. Tällä hetkellä seuraavat <em>kirjastot</em> tarjoavat Finnassa varaus-, lainan uusimis- ja muita toiminnallisuuksia:</p>
<ul>
{foreach from=$loginTargets item=target}
<li>{translate text=$target prefix='source_'}</li>
{/foreach}
</ul>
<p>Voit käyttää näitä toiminnallisuuksia, kun olet <a href="https://www.finna.fi/MyResearch/Home">kirjautunut Finnaan</a> ja sinulla on kyseisen kirjaston kirjastokortti.</p>
<p>Joihinkin <em>arkistoaineistoihin</em> voi tehdä käyttölupahakemuksen Finnan aineistotietojen yhteydestä löytyvillä linkeillä.</p>
<p>Tulevaisuudessa Finnassa on mahdollista käyttää myös <em>museoiden</em> digitaalisia palveluja.</p>
</div>
{/capture}
{capture append="sections"}
<div class="grid_20">
<h2>Tietoa Finnasta</h2>

<h3>Käyttöoikeudet</h3>
<p>Finnan luettelointitieto on vapaasti kaikkien käytössä, mutta Finnassa näkyviin digitaalisiin kuviin, takakansiteksteihin ja Finnasta linkattuihin digitaalisiin sisältöihin ja kuvailutietoihin voi liittyä lakiin tai sopimuksiin perustuvia rajoituksia. Lue <a href="{$url}/Content/terms_conditions#terms">lisätietoa käyttöoikeuksista.</a></p>
<h3>Finnan kehittäminen</h3>
<p>Finna on palvelu, jota kehitetään vaiheittain sitä mukaa, kun uusia organisaatioita liittyy mukaan. Finnan beta-versio avattiin joulukuussa 2012 ja ensimmäinen versio lokakuussa 2013. Vaikka et siis ehkä vielä löydä hakemaasi tietoa Finnasta, se saattaa tulla sinne tulevaisuudessa. 
</p>

<h3>Finnan vastuutahot</h3>
<p>
Kansalliskirjasto vastaa Finnan kehittämisestä ja ylläpidosta, mutta palvelua kehitetään yhdessä Finnan yhteistyökumppanien kanssa. Finnan sisällöistä vastaavat palveluun osallistuvat <a href='https://www.finna.fi/Content/Organisations'>arkistot, kirjastot ja museot</a>. Finna on osa opetus- ja kulttuuriministeriön <a href='http://www.kdk.fi/fi/tietoa-hankkeesta'>Kansallinen digitaalinen kirjasto</a> -hanketta.
</p>
<h3>Finnan ohjelmisto</h3>
<p>Finna on toteutettu VuFind- ja muilla avoimen lähdekoodin ohjelmistoilla, ja sen lähdekoodi on kaikkien halukkaiden hyödynnettävissä. Lue <a href="http://www.kdk.fi/fi/asiakasliittyma/ohjelmiston-kehittaeminen">lisätietoa ohjelmiston kehittämisestä</a>.</p>
</div>
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}
</div>

<!-- END of: Content/about.fi.tpl -->
