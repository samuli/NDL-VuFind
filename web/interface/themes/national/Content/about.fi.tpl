<!-- START of: Content/about.fi.tpl -->

{assign var="title" value="Tietoa Finnasta"}
{capture append="sections"}
<div class="grid_18">
<h3>Suomen arkistojen, kirjastojen ja museoiden aarteet samalla haulla</h3>

<p>Finna tarjoaa pääsyn arkistojen, kirjastojen ja museoiden aineistoihin ja palveluihin. Tällä hetkellä Finnassa on mukana kymmenien organisaatioiden aineistoja. Finnasta voit etsiä tietoa kirjastojen ja arkistojen kokoelmista, katsella kuvia museoesineistä ja taideteoksista sekä ladata käyttöösi asiakirjoja ja vanhoja kirjoja. Kirjautuneille käyttäjille Finna tarjoaa erilaisia lisätoiminnallisuuksia.
</p> 

<p>Finna on tarkoitettu kaikille Suomen arkistojen, kirjastojen ja museoiden käyttäjille. Toisin kuin muiden hakupalveluiden, Finnan sisältö on asiantuntijaorganisaatioiden tuottamaa ja siten luotettavaa. Finnan hakutoiminnallisuudet on toteutettu parantamaan aineistojen löydettävyyttä ja käyttöä.</p>

<h3>Aineistojen käyttö ja lainaus</h3>

<p>Osasta aineistoa kuten lainattavista kirjoista on olemassa tekstimuotoiset kuvailutiedot ja varsinainen sisältö on esimerkiksi kirjaston hyllyssä. Mikäli etsimäsi teos on saatavilla Finnassa mukana olevassa kirjastossa ja sinulla on tämän kirjaston kortti, voit tehdä siihen varauksen. Mikäli sinulla ei ole kirjastokorttia, paras tapa saada teos käyttöösi on kysyä sitä omasta lähikirjastostasi.</p>

<p>Esineiden ja taideteoksien kohdalla Finnassa näytetään hakutuloksessa kuva. Museolla voi olla hallussaan myös korkealaatuinen painokelpoinen kuva, jonka voi tilata suoraan museolta. 
</p>

<p>Lisäksi Finnasta on mahdollista hakea digitaalista sisältöä kuten artikkeleita, vanhoja kirjoja, sanomalehtiä, karttoja, kuvia ja äänitteitä. Näihin pääsee tutustumaan Finnassa olevan linkin kautta. 
</p>

<p>Finnasta löytyy myös tietoa arkistoissa säilytettävistä asiakirjoista, jotka ovat arkistolaitoksen viranomaisarkistoaineistoa. Osa näistä asiakirjoista on saatavilla digitaalisina. Osa asiakirjoista pitää tilata ja lukea arkistolaitoksen toimitiloissa. 
</p>
<p>
Finnan kuvailutieto on vapaasti kaikkien käytössä, mutta Finnassa näkyviin digitaalisiin kuviin tai Finnasta linkattuihin digitaalisiin sisältöihin voi liittyä lakiin tai sopimuksiin perustuvia rajoituksia. Lue lisätietoa <a href='{$url}/Content/terms_conditions'>käyttöoikeuksista.</a>
</p>

<h3>Finnan kehittäminen</h3>
<p>Finna on palvelu, jota kehitetään vaiheittain sitä mukaa, kun uusia organisaatioita liittyy mukaan. Finnan beta-versio avattiin joulukuussa 2012 ja ensimmäinen versio lokakuussa 2013. Vaikka et siis ehkä vielä löydä hakemaasi tietoa Finnasta, se saattaa tulla sinne tulevaisuudessa! 
</p>

<h3>Finnan vastuutahot</h3>
<p>
Kansalliskirjasto vastaa Finnan kehittämisestä ja ylläpidosta, mutta palvelua kehitetään yhdessä Finnan yhteistyökumppanien kanssa. Finnan sisällöistä vastaavat palveluun osallistuvat <a href='{$url}/Content/organisations'>arkistot, kirjastot ja museot</a>. Finna on osa opetus- ja kulttuuriministeriön <a href='http://www.kdk.fi/fi/tietoa-hankkeesta'>Kansallinen digitaalinen kirjasto</a> -hanketta 
</p>

<h3>Finnan palvelukokonaisuus</h3>
<p>
Tämä on arkistojen, kirjastojen ja museoiden yhteinen Finna-näkymä. Tämän verkkopalvelun lisäksi organisaatiot voivat toteuttaa omia Finna-näkymiään. Tällä hetkellä muita Finna-näkymiä ovat: <a href="https://jyu.finna.fi/">JYX</a>, <a href="https://museot.finna.fi/">Museo-Finna</a> ja <a href="">Kansalliskirjaston Finna</a>.
</p>

<h3>Finnan ohjelmisto</h3>

Finna on toteutettu VuFind- ja muilla avoimen lähdekoodin ohjelmistoilla, ja sen lähdekoodi on kaikkien halukkaiden hyödynnettävissä. Lue lisätietoa <a href="http://www.kdk.fi/fi/asiakasliittyma/ohjelmiston-kehittaeminen" target="_blank">ohjelmiston kehittämisestä</a>.
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/about.fi.tpl -->
