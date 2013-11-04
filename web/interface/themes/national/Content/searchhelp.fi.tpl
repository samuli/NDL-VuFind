<!-- START of: Content/searchhelp.fi.tpl -->

{assign var="title" value="Käyttöohjeet"}


{capture append="sections"}
  {literal}
  <h2 title="Basic Search" id="basicsearch">Perushaku</h2>
  	<p>Pelkällä välilyönnillä erotetut hakusanat käyttäytyvät AND-hakulogiikalla eli hakutuloksien tulee sisältää kaikki antamasi hakusanat.</p><p>Esimerkiksi <i>mannerheim carl</i> on sama haku kuin <i>mannerheim AND carl</i>.</p>
Voit esirajata haun valitsemalla pudotusvalikosta joko tietyn sektorin (museo, arkisto, kirjasto) tai aineistotyypin (kirja, artikkeli, jne.)</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Basic Search" id="narrowsearch">Haun rajaaminen</h2>
  <p>Rajaa hakua -valikon avulla voit rajata hakuasi aineistotyypin (esim. kuva), organisaation (esim. Kansallisarkisto) tai kielen mukaan.</p>
<p>Hakutulosjoukkoa saa rajattua suppeammaksi käyttämällä useita rajauksia</p>
<p>Valikko näyttää oletusarvoisesti eniten hakutuloksia keränneet hakuarvot ylimmäisenä.</p>
	  <h3>Vuosirajaus ja aikajana <span class="timelineview" style="margin-left:10px"></span></h3>
	  <p>Voit rajata valmistusvuosia joko kirjoittamalla tietyt vuosivälit joille haku kohdistuu tai käyttämällä visuaalista aikajanatyökalua. <p>
<span class="icon dynatree-expander"></span>Nuolta klikkaamalla voit valita näkyville alemman hierarkiatason sijainteja tai aineistoa (esim. kooste, arkistosarja, DVD).</p>
	  <p><span class="fixposition deleteButtonSmall"></span><span class="fixline">Voit poistaa tehtyjä rajauksia <strong>Rajaa hakua</strong> -valikon alta.</span></p>   
    	<h3>Säilytä käytössä oleva rajaus</h3>
    <p>Valinta säilyttää tekemäsi rajaukset rajaa hakua -valikossa. Tekemäsi rajaukset säilyvät oletusarvoisesti uutta perushakua tehtäessä. Jos haluat tehdä uuden haun ilman rajauksia, poista tämä valinta</p>
    {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Advanced Search" id="advancedsearch">Tarkennettu haku</h2>
  	<h3>Hakukentät</h3>
  	<p>Tarkennetun haun sivulla on useita hakukenttiä, joihin voi kirjoittaa hakutermejä ja –lausekkeita sekä hakuoperaattoreita.</p>
  	<p>Jokaisen hakukentän vieressä on alasvetovalikko, josta voi valita, mihin tietueen kenttään haku kohdistetaan (kaikki kentät, otsikko, tekijä, ym.). Useita termejä yhdistelevän haun voi tarvittaessa kohdistaa useampaan kenttään</p>
 	 <h3>Hae-valikko</h3>
 	 <p>Hae-valikko määrittelee, miten useita hakukenttiä sisältävä kysely käsitellään: </p>
 	 <ul>
 	 <li>
 	 	<strong>Kaikilla termeillä (AND)</strong> — Tuottaa tulokseksi tietueet, jotka täsmäävät kaikkien hakukenttien sisältöön.
 	 </li>
 	 <li>
 	 	<strong>Millä tahansa termillä (OR)</strong> — Tuottaa tulokseksi tietueet, jotka täsmäävät yhden tai useamman hakukentän sisältöön. 
 	 </li>
 	 <li>
 	 	<strong>Ei millään termeistä (NOT)</strong> — Tuottaa tulokseksi tietueet, joissa ei esiinny yhdenkään hakukentän sisältöä. 
 	 </li>
 	 
 	<p>Lisää hakukenttä –painikkeella lomakkeelle pystyy lisäämään uuden hakukentän. </p>
  </li>
  <li>
  	<strong>Lisää hakuryhmä</strong> –painike lisää uuden ryhmän hakukenttiä
  </li>
  <li>
	<strong>Poista hakuryhmä</strong> –painikkeella ryhmiä voidaan poistaa.
  </li>
  </ul>
  
  
	<p>Hakuryhmien välisiä suhteita määritellään käyttäen <strong>Kaikki ryhmät (AND)</strong> ja <strong>Mitkä tahansa ryhmät (OR)</strong> –hakuoperaattoreita. </p>
   <ul>
   <li>
	Yllä olevan esimerkin Intian tai Kiinan historiasta voi hakuryhmien avulla toteuttaa seuraavasti: 
   </li>
   <li>
	Ensimmäisen hakuryhmän hakukenttiin lisätään termit "Intia" ja "Kiina" ja määritellään hakukenttien välinen suhde <strong>Hae</strong>-alasvetovalikosta <strong>Millä tahansa termillä (OR).</strong>	
   </li>
   <li>
	Luodaan uusi hakuryhmä ja lisätään sen hakukenttään termi "historia". Hakuryhmien väliseksi suhteeksi määritellään <strong>Kaikki ryhmät (AND).</strong>
	</li>
  	</ul>
	{/literal}
{/capture}
{capture append="sections"}
  <h2 title="My account" id="myaccount">Oma tili ja kirjautuminen</h2>
  <p>Kirjautuneet käyttäjät voivat esimerkiksi tallentaa hakuja, kommentoida Finnan sisältöjä ja varata teoksia kirjastokortilla, jos kirjasto on mukana Finnassa.</p>
  <h3>Kirjautuminen sisään</h3>
   <p>
   		Voit kirjautua sisään valitsemalla ylävalikosta <a href="{$url}/MyResearch/Home">Kirjaudu sisään.</a> Kirjautumistapoja on kolme:
   </p>
   <ul>
	 <li>
	 	<strong>Mozilla Persona -tunnuksen</strong> voivat luoda kaikki käyttäjät. Tunnukseen voi myös liittää oman kirjastokortin, jos kirjasto on mukana Finnassa. 
	 </li>
	 <li>
	   <strong>HAKA-kirjautuminen</strong> on tarkoitettu erityisesti korkeakoulujen opiskelijoille ja henkilökunnalle. Palveluun voi liittää oman, Finnassa mukana olevan kirjaston kirjastokortin sisäänkirjautumisen jälkeen.
	 </li>
	 <li>
	   <p>Jos kirjastosi on mukana Finnassa voit kirjautua suoraan omalla <strong>kirjastokortilla.</strong></p><p> 
	   <a href="{$url}/Content/Organisations">Katso Finnassa mukana olevat kirjastot, joiden kirjastokorteilla voit kirjautua</a></p>
	 </li>
   </ul>
   <h3>Oman tilin toiminnot:</h3>
   <h4>Suosikit</h4>
  	 <p>Voit lisätä tietueita suosikeiksi hakutulos- tai tietuesivulla sydämenmuotoisella painikkeella. Voit järjestellä valittuja tietueita erilaisiksi suosikkilistoiksi, viedä tietueet Refworksiin, lähettää ne sähköpostilla tai tulostaa MARC-muodossa.</p> 
   <h4>Tallennetut haut, hakuhistoria ja uutuusvahti</h4>
   <p>Voit tallentaa viimeisimmät hakusi joko hakutulossivulla tai tallennettujen hakujen viimeisimmistä hauista Tallenna-painikkeella. Tallennetut haut näkyvät ylimmäisenä.</p>
   <p>Voit asettaa uutuusvahdin tallennetuille hauille joko viikoittain tai päivittäin. Ilmoitukset uutuuksista tulevat sähköpostiisi.</p> 
   	 <p></p>
   <h4>Lainat</h4>
   	 <p>Voit tarkastella lainojasi ja uusia lainassa olevaa aineistoa.</p>
   <h4>Varaukset ja tilaukset</h4>
     <p>Tarkastele tekemiäsi varauksia ja tilauksia kirjastokortillasi. Voit perua varauksiasi tällä välilehdellä./p>
     <h4>Maksut</h4>
     	<p>Näe kirjastokortillesi merkityt maksut esimerkiksi myöhästyneistä lainoista.</p>
    <h4>Kirjastokortit ja kirjastokortin liittäminen</h4>
     <p>Voit lisätä Finnaan oman kirjastokorttisi Lisää-painikkeella, jos kirjastosi on liitetty mukaan Finnaan. Voit lisätä useita kirjastokortteja.</p>
    <h4>Omat tiedot</h4>
     <p>Voit vaihtaa sähköpostiosoitteesi, asettaa eräpäivämuistutuksen sekä valita ensisijaisen kirjaston, jonne haluat varauksesi ja kaukolainasi.</p>
	 <p>Kirjaston yhteystietoja voit muuttaa ottamalla yhteyttä omaan kirjastoosi.</p>
	 <h4>PIN-koodin tai salasanan vaihtaminen</h4>
	 <p>Voit vaihtaa salasanaa tai PIN-koodia Omat tiedot -välilehdellä.</p>
	 	     
	{/capture}
	{capture append="sections"}
  <h2 title="Contact us" id="contactus">Palaute</h2>
	<p>Voit lähettää palautetta Finnasta <a href="{$url}/Feedback/Home">yleisen palautelomakkeen</a> avulla esimerkiksi käyttöliittymästä ja teknisistä asioista. Palaute ohjautuu Kansalliskirjastolle, jossa se käsitellään ja ohjataan edelleen asiasta vastaavalle taholle.</p>
	<p>Mikäli haluat antaa palautetta palvelun sisällöistä tai aineistoja koskevista tiedoista, kannattaa käyttää yksittäisen tietuesivun <strong>Lähetä palautetta</strong> -linkkiä. Tämä palaute ohjautuu siihen organisaatioon, joka on toimittanut kyseisen aineiston Finnaan.</p>
	{/capture}
	{capture append="sections"}
  {literal}
  <h2 title="Boolean operators" id="booleanoperators">Loogiset hakuoperaattorit</h2>
  <p>Termejä voi yhdistellä monimutkaisemmiksi kyselyiksi Boolean-hakuoperaattoreilla. Seuraavat operaattorit ovat käytettävissä: <strong>AND</strong>, <strong>+</strong>, <strong>OR</strong>, <strong>NOT</strong> ja <strong>-</strong>.
  </p>
  <p><strong>Huomio!</strong> Boolean-hakuoperaattorit hauissa kirjoitetaan ISOIN KIRJAIMIN.</p>
  <h3 title="AND">AND</h3>
  <p><strong>AND</strong> eli konjunktio-operaattori on järjestelmän oletusarvoinen operaattori monitermisille kyselyille, joihin ei ole sisällytetty mitään operaattoria. <strong>AND</strong>-operaattoria käytettäessä kyselyn tuloksena saadaan tietueet, joissa esiintyy kukin hakukentissä esiintyvistä termeistä.
  </p>
  <p>Esimerkki: etsitään tietueita, joissa esiintyy sekä "economics" että "Keynes":
  </p>
  <pre class="code">economics Keynes</pre>
  <p>tai</p>
  <pre class="code">economics AND Keynes</pre>
  <h3 title="+">+</h3>
  <p>Merkillä <strong>+</strong> voidaan ilmaista vaatimusta siitä, että termin on esiinnyttävä jokaisessa hakutuloksessa.
  </p>
  <p>Esimerkki: etsitään tietueita, joissa esiintyy ehdottomasti "economics" ja joissa voi lisäksi esiintyä "Keynes":
  </p>
  <pre class="code">+economics Keynes</pre>
  <h3 title="OR">OR</h3>
  <p><strong>OR</strong>-operaattorin käyttö haussa tuottaa tulokseksi tietueita, joissa esiintyy yksi tai useampi operaattorin yhdistämistä termeistä.
  </p>
  <p>Esimerkki: etsitään tietueita, joissa esiintyy joko "economics Keynes" tai ainoastaan "Keynes":
  </p>
  <pre class="code">"economics Keynes" OR Keynes</pre>
  <h3 title="NOT">NOT / -</h3>
  <p><strong>NOT</strong>-operaattori poistaa hakutuloksista tietueet, joissa esiintyy kyselyssä <strong>NOT</strong>-operaattoria seuraava termi.
  </p>
  <p>Esimerkki: etsitään tietueita, joissa on termi "economics" mutta ei termiä "Keynes":
  </p>
  <pre class="code">economics NOT Keynes</pre>
  <p>Huomio! NOT-operaattoria ei voi käyttää yksitermisissä kyselyissä.</p>
  <p>Esimerkki: seuraava kysely ei tuota lainkaan tuloksia:</p>
  <pre class="code">NOT economics</pre>
  <p><strong>NOT</strong>-operaattorin voi korvata operaattorilla <strong>-</strong>.
  </p>
  <h3 title="Phrase searches">Fraasihaut</h3>
  <p>Tarkan fraasihaun voi tehdä kirjoittamalla hakusanat lainausmerkkeihin.</p>
  <p>Esimerkki: etsitään vain tietueita, joissa on termi "keskiajan historia", ei esimerkiksi "keskiajan kulttuurihistoria":
  </p>
  <pre class="code">"keskiajan historia"</pre>
  <p>Fraasihakua voi käyttää myös yksittäisen hakusanan kohdalla, jolloin haku kohdistuu vain annettuun hakusanaan, eikä esimerkiksi muihin taivutusmuotoihin.
  </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Wildcard Searches" id="wildcardsearches">Jokerimerkit</h2>
  <p><strong class="helpTerm">?</strong> korvaa yhden merkin hakutermistä.</p>
  <p>Esimerkki: termejä "text" ja "test" voidaan hakea samalla kyselyllä:</p>
  <pre class="code">te?t</pre>
  <p><strong class="helpTerm">*</strong> korvaa 0, 1 tai useampia merkkejä hakutermistä.
  </p>
  <p>Esimerkki: termejä "test", "tests" ja "tester" voidaan hakea kyselyllä:</p>
  <pre class="code">test*</pre>
  <p>Jokerimerkkejä voi käyttää myös hakutermin keskellä:</p>
  <pre class="code">te*t</pre>
  <p>Huomio! Jokerimerkkejä <strong>?</strong> ja <strong>*</strong> ei voi käyttää hakutermin ensimmäisenä merkkinä.
  </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Fuzzy Searches" id="fuzzysearches">Sumeat haut</h2>
  <p>Sumea haku hakee myös sellaisia tuloksia, joissa on mainittu hakusanan kaltainen sana</p>
  <p><strong class="helpTerm">~</strong> toteuttaa sumean haun yksisanaisen haun viimeisenä merkkinä.
  </p>
  <p>Esimerkki: sumea haku termille "roam":</p>
  <pre class="code">roam~</pre>
  <p>Tämä haku löytää esimerkiksi termit "foam" ja "roams".</p>
  <p>Haun samankaltaisuutta kantatermiin voidaan säädellä parametrilla, jonka arvo on välillä 0 ja 1. Mitä lähempänä annettu arvo on lukua 1, sen samankaltaisempi termin on oltava kantatermin kanssa.
  </p>
  <pre class="code">roam~0.8</pre>
  <p>Oletusarvona parametrille on 0.5, jos arvoa ei sumeassa haussa erikseen määritetä.
  </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Proximity Searches" id="proxitimitysearches">Etäisyyshaut</h2>
  <p>Etäisyyshaulla saadaan tuloksia, joissa hakusanat ovat lähekkäin mutta niiden ei tarvitse olla välttämättä peräkkäin</p>
  <p><strong class="helpTerm">~</strong> toteuttaa etäisyyshaun monitermisen hakulausekkeen lopussa etäisyysarvon kanssa.
  </p>
  <p>Esimerkki: etsitään termejä "economics" ja "keynes" niiden esiintyessä korkeintaan 10 termin etäisyydellä toisistaan:
  </p>   
  <pre class="code">"economics Keynes"~10</pre>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Range Searches" id="rangesearches">Arvovälihaut</h2>
  <p>Arvovälihaut tehdään käyttämällä joko aaltosulkeita <strong>{ }</strong> tai hakasulkeita <strong>[ ]</strong>. Aaltosulkeita käytettäessä huomioidaan vain arvot annettujen termien välillä pois lukien kyseiset termit. Hakasulkeet puolestaan sisällyttävät myös annetut termit etsittävälle arvovälille.
  </p>
  <p>Esimerkki: etsittäessä termiä, joka alkaa kirjaimella B tai C, voidaan käyttää kyselyä:
  </p>
  <pre class="code">{A TO D}</pre>
  <p>Esimerkki: etsittäessä arvoja 2002&mdash;2003 voidaan haku tehdä seuraavasti:
  </p>
  <pre class="code">[2002 TO 2003]</pre>
  <p>Huomio! Sana TO arvojen välillä kirjoitetaan ISOIN KIRJAIMIN.</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Boosting a Term" id="boostingaterm">Termin painottaminen</h2>
  <p><strong class="helpTerm">^</strong> nostaa termin painoarvoa kyselyssä.</p>
  <p>Esimerkki: haussa termin "Keynes" painoarvoa on nostettu:</p>
  <pre class="code">economics Keynes^5</pre>
  {/literal}
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections menu=true}

<!-- END of: Content/searchhelp.fi.tpl -->
