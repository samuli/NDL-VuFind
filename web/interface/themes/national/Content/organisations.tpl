<!-- START of: Content/organisations.fi.tpl -->

{assign var="title" value="organisations_topic"|translate|cat:" (10.10.2013)"}
{capture append="sections"}

<p class="grid_18">{translate text="organisations_text"}</p>
<div class="grid_24 organisations">
<table class="organisationsTable">
<tr class="tableHeaders">
<td>{translate text="Archive_plural"}</td>
<td>{translate text="Library_plural"}</td>
<td>{translate text="Museum_plural"}</td>
</tr>
<tr>
<td  width="33%">
<ul class="organisations">
<li>{translate text = "facet_0/NARC"}</li>
<li>{translate text = "facet_0/MMA"}</li>
<li>{translate text = "facet_0/TMA"}</li>
<li>{translate text = "facet_0/OMA"}</li>
<li>{translate text = "facet_0/HMA"}</li>
<li>{translate text = "facet_0/VMA"}</li>
<li>{translate text = "facet_0/JoMA"}</li>
<li>{translate text = "facet_0/JyMA"}</li>
</ul>
</td>
<td width="33%">
<ul class="organisations">
<li>{translate text = "facet_0/NLF"}</li>
<li>{translate text = "facet_0/NRL"}</li>
<li>{translate text = "facet_0/JYU"}</li>
</ul>
</td>
<td width="33%">
<ul class="organisations">
<li>{translate text = "facet_0/Lusto"}</li>
<li>{translate text = "facet_0/NBA"}</li>
<li>{translate text = "facet_0/Metsastysmuseo"}</li>
<li>{translate text = "facet_0/NurmeksenMuseo"}</li>
<li>{translate text = "facet_0/PielisenMuseo"}</li>
<li>{translate text = "facet_0/IlomantsinMuseosaatio"}</li>
<li>{translate text = "facet_0/Ateneum"}</li>
<li>{translate text = "facet_0/Tuusula"}</li>
<li>{translate text = "facet_0/Sinebrychoff"}</li>
<li>{translate text = "facet_0/LapinMetsamuseo"}</li>
<li>{translate text = "facet_0/Verla"}</li>
</ul>
</td>
</tr>
</table>

</div>

{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/organisations.fi.tpl -->
