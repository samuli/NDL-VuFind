<!-- START of: Content/about.fi.tpl -->

{assign var="title" value="Om Finna"}
{capture append="sections"}
<div class="grid_18">
<h3>Portalen till Finlands arkiv, bibliotek och museer</h3><p>
Finna ger tillgång till material och tjänster som finns i olika arkiv, bibliotek och museer. För tillfället innehåller Finna material från tiotals olika organisationer. I Finna kan du söka i bibliotekens och arkivens samlingar, titta på bilder av museiföremål och konstverk och ladda ner dokument och gamla böcker. För användare som registrerar sig erbjuder Finna olika extrafunktioner.
</p> 

<p>Finna riktar sig till alla som vill använda Finlands arkiv, bibliotek och museer. Till skillnad från andra söktjänster har innehållet i Finna producerats av expertorganisationer och är därför tillförlitligt. Finnas sökfunktioner har utvecklats för att göra det lätt att hitta och använda materialet.
</p>
<h3>Att använda och låna material</h3>
<p>
En del av materialet i Finna, såsom böcker som kan lånas, beskrivs i text och det egentliga innehållet finns t.ex. i hyllan i biblioteket. Om ett verk som du söker är tillgängligt i ett av de bibliotek som medverkar i Finna, och du har ett lånekort till biblioteket, kan du reservera verket. Om du inte har ett bibliotekskort, får du lättast tag på materialet genom att kontakta ditt närmaste bibliotek.</p>
<p>
När man söker efter föremål och konstverk i Finna visas en bild av föremålet i sökresultatet. Museet har eventuellt en bild av bättre kvalitet som kan tryckas och som man kan beställa.  
</p>
<p>
Dessutom kan man söka digitaliserat material i Finna, t.ex. artiklar, gamla böcker, tidningar, kartor, bilder och ljudinspelningar. De här materialen kan man bekanta sig med via en länk i Finna.  
</p>
<p>
I Finna finns det också information om myndighetshandlingar i arkiven som arkivverket förvarar. En del av handlingarna är tillgängliga i digital form och en del måste beställas och läsas i arkivverkets lokaler.  
</p>
<p>
Beskrivningarna i Finna får fritt användas, men användningen av digitala bilder som visas i Finna eller digitalt innehåll som Finna länkar till kan vara begränsad genom lag eller avtal. Läs mer om <a href='{$url}/Content/terms_conditions'>rätten att använda materialet.</a>
</p>

<h3>Utvecklingen av Finna</h3>
<p>Finna är en tjänst som utvecklas stegvis allt eftersom nya organisationer ansluter sig. Betaversionen lanserades i december 2012 och den första egentliga versionen i oktober 2013. Även om du inte hittar den information du söker i Finna i dag, kommer den kanske att finnas där i framtiden! 
</p>

<h3>Finnas ansvariga parter</h3>
<p>
Nationalbiblioteket ansvarar för utvecklingen och underhållet av Finna, men tjänsten utvecklas tillsammans med Finnas samarbetspartner. De <a href='{$url}/Content/Organisations'>arkiv, bibliotek och museer</a> som medverkar i Finna ansvarar för innehållet. Finna är en del av undervisnings- och kulturministeriets <a href='http://www.kdk.fi/sv/information-om-projektet'>projekt det nationella digitala biblioteket.</a>
</p>

<h3>Finnas tjänster</h3>
<p>
Det här är arkivens, bibliotekens och museernas gemensamma Finnavy. Utöver webbtjänsten kan organisationerna skapa egna Finnavyer. För tillfället finns följande Finnavyer:  <a href="https://jyu.finna.fi/">JYKDOK</a>, <a href="https://museot.finna.fi/">Museernas Finna</a> och Nationalbibliotekets Finna.
</p>

<h3>Finnas program</h3>
Finna har skapats med hjälp av VuFind och andra program med öppen källkod, och Finnas källkod får användas fritt. Läs mer om  <a href="http://www.kdk.fi/en/public-interface/software-development" target="_blank">utvecklingen av programmet.</a>
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/about.fi.tpl -->
