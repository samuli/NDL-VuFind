{literal}

var contextHelp = {
  id: 'searchMetaLib',
   steps: [
    {
      target: '#searchForm_input',
      title: 'Nelli-monihaku',
      content: '<ul><li>Kirjoita hakukenttään viitteen <em>nimi</em>, <em>tekijä</em>, <em>aihe</em> tai muita asiaan liittyviä hakusanoja.</li><li>Voit käyttää mm. hakumerkkejä <strong>?</strong>&nbsp;(mikä tahansa kirjain), <strong>*</strong>&nbsp;(useampia kirjaimia) sekä Boolen operaattoreita <strong>AND</strong>, <strong>OR</strong> ja <strong>NOT</strong>. Tarkempia esimerkkejä {/literal}<a href="{$url}/Content/searchhelp">hakuohjeessa</a>{literal}.</li><li>Tarkan fraasihaun voit tehdä kirjoittamalla hakusanat lainausmerkkeihin.</li></ul>',
      placement: 'bottom',
      arrowOffset: 60,
      padding:0
    },
    {
      target: '.styled_select',
      title: 'Esirajaus',
      content: '<ul><li>Rajaa alasvetovalikosta haku vain osaan aineistosta. Haun jälkeen käytettävissä on lisää rajaustyökaluja.</li></ul>',
      placement: 'bottom',
      yOffset: -20
    }
  ],
  showPrevButton: true,
  scrollTopMargin: 100,
  bubbleWidth: 400,
}

{/literal}
