{if $info}
  <div class="authorbio">
    <h2>{$info.name|escape}</h2>
    {if $info.image}
      <img src="{$info.image}" alt="{$info.altimage|escape}" width="140px" class="alignleft recordcover wikipediaCover"/>
    {/if}
    <div class="authorbioText {if $info.image}illustrated{/if}">
        {$info.description|truncate_html:4500:"...":false}
        <div class="readMoreLink"><a class="wikipedia" href="http://{$wiki_lang}.wikipedia.org/wiki/{$info.name|escape:"url"}" target="_blank">{translate text='wiki_read_more'}</a></div>
        <div class="providerInfo">
            {if $userLang == 'fi'}Tämä artikkeli on <a href="http://{$wiki_lang}.wikipedia.org">Wikipedian tuottama.</a> Se on julkaistu <a href="http://fi.wikipedia.org/wiki/Wikipedia:CC-BY-SA">Creative Commons Attribution-Share-Alike 3.0. -lisenssillä.</a>{/if}
            {if $userLang == 'sv'}Denna artikel har <a href="http://{$wiki_lang}.wikipedia.org">producerats av Wikipedia.</a> Den är tillgänglig under licensen <a href="http://en.wikipedia.org/wiki/Wikipedia:CC-BY-SA">Creative Commons Attribution-Share-Alike 3.0.</a>{/if}
            {if $userLang == 'en-gb'}This article was <a href="http://{$wiki_lang}.wikipedia.org">produced by Wikipedia.</a> It is released under the <a href="http://en.wikipedia.org/wiki/Wikipedia:CC-BY-SA">Creative Commons Attribution-Share-Alike 3.0. license.</a>{/if}
        </div>
    </div>
    <div class="clear"></div>  
  </div>
{/if}
