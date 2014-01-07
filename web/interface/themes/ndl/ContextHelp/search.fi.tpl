{literal}

var contextHelp = {
  id: 'search',
   steps: [
    {
      target: '#searchForm_input',
      title: 'Perushaku',
      content: '<ul><li>Voit kirjoittaa hakukenttään esimerkiksi hakemasi teoksen <strong>nimen</strong>, <strong>tekijän</strong>, <strong>aiheen</strong> tai muita asiaan liittyviä hakusanoja. Viereisestä .</li><li>Hakukentässä voi käyttää mm. hakumerkkejä <strong>?</strong>&nbsp;(mikä tahansa kirjain), <strong>*</strong>&nbsp;(useampia kirjaimia) sekä boolean-operaattoreita AND, OR ja NOT. Tarkan fraasihaun voi tehdä kirjoittamalla hakusanat lainausmerkkeihin.</li></ul>',
      placement: 'bottom',
      arrowOffset: 60,
      padding:0
    },
    {
      target: '.styled_select',
      title: 'Esirajaus',
      content: '<ul><li>Alasvetovalikosta haun voi rajata koskemaan vain osaa aineistosta. Haun jälkeen käytössä on enemmän rajaustyökaluja</li></ul>',
      placement: 'bottom',
      yOffset: -20
    }
  ],
  showPrevButton: true,
  scrollTopMargin: 100,
  bubbleWidth: 400,
}

{/literal}