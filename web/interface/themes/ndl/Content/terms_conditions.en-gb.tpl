<!-- START of: Content/terms_conditions.en-gb.tpl -->

{assign var="title" value="Terms and conditions"}
{capture append="sections"}{literal}
<div class="grid_16">
<p>Users of Finna may search for information from the collections of archives, libraries and museums. The following terms and conditions apply to the use of material:</p>
<ul>
<li><strong>Metadata:</strong> The metadata presented in conjunction with search results can be freely used by all.</li>
<li>
<strong>Digital material:</strong> In the case of digital material, Finna provides a link to the website of the organisation which controls the material in question. Statutory or contractual rights and restrictions may apply to material available through such websites. Any rights and restrictions are specified on the websites.</li>
<li>
<strong>Images:</strong> Finna displays images of a number of museum pieces, works of art, photographs and book covers. Such preview images may be subject to use restrictions similar to those applicable to material on the websites of participating organisations.
</li>
</ul>
<!-- TÄMÄ VASTA KUN TUONTANNOSSA:
<p>The geocoding of material is based on open data from the OpenStreetMap, licensed under an Open Data Commons Open Database licence. -->
</div>
{/literal}{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}
<!-- END of: Content/terms_conditions.en-gb.tpl -->