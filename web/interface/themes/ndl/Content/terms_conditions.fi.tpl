<!-- START of: Content/terms_conditions.fi.tpl -->

{assign var="title" value="Tietosuoja ja käyttöehdot"}
{capture append="sections"}{literal}
<div class="grid_18">
<h3>Asiakastietojen käsittely Finnassa</h3>
<p>Kun käyttäjä kirjautuu Finnaan kirjastokorttinsa tunnuksilla, palveluun tallennetaan kirjastokortin tunnus, PIN-koodi, etu- ja sukunimet, sähköpostiosoite ja kotikirjasto. Mozilla Persona -kirjautumisessa käyttäjätiedoista tallennetaan Finnaan automaattisesti vain sähköpostiosoite. Haka-kirjautumisessa tallennetaan Finnaan automaattisesti käyttäjätunnus, nimi ja sähköpostiosoite. Tietoja käytetään seuraaviin käyttötarkoituksiin:</p>

<table class="privacyTable">
  <tr>
	<td><strong>Tieto</strong></td>
	<td><strong>Tarkoitus</strong></td>
  </tr>
  <tr>
	<td>Kirjastokortin tunnus</td>
	<td>Käyttäjän tunnistaminen</td>
  </tr>
  <tr>
	<td>PIN-koodi</td>
	<td>Käyttäjän tunnistaminen palvelurajapintoja varten</td>
  </tr>
  <tr>
	<td>Etunimi</td>
	<td>Käyttäjän tunnistaminen ja tiedon näyttäminen</td>
  </tr>
  <tr>
	<td>Sukunimi</td>
	<td>Käyttäjän tunnistaminen ja tiedon näyttäminen</td>
  </tr>
  <tr>
	<td>Sähköpostiosoite</td>
	<td>Oletusosoite sähköpostin lähetystä varten, käyttäjän muokattavissa Finnassa</td>
  </tr>
  <tr>
	<td>Kotikirjasto</td>
	<td>Oletusnoutopiste varauksia varten, käyttäjän muokattavissa Finnassa</td>
  </tr>
</table>

<p>Finnaan tallennettuun sähköpostiosoitteeseen lähetetään vain käyttäjän itse pyytämiä sähköposteja kuten eräpäivämuistutukset ja uutuusvahdin tiedonannot.</p>
<p>
Edellä mainittujen tietojen lisäksi Finnaan voidaan tallentaa tietoja, jotka seuraavat käyttäjän toiminnasta Finnassa. Tällaisia ovat mm. käyttökieli, eräpäivämuistutusten käyttöönotto, uutuusvahdit, omiin listoihin tallennetut tietueet, itse lisätyt kirjastokortit ja sosiaalinen metadata (kommentit, arvostelut, avainsanat).
Muissa käyttäjän tietoja käsittelevissä toiminnoissa, kuten lainojen, varausten ja maksujen selauksessa sekä varausten teossa ja lainojen uusimisessa käytetään kirjastojärjestelmän palvelurajapintoja, eikä näitä tietoja tallenneta Finnaan lukuun ottamatta valinnaisia eräpäivämuistutuksia. Eräpäivämuistutusten lähetyksen yhteydessä tallennetaan lainan ID-numero ja eräpäivä. Näiden avulla voidaan varmistua siitä, että kukin eräpäivämuistutus lähetetään vain kerran.
</p>
<p>
Kirjastokortti-, Mozilla Persona- ja Haka-tunnuksia käyttäen luodut Finna-tilit ovat toisistaan erillisiä, vaikka niihin sisältyisi sama yksilöivä tunniste.
</p>
<p>
Käyttäjätietojen käsittelystä on laadittu rekisteriseloste: <a href="{/literal}{$url}{literal}/Content/register_details">Rekisteriseloste</a>
</p>
<br/>
<h3>Käyttöehdot</h3>
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