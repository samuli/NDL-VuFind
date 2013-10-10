<!-- START of: Content/terms_conditions.fi.tpl -->

{assign var="title" value="Käyttöehdot"}
{capture append="sections"}{literal}
<div class="grid_16">
<p>Finnan käyttäjät voivat hakea tietoa arkistojen, kirjastojen ja museoiden aineistoista. Aineistojen käyttöä koskevat seuraavat ehdot:</p>
<ul>
<li><strong>Kuvailutiedot:</strong> Hakutulosten yhteydessä esitettäviä kuvailutietoja voivat kaikki käyttää vapaasti.</li>
<li>
<strong>Digitaaliset aineistot:</strong> Digitaalisten aineistojen kohdalla Finnassa on linkki aineistoa hallinnoivan organisaation sivustolle. Näillä sivustoilla oleviin aineistoihin voi liittyä lakiin tai sopimuksiin liittyviä oikeuksia tai rajoituksia. Oikeuksista ja rajoituksista kerrotaan sisältöjä hallinnoivien organisaatioiden sivustoilla.</li>
<li>
<strong>Kuvat:</strong> Joidenkin aineistojen kohdalla Finnassa on kuva esimerkiksi museoesineestä, taideteoksesta, valokuvasta tai kirjan kannesta. Näihin ns. esikatselukuviin voi liittyä käytön rajoituksia samalla tavalla kuin aineistoja hallinnoivien organisaatioiden sivustoilla oleviin aineistoihin.
</li>
</ul>
<!-- TÄMÄ VASTA KUN TUONTANNOSSA:
<p>: Aineiston geokoodauksessa on käytetty OpenStreetMapin avointa dataa, joka on lisensoitu <a href="http://opendatacommons.org/licenses/odbl/
">Open Data Commons Open Database</a> lisenssillä.</p> -->
</div>
{/literal}{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}
<!-- END of: Content/terms_conditions.fi.tpl -->