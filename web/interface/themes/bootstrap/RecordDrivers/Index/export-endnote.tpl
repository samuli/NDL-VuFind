{if $recordFormat}
{if is_array($recordFormat)}
{assign var=format value=$recordFormat.0}
{assign var=subFormat value=$recordFormat.1}
{else}
{assign var=format value=$recordFormat}
{assign var=subFormat value=null}
{/if}
{if $format == 'Book'}
{if $subFormat == 'Book/BookSection'}
%0 Book Section
{elseif $subFormat == 'Book/eBook'}
%0 Electronic Book
{else}
%0 Book
{/if}
{elseif $format == 'WorkOfArt'}
%0 Artwork
{elseif $format == 'Sound'}
%0 Audiovisual Material
{elseif $format == 'Video'}
%0 Audiovisual Material
{elseif $subFormat == 'Other/Software'}
%0 Computer Program
{elseif $format == 'Journal'}
{if $subFormat == 'Journal/eArticle'}
%0 Electronic Article
{elseif $subFormat == 'Journal/NewsPaper'}
%0 Newspaper Article
{else}
%0 Journal Article
{/if}
{elseif $format == 'Document'}
%0 Government Document
{elseif $subFormat == 'Other/Manuscript'}
%0 Manuscript
{elseif $format == 'Map'}
%0 Map
{elseif $format == 'Database'}
%0 Online Database
{elseif $subFormat == 'Database/ResearchReport'}
%0 Report
{elseif $format == 'Thesis'}
%0 Thesis
{else}
%0 Generic
{/if}
{else}
%0 Generic
{/if}
{if $indexData.author}
%A {$indexData.author}
{/if}
{if $indexData.author2}
{foreach from=$indexData.author2 item=item}
%A {$item}
{/foreach}
{/if}
{if $indexData.publishDate}
{foreach from=$indexData.publishDate item=item}
%D {$item}
{/foreach}
{/if}
{if $indexData.publisher}
{foreach from=$indexData.publisher item=item}
%I {$item}
{/foreach}
{/if}
{if $indexData.language}
{foreach from=$indexData.language item=item}
%G {$item}
{/foreach}
{/if}
%T {$indexData.title_full}
%! {$indexData.title_short}
{if $indexData.url}
{foreach from=$indexData.url item=item}
%U {$item}
{/foreach}
{/if}