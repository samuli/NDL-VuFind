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
RT Book, Section
{else}
RT Book, Whole
{/if}
{elseif $format == 'WorkOfArt'}
RT Artwork
{elseif $format == 'Sound'}
RT Sound Recording
{elseif $format == 'Video'}
RT Video/ DVD
{elseif $subFormat == 'Other/Software'}
RT Computer Program
{elseif $format == 'Journal'}
{if $subFormat == 'Journal/eArticle'}
RT Journal, Electronic
{elseif $subFormat == 'Journal/NewsPaper'}
RT Newspaper Article
{else}
RT Journal Article
{/if}
{elseif $format == 'Map'}
RT Map
{elseif $subFormat == 'Database/ResearchReport'}
RT Report
{elseif $format == 'Thesis'}
RT Dissertation/Thesis
{else}
RT Generic
{/if}
{else}
RT Generic
{/if}
T1 {$indexData.title_full}
{if $indexData.series}
{foreach from=$indexData.series item=item}
T2 {$item}
{/foreach}
{/if}
{if $indexData.series2}
{foreach from=$indexData.series2 item=item}
T2 {$item}
{/foreach}
{/if}
{if $indexData.author}
A1 {$indexData.author}
{/if}
{if $indexData.author2}
{foreach from=$indexData.author2 item=item}
A1 {$item}
{/foreach}
{/if}
{if $indexData.language}
{foreach from=$indexData.language item=item}
LA {$item}
{/foreach}
{/if}
{if $corePublishers}
{if is_array($corePublishers)}
{foreach from=$corePublishers item=publisher name=loop}
PB {$publisher}
{/foreach}
{else}
PB {$corePublishers}
{/if}
{/if}
{if $corePublicationDates}
{if is_array($corePublicationDates)}
{foreach from=$corePublicationDates item=pubDate name=loop}
YR {$pubDate}
{/foreach}
{else}
YR {$corePublicationDates}
{/if}
{/if}
{if $corePublicationPlaces}
{if is_array($corePublicationPlaces)}
{foreach from=$corePublicationPlaces item=pubPlace name=loop}
PB {$pubPlace}
{/foreach}
{else}
PB {$corePublicationPlaces}
{/if}
{/if}
UL {$url}/Record/{$id|escape:"url"}
{if $indexData.isbn}
{foreach from=$indexData.isbn item=item}
SN {$item}
{/foreach}
{/if}
{if $indexData.topic}
{foreach from=$indexData.topic item=item}
K1 {$item}
{/foreach}
{/if}
{if $coreContainerStartPage}
SP {$coreContainerStartPage}
{/if}
{if $coreContainerIssue}
IS {$coreContainerIssue}
{/if}
{if $coreContainerVolume}
VO {$coreContainerVolume}
{/if}