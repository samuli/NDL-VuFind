<!-- START of: Content/Organisations.fi.tpl -->

{assign var="title" value="navigation_organizations"|translate"}
<div class="sectionsWithHeadings whoparticipates">

{capture append="sections"}
{include file="Content/organisationlist.tpl"}
{/capture}

{capture append="sections"}
 <div class="grid_24">
    <h2>Får jag använda materialet?</h2>
 </div>
 <div class="grid_24 bodytextwrapper">
    <p>Nedan beskrivs vem som får använda de olika organisationernas material i den nationella portalen finna.fi, samt hur och var materialet får användas.</p>
    <!-- TODO comment out when organization page is in implementation
    <p>Organisationerna erbjuder ofta också andra tjänster än de som nämns nedan. Mer information om dem hittar du i presentationerna, som du kommer till genom att klicka på organisationens namn i listan ovan.</p>
    -->
 </div>
 <div class="grid_24 grid_24_inner forWhomContainer">
  <div class="grid_7 forWhomWrapper">
   <div class="domains bodytextwrapper">
      <h3>{translate text="Archive_plural"}</h3>
      <p class="">Största delen av arkivens material kan man läsa på plats i arkiven. Forskare, studenter och andra kan ansöka om tillstånd att använda material med begränsad tillgång för forskningsändamål. Oftast beviljas tillståndet.</p>
      <p class="">Alla arkiv som medverkar i Finna har överfört sådant material som är fritt tillgängligt på nätet.</p>
      <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%220%2Farc%2F%22&sort=relevance&view=list">Arkivens material i finna.fi<span class="magnifier">&nbsp;</span></a>
   </div>
  </div>
  <div class="grid_10 forWhomWrapper">
    <div class="domains bodytextwrapper">
      <h3>{translate text="Scientific_library_plural"}</h3>
      <p class="hyphenatelongwords">I de flesta universitets- och yrkeshögskolebiblioteken får vem som helst låna material.</p>
      <p class="hyphenatelongwords">Man måste inte alltid ens skaffa ett nytt kort för att få rätt att låna material i ett bibliotek, i vissa fall kan man lägga till lånerätten till det kort som kunden redan använder. Lånerätten beviljas oftast av bibliotekens kundtjänst.</p>
      <a class="link hyphenatelongwords" href="{$url}/Search/Results?lookfor=sector_str_mv%3A1%2Flib%2Funi%2F+OR+sector_str_mv%3A1%2Flib%2Fpoly%2F&prefiltered=-&SearchForm_submit=Hae&limit=20&sort=relevance&retainFilters=0">Universitets- och yrkeshögskolebibliotekens material i finna.fi<span class="magnifier">&nbsp;</span></a>
      <h3>{translate text="Public_library_long_plural"}</h3>
      <p>Vem som helst får låna böcker och annat material i de allmänna biblioteken i Finland. För att få ett lånekort kan det krävas att man har en adress i Finland.</p>
      <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%221%2Flib%2Fpub%2F%22&sort=relevance&view=list">De allmänna bibliotekens material i finna.fi<span class="magnifier">&nbsp;</span></a>
   </div>
  </div>
  <div class="grid_7 forWhomWrapper">
     <div class="domains bodytextwrapper">
        <h3>{translate text="Museum_plural"}</h3>
        <p>I Finna får du tillgång till material på nätet som inte visas i museet och som t.ex. bara forskare har haft tillgång till tidigare.</p>
        <p class="">Många museer erbjuder en möjlighet att ansöka om rätt att mot betalning använda bilder eller beställa bilder som kan tryckas.</p>
        <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%220%2Fmus%2F%22&sort=relevance&view=list">Museernas material i finna.fi<span class="magnifier">&nbsp;</span></a>
     </div>
  </div>
 </div>
{/capture}

{capture append="sections"}

<div class="grid_24 grid_24_inner bodytextwrapper">
   <h2>Mer om ämnet på andra sidor</h2>
   <p>På sidan <a href="{$path}/Content/terms_conditions">{translate text='navigation_terms_conditions'}</a> finns mer information om rätten att använda materialet som finns i Finna.</p>
   <p>Sidan <a href="{$path}/Content/about">{translate text='navigation_about_finna'}</a> innehåller information om Finnas olika webbsidor och funktioner.</p>
</div>
{/capture}

{include file="$module/content.tpl" title=$title sections=$sections}
</div>

<!-- END of: Content/Organisations.fi.tpl -->
