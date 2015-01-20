<!-- START of: Content/searchhelp.sv.tpl -->

{assign var="title" value="Söktips"}
{capture append="sections"}
  {literal}
  <h2 title="Wildcard Searches">Jokertecken</h2>
  <p>Frågetecken <strong>?</strong> ersätter exakt ett tecken i sökordet.</p>
  <p>Exempel: Sök både ”ahlqvist” och ”ahlkvist” med</p>
  <pre class="code">te?t</pre>
  <p>Asterisk <strong>*</strong> ersätter 0, 1 eller flera tecken i sökordet.
  </p>
  <p>Exempel: Orden ”testning”, ”testningen”, ”testningar” och ”testningarna” kan sökas med
  </p>
  <pre class="code">test*</pre>
  <p>Asterisken kan användas även inom ordet:</p>
  <p>Exempel: Man hittar både "huvud" och "hufvud" med</p>
  <pre class="code">hu*vud</pre>
  <p>Obs! Jokertecknen <strong>?</strong> och <strong>*</strong> kan inte vara det första tecknet i ordet.
  </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Fuzzy Searches">Oskarp sökning</h2>
  <p>Lägg till ett tildetecken <strong>~</strong> direkt efter ett enkelt ord för att göra en oskarp sökning på det.
  </p>
  <p>Exempel: Oskarp sökning med ordet "petterson":</p>
  <pre class="code">petterson~</pre>
  <p>hittar även ord "peterson" och  "petersen".</p>
  <p>Den oskarpa sökningen kan justeras med en parameter, som kan vara mellan 0 och 1. Ju närmare 1 siffran är, desto mera lika måste termerna vara.
  </p>
  <p>Exempel:</p>
  <pre class="code">petterson~0.8</pre>
  <p>Antaget värde är 0.5.</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Proximity Searches">Avståndssökning</h2>
  <p>Lägg till ett tildetecken <strong>~</strong> och maximiantal mellanstående ord efter en ordgupp inom citationstecken.
  </p>
  <p>Exempel:</p>   
  <pre class="code">"economics Keynes"~10</pre>
  <p>hittar en post där ord "economics" och "keynes" förekommer med 10 eller färre ord mellan dem.
  </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Range Searches">Intervallsökning</h2>
  <p>För att söka inom intervallet mellan två värden, kan man använda klammerparenteser <strong>{ }</strong> eller hakparenteser <strong>[ ]</strong> och ordet TO mellan värdena.
  </p>
  <p>Klammerparenteser söker mellan värden, men lämnar bort själva värdena. Hakparenteser inkluderar värdena i sökningen.
  </p> 
  <p>Exempel: Sök upphovsmän efter Saarinen men före Saaristo:</p>
  <pre class="code">{saarinen TO saaristo}</pre>
  <p>I resultat finns t ex Saario och Saarisalo.</p>
  <p>Exempel: Sök inom år 2002&mdash;2003:</p>
  <pre class="code">[2002 TO 2003]</pre>
  <p>Obs! Ordet TO mellan siffrona måste skrivas med STORA BOKSTÄVER.</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Boosting a Term">Vikt av sökord</h2>
  <p>Fäst mera vikt på ett sökord genom att efter ordet lägga till insättningstecken <strong>^</strong> (circumflex) och en siffra.
  </p>
  <p>Exempel:</p>
  <pre class="code">Friedman Keynes^5</pre>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Boolean operators">Booleska operatorer</h2>
  <p>Booleska operatorer kopplar ihop söktermer till mera komplicerade sökfrågor. Du kan använda operatorer <strong>AND</strong>, <strong>+</strong>, <strong>OR</strong>, <strong>NOT</strong> och <strong>-</strong>.
  </p>
  <p>Obs! Du måste skriva booleska operatorer med STORA BOKSTÄVER.</p>
  <h3 title="AND">AND</h3>
  <p><strong>AND</strong> är i Finna en standardoperator: då ingen operator skrivs mellan två ord, antas att <strong>AND</strong> står mellan dem. And är en s.k. konjugerande operator. Båda sökorden måste finnas i en post för en träff.
  </p>
  <p>Exempel: Sök efter poster som innehåller både "economics" och "Keynes":
  </p>
  <pre class="code">economics Keynes</pre>
  <p>eller</p>
  <pre class="code">economics AND Keynes</pre>
  <h3 title="+">PLUSTECKEN +</h3>
  <p>Med plustecknet <strong>+</strong> kan man märka ett sökord, som ovillkorligen måste förekomma i sökresultaten.
  </p>
  <p>Exempel: Varje post i sökresultat måste innehålla "economics"; Keynes kan förekomma, och posterna med "Keynes" får högre relevans i resultatlistan:
  </p>
  <pre class="code">+economics Keynes</pre>
  <h3 title="OR">OR</h3>
  <p>Med <strong>OR</strong>-operatorn hittar man poster, där ett (eller flera) av sökorden hittas.
  </p>
  <p>Exempel: Sök efter resurser, som handlar Österbotten eller Västerbotten:
  </p>
  <pre class="code">österbotten OR västerbotten</pre>
  <h3 title="!-">!-</h3>
  <p>Operatoren avlägsnar de poster från sökresultaten, vilka innehåller termen efter den.
  </p>
  <p>Exempel: sökes poster med termen "economics" men inte termen "Keynes": 
  </p>
  <pre class="code">economics !-Keynes</pre>
  <p>Obs! Denna operator kan inte användas i sökningar med en enda sökterm.</p>
  <p>Exempel: följande sökning ger inga resultat:</p>
  <pre class="code">!-economics</pre>
  <p>Obs! Om någon av söktermen börjar med denna operator, fås strecket med i sökningen med ett bakstreck (\):</p>
  <p>Exempel: sökningen <i>!-merkki hakuehtona</i> (på finska):<p>
  <pre class="code">\!-huutomerkki hakuehtona</pre>
  <p>Obs! <strong>NOT</strong>-operatorn kan användas på motsvarande sätt som denna operator. <strong>NOT</strong>-operatorn kan dock ge mera resultat som ändå innehåller söktermen som skulle uteslutas.
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
  <h2>Guide för utökad sökning</h2>
  <h3 title="Search Fields">Sökfält</h3>
  <p>När du öppnar den utökade sökningen, ser du en sökgrupp med flera sökfält till reds. Du kan fylla i sökord och sökoperatorer i ett, flera eller alla av dessa fält.
  </p>
  <p>Vid varje sökfält finns en rullgardinsmeny ur vilken kan du välja ett visst fält i posten (titel, upphovsman osv.). Då begränsas sökningen till att bara gälla dessa data i en post. Varje sökfält kan begränsas självständigt.
  </p>
  <p>Exempel: Ordet "Helsingfors" kan ofta förekomma i bokens data som tryckningsort. Om du söker information om Helsingfors, lönar det sig att söka "helsingfors" och begränsa sökningen till bara titel eller ämne.
  </p>
  <p>I rullgardinsmenyn <strong>Sök</strong> kan du bestämma, hur en sökning med flera sökfält skall hanteras:
  </p>
  <ul>
    <li><strong>Alla söktermer (AND)</strong> &mdash; Resultat måste uppfylla villkoren i varje sökfält.
    </li>
    <li><strong>Vilka söktermer som helst (OR)</strong> &mdash; Resultat måste uppfylla villkoren bara i ett av sökfälten.
    </li>
    <li><strong>Ingen sökterm (NOT)</strong> &mdash; Visar poster som inte uppfyller villkor i något av sökfälten.
    </li>
  </ul>
  <p>Med <strong>Lägg till ett sökfält</strong> –knappen kan du skapa flera sökfält.
  </p>
  
  <h3 title="Search Groups">Sökgrupp</h3>
  <p>Med hjälp av sökgrupp kan du bygga mera avancerade sökningar.</p>
  <p>Exempel: Du är intresserad av Norge och Danmark i relation till andra världskriget. Med att kombinera sökord "Norge", "Danmark" och "andra världskriget" och söka med <strong>Alla söktermer (AND)</strong> hittar du endast resurser, som handlar om Danmark, Norge och andra världskriget på samma gång. Både "Danmark" och "Norge" måste alltså förekomma i samma resurs, och en bok som berättar bara om Norge, hittas inte.
  </p>
  <p>Söker du med justeringen <strong>Vilka söktermer som helst (OR)</strong>, hittar du allt som handlar om Danmark, allt som handlar Norge och allt som handlar om andra världskriget.
  </p>
  <p>Man måste alltså först gruppera söktermer på rätt sätt med hjälp av sökgrupp.
  </p>
  <p>Med knappar <strong>Lägg till ett sökgrupp</strong> och <strong>Radera sökgruppen</strong> kan du skapa grupper och radera dem.
  </p>
  <p>Sökgrupper kan kombineras på två sätt med rullgardinmenyn <strong>Sök</strong>: sökresultat måste träffa <strong>Alla grupper (AND)</strong> eller <strong>vilken som helst grupp (OR)</strong>.
  </p>
  <p>Exempel: Om Danmark och Norge i förhållande till andra världskriget kan man söka så här:
  </p>
  <p>I första sökgruppen fyller man i "Danmark" och "Norge" i det andra fältet. Inom gruppen, välj sök stilen <strong>Vilka söktermer som helst (OR)</strong>.
  </p>
  <p>Lägg till en sökgrupp. Fyll i sökord "andra världskriget".
  </p>
  <p>Kombinera sökgrupper med <strong>Alla grupper (AND)</strong>.</p>
  {/literal}
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections menu=true}

<!-- END of: Content/searchhelp.sv.tpl -->
