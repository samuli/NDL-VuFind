<!-- START of: Content/Organisations.fi.tpl -->

{assign var="title" value="navigation_organizations"|translate"}
<div class="sectionsWithHeadings whoparticipates">

{capture append="sections"}
{include file="Content/organisationlist.tpl"}
{/capture}

{capture append="sections"}
 <div class="grid_24">
    <h2>Can I use the material?</h2>
 </div>
 <div class="grid_24 bodytextwrapper">
    <p>Below is a description of who can use the material provided by organisations through the nationwide finna.fi service, as well as how and where it can be used.</p>
    <!-- TODO comment out when organization page is in implementation
    <p>Individual organisations also offer other services in addition to those mentioned below. Further information on these can be found on organisation introduction pages. You can navigate to the introduction pages by clicking the names of individual organisations in the lists above.</p>
    -->
 </div>
 <div class="grid_24 grid_24_inner forWhomContainer">
  <div class="grid_7 forWhomWrapper">
   <div class="domains bodytextwrapper">
      <h3>{translate text="Archive_plural"}</h3>
      <p class="">Most archive material can be browsed at the premises of individual archives. Scholars, students and ordinary citizens can apply for a research permit for browsing limited use material. In general, an attempt will be made to grant a permit.</p>
      <p class="">All participating archives have provided Finna with material accessible on the web that is freely available.</p>
      <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%220%2Farc%2F%22&sort=relevance&view=list">Archive material at finna.fi<span class="magnifier">&nbsp;</span></a>
   </div>
  </div>
  <div class="grid_10 forWhomWrapper">
    <div class="domains bodytextwrapper">
      <h3>{translate text="Scientific_library_plural"}</h3>
      <p class="hyphenatelongwords">Anyone can borrow material from most university and university of applied sciences libraries.</p>
      <p class="hyphenatelongwords">Applying for the right to borrow material from a new library does not always require applying for a new library card, since, in some cases, the right can be included in a library card acquired earlier. Borrowing rights are usually granted by library service desks.</p>
      <a class="link hyphenatelongwords" href="{$url}/Search/Results?lookfor=sector_str_mv%3A1%2Flib%2Funi%2F+OR+sector_str_mv%3A1%2Flib%2Fpoly%2F&prefiltered=-&SearchForm_submit=Hae&limit=20&sort=relevance&retainFilters=0">University and university of applied sciences library material at finna.fi<span class="magnifier">&nbsp;</span></a>
      <h3>{translate text="Public_library_long_plural"}</h3>
      <p>Anyone can borrow books and other material from public libraries in Finland. A Finnish address may be a requisite for getting a library card.</p>
      <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%221%2Flib%2Fpub%2F%22&sort=relevance&view=list">Public library material at finna.fi<span class="magnifier">&nbsp;</span></a>
   </div>
  </div>
  <div class="grid_7 forWhomWrapper">
     <div class="domains bodytextwrapper">
        <h3>{translate text="Museum_plural"}</h3>
        <p>At Finna, you can browse material available on the web not on view at museum premises and, for example, previously available only to scholars.</p>
        <p class="">Many museums offer the opportunity to order print-quality images and purchase image rights as an additional, chargeable service.</p>
        <a class="link" href="{$url}/Search/Results?lookfor=&type=AllFields&filter%5B%5D=sector_str_mv%3A%220%2Fmus%2F%22&sort=relevance&view=list">Museum material at finna.fi<span class="magnifier">&nbsp;</span></a>
     </div>
  </div>
 </div>
{/capture}

{capture append="sections"}

<div class="grid_24 grid_24_inner bodytextwrapper">
   <h2>Further information</h2>
   <p>Further information on user rights for the material found in Finna is available on the page <a href="{$path}/Content/terms_conditions">{translate text='navigation_terms_conditions'}</a>.</p>
   <p>The page <a href="{$path}/Content/about">{translate text='navigation_about_finna'}</a> contains information on the sites included in Finna and additional functions provided by Finna.</p>
</div>
{/capture}

{include file="$module/content.tpl" title=$title sections=$sections}
</div>

<!-- END of: Content/Organisations.fi.tpl -->
