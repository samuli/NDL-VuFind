<!-- START of: Content/searchhelp.sv.tpl -->

<div class="span12 well-small">
  <h2>Söktips</h2>
</div>
<div class="row-fluid">
  <div class="span3">
    <ul class="well-small nav nav-tabs nav-stacked pageMenu">
      <li><a href="#Wildcard Searches">Jokertecken</a></li>
      <li><a href="#Fuzzy Searches">Suddig sökning</a></li>
      <li><a href="#Proximity Searches">Avståndssökning</a></li>
      <li><a href="#Range Searches">Intervallsökning</a></li>
      <li><a href="#Boosting a Term">Viktade sökord</a></li>
      <li><a href="#Boolean operators">Boleska operatorer</a></li>
      <li style="margin: .5em;"><strong>Guide för utökad sökning</strong></li>
      <li><a href="#Search Fields">Sökfält</a></li>
      <li><a href="#Search Groups">Sökgrupp</a></li>
    </ul>
  </div>

  <div class="span9 mainContent">
    <section id="Wildcard Searches">
      <h4>Jokertecken</h4>
      <p>Frågetecken <strong class="label helpTerm">?</strong> ersätter exakt ett tecken i sökordet.</p>
      <p><i>Exempel: Sök för båda ”ahlqvist” och ”ahlkvist” med</i></p>
      <pre class="code"><i>te?t</i></pre>
      <p>Asterisk <strong>*</strong> ersätter 0, 1 eller flera tecken i sökordet.</p>
      <p><i>Exempel: Ord ”testning”, ”testningen”, ”testningar” och ”testningarna” kan sökas med</i></p>
      <pre class="code"><i>test*</i></pre>
      <p>Asterisken kan användas även inom ordet:</p>
      <p><i>Exempel: Man hittar båda "huvud" och "hufvud" med</i></p>
      <pre class="code"><i>hu*vud</i></pre>
      <p>Obs! Jokertecknena <strong>?</strong> och <strong>*</strong> kan inte vara det första tecken i ordet.</p>
    </section>
    <hr />
    
    <section id="Fuzzy Searches">
      <h4>Suddig sökning</h4>
      <p>Lägg till ett tildetecken <strong class="label helpTerm">~</strong> direkt efter ett enkelt ord för att göra en suddigt sökning på det.</p>
      <p><i>Exempel: Suddig sökning med ordet "petterson":</i></p>
      <pre class="code"><i>petterson~</i></pre>
      <p><i>hittar även ord "peterson" och  "petersen".</i></p>
      <p>Suddigheten kan justeras med en parameter, som kan vara mellan 0 och 1. Ju närmare 1 siffran är, desto mera lika måste termer vara.</p>
      <p><i>Exempel:</i></p>
      <pre class="code">petterson~0.8</pre>
      <p>Antaget värde är 0.5.</p>
    </section>
    <hr />
    
    <section id="Proximity Searches">
      <h4>Avståndssökning</h4>
      <p>Lägg till ett tildetecken <strong class="label helpTerm">~</strong> och maximiantal mellanstående ord efter en ordgupp inom citationstecken.</p>
      <p><i>Exempel:</i></p>   
      <pre class="code"><i>"economics Keynes"~10</i></pre>
      <p><i>hittar en post där ord "economics" och "keynes" förekommer med 10 eller färre ord mellan dem.</i></p>
    </section>
    <hr />
    
    {literal}
    <section id="Range Searches">
      <h4>Intervallsökning</h4>
      <p>För att söka inom intervallet mellan två värden, kan man använda klammerparenteser <strong class="label helpTerm">{ }</strong> eller 
         hakparenteser <strong class="label helpTerm">[ ]</strong> och ordet TO mellan värdena.</p>
      <p>Klammerparenteser söker mellan värden, men lämnar bort själva värdena. Hakparenteser inkluderar värdena i sökningen.</p> 
      <p><i>Exempel: Sök upphovsmän efter Saarinen men före Saaristo:</i></p>
      <pre class="code"><i>{saarinen TO saaristo}</i></pre>
      <p><i>I resultat finns t ex Saario och Saarisalo.</i></p>
      <p><i>Exempel: Sök inom år 2002&mdash;2003:</i></p>
      <pre class="code"><i>[2002 TO 2003]</i></pre>
      <p>Obs! Ordet TO mellan siffrona måste skrivas med STORA BOKSTÄVER.</p>
    </section>
    <hr />
    {/literal}
    
    <section id="Boosting a Term">
      <h4>Viktade sökord</h4>
      <p>Fästa mera vikt på en sökord genom att efter ett ord lägga till insättningstecken <strong class="label helpTerm">^</strong> (circumflex) och en siffra.</p>
      <p><i>Exempel:</i></p>
      <pre class="code"><i>Friedman Keynes^5</i></pre>
    </section>
    <hr />
    
    <section id="Boolean operators">
      <h4>Boleska operatorer</h4>
      <p>Boleska operatorer kopplar söktermer till mera komplicerade sökfrågor.  
         Du kan använda operatorer <strong>AND</strong>, 
         <strong>+</strong>, <strong>OR</strong>, <strong>NOT</strong> och <strong>-</strong>.
      </p>
      <p>Obs! Du måste skriva boleska operatorer med STORA BOKSTÄVER.</p>
      <dl>
        <dt><a name="AND"></a><h4 class="label">AND</h4></dt>
        <dd>
          <p><strong>AND</strong> är i Finna en standardoperator: då ingen operator skrivs mellan 
             två ord, antas att en <strong>AND</strong> står mellan dem. And är en s k konjugerande 
             operator. Båda sökord måste finnas i en post för en träff.</p>
          <p><i>Exempel: Sök efter poster som innehåller båda "economics" och "Keynes":</i></p>
          <pre class="code"><i>economics Keynes</i></pre>
          <p><i>eller</i></p>
          <pre class="code"><i>economics AND Keynes</i></pre>
        </dd>
        <dt><a name="+"></a>PLUSTECKEN <span class="label">+</span></dt>
        <dd>
          <p>Med plustecknet <strong>+</strong> kan man märka ett sökord, som måste ovillkorligt förekomma i sökresultat.</p>
          <p><i>Exempel: Varje post i sökresultat måste innehålla "economics"; Keynes kan förekomma, och posterna med "Keynes" får högre relevans i resultatlistan:</i></p>
          <pre class="code"><i>+economics Keynes</i></pre>
        </dd>
        <dt><a name="OR"></a><span class="label">OR</span></dt>
        <dd>
          <p>Med <strong>OR</strong>--operatorn hittar man poster, där ett (eller flera) av sökord hittas.</p>
          <p><i>Exempel: Sök efter resurser, som handlar Österbotten eller Västerbotten:</i></p>
          <pre class="code"><i>österbotten OR västerbotten</i></pre>
        </dd>
        <dt><a name="NOT"></a><span class="label">NOT</span> / MINUSTECKEN <span class="label">-</span></dt>
        <dd>
          <p><strong>NOT</strong>-operatorn utestängar poster, där följande sökord förekommer.</p>
          <p><i>Exempel: Sök efter poster med ord "Turing" men utan ord "machine":</i></p>
          <pre class="code"><i>turing NOT machine</i></pre>
          <p>Obs! Not-operatorn kan inte användas med bara ett ord.</p>
          <p><i>Exempel: Följande sökning vill hitta ingenting:</i></p>
          <pre class="code"><i>NOT sibelius</i></pre>
          <p>Minustecken kan användas i stället för <strong>NOT</strong>.</p>
          <p><i>Exempel:</i></p>
          <pre class="code"><i>turing -machine</i></pre>      
        </dd>
      </dl>
    </section>
    <hr />

    <h3>Guide för utökad sökning</h3>

    <section id="Search Fields">
      <h4>Sökfält</h4>
      <p>När du öppnar utökad sökning, ser du en sökgrupp med flera sökfält till reds. 
         Du kan fylla i sökord och sökoperatorer i ett, 
         flera eller alla av dessa fält.</p>
      <p>Vid varje sökfält finns en rullgardinsmeny med vilken kan du välja ett visst 
         fält i posten (titel, upphovsman osv.). Då begränsas sökningen till att bara 
         gälla de här data i en post. Varje sökfält kan begränsas självständigt.</p>
      <p><i>Exempel: Ordet "Helsingfors" kan ofta förekomma i bokens data som 
         tryckningsort. Om du söker information om Helsingfors, löner det sig att söka 
         "helsingfors" bara i titel eller ämne.</i></p>
      <p>Med rullgardinsmenyn <strong>Sök</strong> kand du bestämma, hur en sökning med 
         flera sökfält skall hanteras:</p>
      <ul>
        <li><strong>Alla söktermer (AND)</strong> &mdash; Resultat måste uppfylla villkor i varje sökfält.</li>
        <li><strong>Vilka söktermer som helst (OR)</strong> &mdash; Resultat måste uppfylla villkor bara i ett av sökfält.</li>
        <li><strong>Ingen sökterm (NOT)</strong> &mdash; Visar poster som inte uppfyller villkor i något av sökfält.</li>
      </ul>
      <p>Med <strong>Lägg till ett sökfält</strong> –knappen kan du skapa flera sökfält.</p>
    </section>
    <hr />
    
    <section id="Search Groups">
      <h4>Sökgrupp</h4>
      <p>Med  hjälp av sökgrupp kan du bygga även mera avancerade sökningar.</p>
      <p><i>Exempel: Du är intresserad om Norge och Danmark i relation till andra 
         världskriget. Med att kombinera sökord "Norge", "Danmark" och "andra världskriget" 
         och söka med <strong>Alla söktermer (AND)</strong> hittar du endast resurser, som handlar Danmark, 
         Norge och andra världskriget på samma gång. Både "Danmark" och "Norge" måste 
         alltså förekomma i samma resursen, och en bok som berättar bara om Norge, hittas 
         inte.</i></p>
      <p><i>Söker du med justeringen <strong>Vilka söktermer som helst (OR)</strong>, hittar du allt som 
         handlar Danmark, allt som handlar Norge och allt som handlar andra världskriget.</i></p>   
      <p>Man måste alltså först gruppera söktermer på rätt sätt med hjälp av sökgrupp.</p>
      <p>Med knappar <strong>Lägg till ett sökgrupp</strong> och <strong>Radera sökgruppen</strong> kan du skapa grupper 
         och radera dem.</p>
      <p>Sökgrupper kan kombineras på två sätt med rullgardinmenyn <strong>Sök</strong>: 
         sökresultat måste träffa <strong>Alla grupper (AND)</strong> eller <strong>vilken som 
         helst grupp (OR)</strong>.</p>
      <p><i>Exempel: Om Danmark och Norge i förhållande till andra världskriget kan man söka så här:</i></p>
      <ul>
        <li><i>I första sökgruppen fyller man i "Danmark" i det första och "Norge" i det andra fältet. 
         Inom gruppen, välj sökstilen <strong>Vilka söktermer som helst (OR)</strong>.</i></li>
        <li><i>Lägg till en sökgrupp. Fyll i sökord "andra världskriget".</i></li>
        <li><i>Kombinera sökgrupper med <strong>Alla grupper (AND)</strong>.</i></li>
      </ul>
    </section>
    <hr />

  </div>
  <p style="margin-top: 3em;"><a href="{$path}/">&laquo; {translate text="To Home"}</a></p>
  <div class="clearfix">&nbsp;</div>
</div>

<!-- END of: Content/searchhelp.sv.tpl -->
