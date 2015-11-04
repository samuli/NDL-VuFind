{literal}

var contextHelp = {
  id: 'searchPCI',
   steps: [
    {
      target: '#searchForm_input',
      title: 'PCI-haku',
      content: '<ul><li>Kirjoita hakukenttään viitteen <em>nimi</em>, <em>tekijä</em>, <em>aihe</em> tai muita asiaan liittyviä hakusanoja.</li><li>Voit käyttää mm. hakumerkkejä <strong>?</strong>&nbsp;(mikä tahansa kirjain), <strong>*</strong>&nbsp;(useampia kirjaimia) sekä Boolen operaattoreita <strong>AND</strong>, <strong>OR</strong> ja <strong>NOT</strong>. Tarkempia esimerkkejä {/literal}<a href="{$url}/Content/searchhelp">hakuohjeessa</a>{literal}.</li><li>Tarkan fraasihaun voit tehdä kirjoittamalla hakusanat lainausmerkkeihin.</li></ul>',
      placement: 'bottom',
      arrowOffset: 60,
      padding:0
    }
  ],
  showPrevButton: true,
  scrollTopMargin: 100,
  bubbleWidth: 400,
}

{/literal}
