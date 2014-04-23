<!-- START of: Content/about.fi.tpl -->

{assign var="title" value="About Finna"}
{capture append="sections"}
<div class="grid_18">
<h3>Find the treasures of Finnish archives, libraries and museums with a single search</h3>

<p>Finna provides access to the collections and services of archives, libraries and museums. Finna currently contains material from dozens of organisations. You can access Finna to search for information in library and archive collections, view images of museum pieces and works of art, and download documents and old books. Various additional functions are available to registered users of the service.
</p> 

<p>Finna is geared to all users of Finnish archives, libraries and museums. The expert organisations involved in Finna ensure that the content of the service is reliable, unlike that of many other search services. The search functions have been created to make it easy for users to find and use material.</p>

<h3>Using and borrowing material</h3>

<p>In the case of some material (e.g., a book that can be borrowed from a library), Finna offers metadata in text format, while the actual content can be found on the library shelf. If the material you are looking for is available through a library involved in Finna and you have a card for the library in question, you can reserve the material. If you have no library card, the best way to obtain the material is to request it from your local library.</p>

<p>In the case of works of art and other objects, Finna displays an image in conjunction with the search result. You can contact the relevant museum to enquire whether it can offer a print-quality image. 
</p>
<p>Finna can also be searched for digital content, such as articles, old books, newspapers, maps, images and recordings. Information about such material is available through a link in Finna.  
</p>
<p>Finna also contains information about archive documents classified as the official archive material of the National Archives Service of Finland. Some of these documents are available in digital format, whereas others must be requested from the National Archives Service and read on its premises. 
</p>
<p>
The metadata stored in Finna are freely available, but the availability of digital images or content displayed or linked to in Finna may be restricted by law or agreement. Read more about  <a href='{$url}/Content/terms_conditions'>user rights.</a>
</p>

<h3>Development of Finna</h3>
<p>Finna will be developed gradually as new organisations join the service. The beta version of the service was launched in December 2012 and the first official version in October 2013. If you cannot find the information that you are searching for in Finna, check back later to see if it has been added! 
</p>

<h3>Organisations responsible for Finna</h3>
<p>
The National Library of Finland bears the main responsibility for developing and maintaining Finna, but the actual development work is carried out together with Finna partners. The <a href='{$url}/Content/Organisations'>archives, libraries and museums</a> involved in Finna are responsible for its content. Finna is part of the <a href='http://www.kdk.fi/en/information-on-the-project'>National Digital Library (NDL) project</a> of the Ministry of Education and Culture.
</p>

<h3>Finna services</h3>
<p>
This is the shared Finna interface of Finnish archives, libraries and museums. Organisations can also create their own Finna interfaces. The following Finna interfaces are currently available: <a href="https://jyu.finna.fi/">JYKDOK</a>, <a href="https://museot.finna.fi/">Museo-Finna</a> and the National Library of Finland.
</p>

<h3>Finna software</h3>

Finna has been constructed using VuFind and other open-source software, and its source code is freely available to all. Read more about the <a href="http://www.kdk.fi/en/public-interface/software-development" target="_blank">development of the software</a>.
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}

<!-- END of: Content/about.fi.tpl -->
