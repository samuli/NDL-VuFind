<!-- START of: Content/about.en-gb.tpl -->

{assign var="title" value="What is Finna?"}
<div class="sectionsWithHeadings aboutpage">
{capture append="sections"}
<div class="grid_24 grid_24_inner">
<div class="grid_18 finnafititle">
	<img src="{$url}/interface/themes/ndl/images/finna-logo_black_notext.png" /><h2>Finna.fi</h2>
</div>
<div class="clear"></div>
<div class="finnafiimage responsiveColumns"><img src="{$url}/interface/themes/ndl/images/finnafrontpages/finnafi.jpg" id="finnafiscreenshot"/></div>
<div class="finnafitext">
<p>Finna.fi provides free access to material from Finnish <a href="https://www.finna.fi/Content/Organisations?lng=en-gb">museums, libraries and archives</a>. </p> 
<p>You can browse and read material <a href='https://www.finna.fi/Search/Results?lookfor=&type=AllFields&prefiltered=-&filter[]=online_boolean%3A"1"&view=list&lng=en-gb'>available on the web</a>.</p>
<p>You can also <a href="https://www.finna.fi/MyResearch/Home?lng=en-gb">renew loans and reserve material</a> from various libraries in one place.</p>
<p>Finna.fi is your one stop destination for searching the freely available material provided by the partner organisations.</p>
</div>
<div class="clear"></div>
{/capture}
{capture append="sections"}
<div class="grid_24 grid_24_inner">
<div class="grid_20 otherfinnasites">
	<h2>Other Finna search services</h2>
    <p>Finna is a search service entity containing several sites in addition to the nationwide finna.fi site. The content of organisation-specific sites is usually limited to the material of those individual organisations.</p>
</div>
<div class="clear"></div>
<div class="otherfinnascreenshots">
{include file="Content/finna-sites.tpl"}
</div>
<div class="clear"></div>
<div class="grid_20 otherfinnasites otherfinnasites_comment">
    <p>The <strong>university of applied sciences and university library Finna sites</strong> contain international, scientific and electronic library material compiled and provided by an outsourced party for a fee. Most of this material is limited to students and staff at the institute of higher education in question.</p>
</div>

</div>
<div class="clear"></div>
{/capture}
{capture append="sections"}
<div class="grid_20">
<h2>Finna is much more than a search service</h2>

<p>Through Finna, you can not only search for material, but also gain access to it. Currently, the following <em>libraries</em> provide functions for reserving material, renewing loans and other activities in Finna:</p>
<ul>
{foreach from=$loginTargets item=target}
<li>{translate text=$target prefix='source_'}</li>
{/foreach}
</ul>
<p>After <a href="https://www.finna.fi/MyResearch/Home?lng=en-gb">logging in to Finna</a>, these functions are available to you with a library card for the library in question.</p>
<p>An application for browsing <em>archive</em> material, that requires permission to use, can be made through links found in Finna content data.</p>
<p>In the future, digital <em>museum</em> services will also be available in Finna.</p>
</div>
{/capture}
{capture append="sections"}
<div class="grid_20">
<h2>About Finna</h2>

<h3>User rights</h3>
<p>Finna’s catalogue data are freely available, but statutory or contractual restrictions may apply to the digital images and back cover texts displayed in Finna, as well as to the digital content and metadata linked to in Finna. Read <a href="{$url}/Content/terms_conditions#terms">more about user rights</a>.</p>
<h3>Development of Finna</h3>
<p>Finna will be developed gradually as new organisations join the service. The beta version of the service was launched in December 2012 and the first official version in October 2013. If you cannot find the information that you are searching for in Finna, check back later to see if it has been added. 
</p>

<h3>Organisations responsible for Finna</h3>
<p>
The National Library of Finland bears the main responsibility for developing and maintaining Finna, but the actual development work is carried out together with Finna partners. The <a href='https://www.finna.fi/Content/Organisations?lng=en-gb'>archives, libraries and museums</a> involved in Finna are responsible for its content. Finna is part of the <a href='http://www.kdk.fi/en/information-on-the-project'>National Digital Library (NDL)</a> project of the Ministry of Education and Culture.
</p>
<h3>Finna software</h3>
<p>Finna has been constructed using VuFind and other open-source software, and its source code is freely available to all. Read <a href="http://www.kdk.fi/en/public-interface/software-development" target="_blank">more about the development of the software</a>.</p>

</div>
</div>
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}
</div>

<!-- END of: Content/about.en-gb.tpl -->
