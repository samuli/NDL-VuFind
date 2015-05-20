<!-- START of: Content/about.fi.tpl (ndl) -->

{assign var="title" value="navigation_aboutus"|translate"}
{capture append="sections"}
<div class="grid_24 bodytextwrapper">
<p>Tällä sivulla kerrotaan tietystä Finna-sivustosta ja sitä ylläpitävästä organisaatiosta.</p>
<p>Sivu <a href="{$path}/Content/aboutfinna">aboutfinna</a> sisältää tietoa Finnaan kuuluvista sivustoista ja Finnassa tarjottavista toiminnallisuuksista.</p>
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/about.fi.tpl (ndl) -->
