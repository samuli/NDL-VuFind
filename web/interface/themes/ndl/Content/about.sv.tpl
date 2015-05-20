<!-- START of: Content/about.sv.tpl (ndl) -->

{assign var="title" value="navigation_aboutus"|translate"}
{capture append="sections"}
<div class="grid_24 bodytextwrapper">
<p>Denna sida handlar om en Finna söktjänst och den organisation som upprätthåller den.</p>
<p>Sidan <a href="{$path}/Content/aboutfinna">aboutfinna</a> innehåller information om Finna som en enhet av många söktjänster.</p>
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/about.sv.tpl (ndl) -->
