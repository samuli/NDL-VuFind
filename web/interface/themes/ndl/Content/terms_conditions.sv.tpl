<!-- START of: Content/terms_conditions.sv.tpl -->

{assign var="title" value="Användarvillkor"}
{capture append="sections"}{literal}
<div class="grid_16">
<p>Finna kan användarna söka i arkivens, bibliotekens och museernas material. För användningen av materialet gäller följande villkor:</p>
<ul>
<li><strong>Beskrivningarna:</strong> Alla kan fritt använda metadata som visas i samband med sökresultaten.</li>
<li>
<strong>Digitaliserat material:</strong> Finna ger länken till den organisation som förvaltar det digitaliserade materialet. Materialet på organisationens webbplats kan omfattas av rättigheter eller begränsningar som regleras i lag eller avtal. Information om rättigheterna och begränsningarna finns på den förvaltande organisationens webbplats.</li>
<li>
<strong>Bilder:</strong> Finna har bilder t.ex. av vissa museiföremål, konstverk, foton och bokpärmar. Användningen av de här bilderna kan vara begränsad på samma sätt som användningen av materialet på de förvaltande organisationernas webbplatser.
</li>
</ul>
<!-- TÄMÄ VASTA KUN TUONTANNOSSA:
<p>Geokodningen av materialet har gjorts med öppen data i OpenStreetMap, licensierad med Open Data Commons Open Database License -->
</div>
{/literal}{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}
<!-- END of: Content/terms_conditions.sv.tpl -->