<!-- START of: Content/searchhelp.sv.tpl -->

{assign var="title" value="Anvisningar"}


{capture append="sections"}
  {literal}
  <h2 title="Basic Search" id="basicsearch">Sökning</h2>
  	<p>Om sökorden åtskiljs med mellanslag följs samma söklogik som om de skulle åtskiljas av ett AND, dvs. sökresultaten ska innehålla alla sökord.</p><p>Till exempel <em>mannerheim carl</em>ger samma resultat som <em>mannerheim AND carl</em>.</p>
  	<p>Du kan begränsa sökningen på förhand genom att välja t.ex. en viss sektor (museum, arkiv, bibliotek) eller ett visst format (bok, artikel osv.).</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Basic Search" id="narrowsearch">Begränsa sökningen</h2>
  <p>Under menyn Begränsa sökningen kan du begränsa din sökning enligt format (t.ex. bild), placering (t.ex. Riksarkivet) eller språk.</p>
<p>Du kan avgränsa resultatet ytterligare genom att använda flera begränsningar.</p>
<p>Högst i menyn visas som standard de sökvärden som ger flest träffar.    </p>
<p>Du kan begränsa sökresultatet enligt framställningsår antingen genom att fylla i det tidsintervall som du vill söka i, eller genom att använda tidslinjen
<p>
<span class="icon dynatree-expander"></span>Genom att klicka på pilen kan du välja placeringar eller material på en lägre hierarkinivå (t.ex. sammanställning, arkivserie, dvd).</p>
	  <p><span class="fixposition deleteButtonSmall"></span><span class="fixline">Du kan ta bort begränsningarna under Begränsa sökningen.</span></p>

   
    	<h3>Spara begränsningar</h3>
    <p>Med den här funktionen kan du spara de begränsningar som du har valt. De begränsningar du har valt sparas som standard när du gör en ny sökning. Om du vill göra en ny sökning utan begränsningar, avaktivera den här funktionen.</p>
    {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Advanced Search" id="advancedsearch">Utökad sökning</h2>
  	<h3>Sökfälten</h3>
  	<p>På sidan för utökad sökning finns flera sökfält, där du kan fylla i söktermer och sökfraser och använda olika sökoperatorer.</p>
  	<p>Bredvid varje sökfält finns en rullgardinsmeny där du kan välja vilket av postens fält sökningen ska gälla (alla fält, rubrik, upphovsman osv.). Vid behov kan du söka med flera termer i flera fält. </p>
<h3>Sökmenyn</h3>
 	 <p><strong>Sökmenyn</strong> bestämmer hur en sökning som omfattar många sökfält ska hanteras: </p>
 	 <ul>
 	 <li> <strong>Alla söktermer (AND) </strong>– Söker poster som innehåller alla sökord i alla sökfält.</li>
 	 <li>
 	 	<strong>Vilka söktermer som helst (OR)</strong> – Söker poster som innehåller sökorden i ett eller flera sökfält.  
 	 </li>
 	 <li><strong>Ingen sökterm (NOT)</strong> – Söker poster som inte innehåller sökorden från något av sökfälten.</li>
 	 
 	<p>Med knappen <strong>Lägg till ett sökfält</strong> kan man lägga till ett nytt sökfält. </p>
  </li>
  <li>
  	Men knappen <strong>Lägg till en sökgrupp</strong> kan man lägga till en ny grupp med sökfält. </li>
  <li>
	Med knappen <strong>Radera sökgruppen</strong> kan man ta bort en sökgrupp. 
  </li>
  </ul>
  
  
	<p>Relationen mellan sökgrupperna kan definieras med sökoperatorerna <strong>Alla grupper (AND)</strong> och <strong>Vilken grupp som helst (OR). </strong></p>
   <ul>
   <li>
	Exemplet med Norge och Danmark ovan kan lösas med hjälp av sökgrupper på följande sätt: </li>
   <li>
	Skriv in söktermerna ”Norge” och ”Danmark” i sökfälten i den första sökgruppen. Definiera förhållandet mellan sökfälten genom att välja <strong>Vilka söktermer som helst (OR) i Sökmenyn. </strong></li>
   <li>
	Skapa en ny sökgrupp och skriv in söktermen ”andra världskriget” i sökfältet. Definiera förhållandet mellan sökgrupperna som <strong>Alla grupper (AND). </strong></li>
  	</ul>
	{/literal}
{/capture}
{capture append="sections"}
<h2 title="My account" id="myaccount">Mitt konto och inloggning</h2>
  <p>Inloggade användare kan t.ex. spara sökningar, kommentera innehållet i Finna och reservera material.</p>
  <h3>Inloggning</h3>
   <p>
   Du kan logga in genom att klicka på <a href="{$url}/MyResearch/Home">Logga in</a> i menyn uppe på sidan. Du kan logga in på tre olika sätt:</p>
   <ul>
	 <li> Alla användare kan skapa ett <strong>Mozilla Persona-användarnamn</strong>. Man kan också lägga till sitt bibliotekskort till Mozilla Persona-kontot, om biblioteket medverkar i Finna. </li>
	 <li> <strong>HAKA-inloggningen</strong> är avsedd i synnerhet för studenter och anställda vid högskolor. </li>
	 <li>Om ditt bibliotek medverkar i Finna kan du registrera ditt<strong> bibliotekskort </strong>på tjänsten efter att du har loggat in dig.
	   <p> 
	   <a href="{$url}/Content/Organisations">Om du har ett bibliotekskort till något av de här biblioteken kan du logga in med ditt kort.</a></p>
	 </li>
</ul>
   <h3>Funktionerna i Mitt konto:</h3>
   <h4><i>Favoriter</i></h4>
  	 <p>Du kan lägga poster till dina favoriter med hjärtikonen som finns på sidan med träfflistan eller på sidan med information om posten. Du kan ordna dina poster i olika favoritlistor, föra in dem i Refworks, skicka dem med e-post eller skriva ut dem i MARC-format.</p> 
   <h4><em>Sparade sökningar, sökhistorik och nyhetsbevakning</em></h4>
   <p>Du kan spara din senaste sökning antingen på sidan med sökresultat eller med Spara-knappen i Senaste sökningar i Mitt konto. De sparade sökningarna syns överst.</p>
   <p>Du kan beställa nyhetsbevakning för sparade sökningar och få meddelanden om nyheter antingen varje vecka eller varje dag. Meddelandena skickas till din e-post.   </p>
   <h4><em>Lån</em></h4>
   	 <p>Du kan se dina lån och förnya dem.</p>
   <h4><em>Reserveringar och beställningar</em></h4>
     <p>Du kan se dina reserveringar och beställningar. I den här fliken kan du ta tillbaka dina reserveringar.
<h4><em>Avgifter</em></h4>
     	<p>Du kan se vilka avgifter som har registrerats på ditt bibliotekskort, t.ex. på grund av försenade lån.</p>
    <h4><em>Bibliotekskort</em></h4>
     <p>Om ditt bibliotek medverkar i Finna kan du lägga till ditt bibliotekskort med knappen Lägg till. Du kan lägga till flera bibliotekskort.</p>
    <h4><em>Profil</em></h4>
     <p>Du kan byta e-postadress, aktivera påminnelse om förfallodag och välja vilket bibliotek du vill att dina reserveringar, beställningar och fjärrlån i första hand ska skickas till.</p>
	 <p>Du kan ändra bibliotekets kontaktuppgifter genom att ta kontakt med ditt eget bibliotek.</p>
	 <h4><em>Att byta pinkod eller lösenord</em></h4>
	 <p>Du kan byta lösenord eller pinkod i fliken Profil.</p>
	 	     
	{/capture}
	{capture append="sections"}
<h2 title="Contact us" id="contactus">Feedback</h2>
	<p>Du kan ge feedback om Finna, t.ex. om gränssnittet eller tekniken, med en <a href="{$url}/Feedback/Home">blankett.</a> Responsen går till Nationalbiblioteket, där den behandlas och skickas vidare till den som ansvarar för ärendet.</p>
	<p>Om du vill ge respons på innehållet i tjänsten eller informationen om materialet, lönar det sig att använda länken <strong>Skicka feedback</strong> på sidan med information om posten. Responsen skickas till den organisation som har fört in materialet i Finna.</p>
	{/capture}
	{capture append="sections"}
  {literal}
<h2 title="Boolean operators" id="booleanoperators">Sökoperatorer</h2>
  <p>Du kan kombinera söktermer med hjälp av Booleska sökoperatorer. Följande operatorer kan användas: AND, +, OR, NOT och -.  </p>
  <p>Obs! De Booleska sökoperatorerna skrivs med VERSALER.</p>
  <h3 title="AND">AND</h3>
  <p><strong>AND</strong> är standardoperatorn för sökningar med flera söktermer, om inga andra operatorer används. När man använder operatorn <strong>AND</strong> visas de poster som innehåller alla söktermer som använts.  Till exempel: du söker poster som innehåller både ”economics” och ”Keynes”: </p>
  <pre class="code">economics Keynes</pre>
  <p>eller</p>
  <pre class="code">economics AND Keynes</pre>
  <h3 title="+">+</h3>
  <p>Med +-tecknet kan man definiera att termen måste finnas i varje sökträff.  </p>
  <p>Till exempel: du söker poster som måste innehålla söktermen ”economics” och som också kan innehålla söktermen ”Keynes”: </p>
  <pre class="code">+economics Keynes</pre>
  <h3 title="OR">OR</h3>
  <p>Om man använder operatorn <strong>OR</strong> visas de poster som innehåller en eller flera av de termer som operatorn kombinerar.</p>
  <p> Till exempel: du söker poster som innehåller antingen ”economics Keynes” eller bara ”Keynes”: </p>
  <pre class="code">"economics Keynes" OR Keynes</pre>
  <h3 title="-">Bindestreck (-)</h3>
  <p>Bindestrecket (-) avlägsnar de poster från sökresultaten, vilka innehåller termen efter strecket.
  </p>
  <p>Exempel: sökes poster med termen "economics" men inte termen "Keynes": 
  </p>
  <pre class="code">economics -Keynes</pre>
  <p>Obs! Bindestreck kan inte användas i sökningar med en enda sökterm.</p>
  <p>Exempel: följande sökning ger inga resultat:</p>
  <pre class="code">-economics</pre>
  <p>Obs! Om någon av söktermen börjar med bindestreck, fås strecket med i sökningen med ett bakstreck (\):</p>
  <p>Exempel: sökes boken <i>Da Vinci -koodi</i> (finsk översättning):<p>
  <pre class="code">Da Vinci \-koodi</pre>
  <p>Obs! <strong>NOT</strong>-operatorn kan användas på motsvarande sätt som bindestrecket. <strong>NOT</strong>-operatorn kan dock ge mera resultat som ändå innehåller söktermen som skulle uteslutas.
  </p>      
  <h3 title="Phrase searches">Frassökning</h3>
  <p>Du kan göra en exakt frassökning genom att skriva dina sökord inom citationstecken. </p>
  <p>Till exempel: du söker poster som innehåller frasen ”medeltidens historia”, inte t.ex. ”medeltidens kulturhistoria”: </p>
  <pre class="code">"keskiajan historia"</pre>
  <p>Man kan också använda frassökning för enskilda söktermer, då visas bara poster som innehåller sökordet exakt så som det är skrivet, och inte t.ex. böjt på olika sätt. 
  </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Wildcard Searches" id="wildcardsearches">Jokertecken</h2>
  <p><strong class="helpTerm">?</strong> ersätter ett tecken i sökordet.</p>
  <p>Till exempel: du kan söka både ”text” och ”test” med samma sökord:</p>
  <pre class="code">te?t</pre>
  <p><strong class="helpTerm">*</strong> ersätter 0, 1 eller flera tecken i sökordet. </p>
  <p>Till exempel: du kan söka både ”test”, ”tests” och ”tester” med samma sökord:</p>
  <pre class="code">test*</pre>
  <p>Jokertecknen kan också användas inne i sökordet:</p>
  <pre class="code">te*t</pre>
  <p>Obs! Jokertecknen ? och * kan inte vara det första tecknet i ett ord. </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Fuzzy Searches" id="fuzzysearches">Oskarp sökning</h2>
  <p>Om man gör en oskarp sökning visas också poster som innehåller ord som liknar sökordet. </p>
  <p>Du kan göra en oskarp sökning genom att lägga till tecknet ~ i slutet av ett ord. </p>
  <p>Till exempel: oskarp sökning med sökordet ”roam”:</p>
  <pre class="code">roam~</pre>
  <p>Den här sökningen hittar poster som innehåller t.ex. orden ”foam” och ”roams”. Man kan ställa in hur lika sökordet träffarna ska vara med en parameter mellan 0 och 1. Ju närmare 1 den här parametern är, desto mer lika måste träffarna vara sökordet. </p>
  <pre class="code">roam~0.8</pre>
  <p>Standardparametern är 0,5 om man inte anger ett annat värde. </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Proximity Searches" id="proxitimitysearches">Avståndssökning</h2>
  <p>Genom att göra en avståndssökning får man träffar där sökorden är nära varandra, men inte nödvändigtvis intill varandra. </p>
  <p>Du kan göra en avståndssökning genom att lägga till tecknet ~ och ett avståndsvärde efter en sökfras med flera sökord.  </p>
  <p>Till exempel: du söker på orden ”economics” och ”keynes” och vill att de ska förekomma på högst 10 ords avstånd från varandra: </p>   
  <pre class="code">"economics Keynes"~10</pre>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Range Searches" id="rangesearches">Intervallsökning</h2>
  <p>För att söka inom intervallet mellan två värden kan man använda klammerparenteser { } eller hakparenteser [ ]. Om man använder klammerparenteserna görs sökningen mellan värdena, värdena inom klammerparenteserna utesluts. Om man använder hakparenteser inkluderas värdena inom parentes i sökningen.  </p>
  <p>Till exempel: om du söker en term som börjar på bokstaven B eller C kan du söka på: </p>
  <pre class="code">{A TO D}</pre>
  <p>Till exempel: om du söker ett värde mellan 2002 och 2003 kan du söka på: </p>
  <pre class="code">[2002 TO 2003]</pre>
  <p>Obs! Operatorn TO ska skrivas med VERSALER.</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Boosting a Term" id="boostingaterm">Att vikta sökord</h2>
  <p>Tecknet ^ ger mer vikt åt sökordet. Till exempel: i sökningen är sökordet ”Keynes” viktat:</p>
  <pre class="code">economics Keynes^5</pre>
  {/literal}
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections menu=true}

<!-- END of: Content/searchhelp.fi.tpl -->
