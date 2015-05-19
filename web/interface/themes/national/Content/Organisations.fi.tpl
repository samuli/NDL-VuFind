<!-- START of: Content/Organisations.fi.tpl -->

{assign var="title" value="navigation_organizations"|translate"}
<div class="sectionsWithHeadings whoparticipates">

{capture append="sections"}
{include file="Content/organisationlist.tpl"}
{/capture}

{capture append="sections"}
 <div class="grid_24">
    <h2>Voinko käyttää aineistoja?</h2>
 </div>
 <div class="grid_24 bodytextwrapper">
    <p>Alla kerrotaan kuka, miten ja missä voi käyttää eri organisaatioiden valtakunnallisessa finna.fi -palvelussa tarjoamia aineistoja.</p>
    <!-- TODO comment out when organization page is in implementation
    <p>Yksittäiset organisaatiot tarjoavat usein muitakin palveluja alla mainittujen lisäksi. Näistä löytyy tietoa organisaatioideesittelysivuilta. Löydät organisaation esittelysivun klikkaamalla organisaation nimeä yllä olevissa listoissa.</p>
    -->
 </div>
 <div class="grid_24 grid_24_inner forWhomContainer">
  <div class="grid_7 forWhomWrapper">
   <div class="domains bodytextwrapper">
      <h3>{translate text="Archive_plural"}</h3>
      <p class="">Voit tutustua suurimpaan osaan arkistojen aineistoista paikan päällä arkiston tiloissa. Tutkijat, opiskelijat ja kansalaiset voivat hakea käyttörajoitettuihin aineistoihin tutkimuslupaa, joka yleensä pyritään myöntämään.</p>
      <p class="">Kaikki mukana olevat arkistot ovat tuoneet Finnaan verkossa saatavilla olevia aineistojaan, joihin kenellä tahansa on pääsy.</p>
      <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%220%2Farc%2F%22&sort=relevance&view=list">Arkistojen aineistot finna.fi:ssä <span class="magnifier">&nbsp;</span></a>
   </div>
  </div>
  <div class="grid_10 forWhomWrapper">
    <div class="domains bodytextwrapper">
      <h3>{translate text="Scientific_library_plural"}</h3>
      <p class="hyphenatelongwords">Kuka tahansa voi lainata useimpien yliopisto- ja ammattikorkeakoulukirjastojen aineistoja.</p>
      <p class="hyphenatelongwords">Lainausoikeuden hankkiminen uuteen kirjastoon ei aina edellytä edes uuden kirjastokortin hankintaa, koska joissakin tapauksissa lainausoikeus voidaan lisätä olemassaolevaan kirjastokorttiin. Lainausoikeuksia myönnetään yleensä kirjastojen palvelupisteissä.</p>
      <a class="link hyphenatelongwords" href="{$url}/Search/Results?lookfor=sector_str_mv%3A1%2Flib%2Funi%2F+OR+sector_str_mv%3A1%2Flib%2Fpoly%2F&prefiltered=-&SearchForm_submit=Hae&limit=20&sort=relevance&retainFilters=0">Yliopisto- ja ammattikorkeakoulukirjastojen aineistot finna.fi:ssä <span class="magnifier">&nbsp;</span></a>
      <h3>{translate text="Public_library_long_plural"}</h3>
      <p>Kuka tahansa voi lainata kirjoja ja muita aineistoja Suomen yleisistä kirjastoista. Kirjastokortin myöntämiseksi saatetaan vaatia suomalainen postiosoite.</p>
      <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%221%2Flib%2Fpub%2F%22&sort=relevance&view=list">Yleisten kirjastojen aineistot finna.fi:ssä <span class="magnifier">&nbsp;</span></a>
   </div>
  </div>
  <div class="grid_7 forWhomWrapper">
     <div class="domains bodytextwrapper">
        <h3>{translate text="Museum_plural"}</h3>
        <p>
   Finnassa pääset katselemaan verkossa saatavilla olevia aineistoja, jotka eivät ole näytteillä museon tiloissa, ja joihin esimerkiksi vain tutkijat ovat päässeet aiemmin käsiksi.</p>
        <p class="">Voit tilata painokelpoisia kuvia tai käyttöoikeuksia kuviin monista museoista maksullisena lisäpalveluna.
        </p>
        <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%220%2Fmus%2F%22&sort=relevance&view=list">Museoiden aineistot finna.fi:ssä <span class="magnifier">&nbsp;</span></a>
     </div>
  </div>
 </div>
{/capture}

{capture append="sections"}

<div class="grid_24 grid_24_inner bodytextwrapper">
   <h2>Aiheesta muualla</h2>
   <p>Sivulla <a href="{$path}/Content/terms_conditions">{translate text='navigation_terms_conditions'}</a> kerrotaan tarkemmin Finnassa olevien aineistojen käyttöoikeuksista.</p>
   <p>Sivu <a href="{$path}/Content/about">{translate text='navigation_about_finna'}</a> sisältää tietoa Finnaan kuuluvista sivustoista ja Finnassa tarjottavista toiminnallisuuksista.</p>
</div>
{/capture}

{include file="$module/content.tpl" title=$title sections=$sections}
</div>

<!-- END of: Content/Organisations.fi.tpl -->
