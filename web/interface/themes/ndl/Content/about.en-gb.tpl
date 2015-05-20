<!-- START of: Content/about.en-gb.tpl (ndl) -->

{assign var="title" value="navigation_aboutus"|translate"}
{capture append="sections"}
<div class="grid_24 bodytextwrapper">
<p>This page is about a Finna site and the organization that maintains it.</p>
<p>The page <a href="{$path}/Content/aboutfinna">aboutfinna</a> contains information about Finna as an entity of many search services.</p>
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/about.en-gb.tpl (ndl) -->
