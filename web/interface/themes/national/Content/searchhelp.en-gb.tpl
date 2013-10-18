<!-- START of: Content/searchhelp.en-gb.tpl -->

{assign var="title" value="Insructions of use"}


{capture append="sections"}
  {literal}
  <h2 title="Basic Search" id="basicsearch">Basic search</h2>
  	<p>If search words are separated only by spaces, the search results are the same as when using the AND operator, i.e., the search results contain all the search words you have entered. </p>
  	<p>For example, <em>mannerheim carl</em> produces the same search results as <em>mannerheim AND carl. </em></p>
  	<p>You can pre-define your search by selecting a specific sector (museum, archive, library) or format (book, article, etc.) from the drop-down menu.</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Basic Search" id="narrowsearch">Narrowing the search</h2>
  <p>You can use the <strong>Narrow Search</strong> menu to narrow your search according to format (e.g., image), organisation (e.g., National Archives) or language.</p>
<p>Search results can be narrowed by selecting several criteria at the same time. </p>
<p>By default, the menu displays the most relevant search results at the top.</p>
	  <h3>Year filter and timeline <span class="timelineview" style="margin-left:10px"></span></h3>
	  <p>You can specify the year(s) of production by entering a range of years or using the visual timeline tool. 
	  <p>
<span class="icon dynatree-expander"></span>By clicking on the arrow, you can display the locations or formats (e.g., compilation, archive series, DVD) of a lower hierarchical level.</p>
	  <p><span class="fixposition deleteButtonSmall"></span><span class="fixline">You can delete criteria under the <strong>Narrow Search</strong> menu.</span></p>
 
   
    	<h3>Retain filters</h3>
    <p>This feature retains your filters for new search.  If you wish to carry out a new search applying the criteria, enable this function.</p>
    {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Advanced Search" id="advancedsearch">Advanced search</h2>
  <h3>Search fields</h3>
  <p>The Advanced Search page has several search fields in which you can enter search terms and phrases, and use various search operators. </p>
  <p>Adjacent to each search field is a drop-down menu, from which you can select the field of the relevant record (all fields, title, author, etc.). If necessary, you can target a search to several fields by using several search terms. </p>

<h3>Match drop-down</h3>
 	 <p>The match dropdown defines how to handle a query with several search fields: </p>
 	 <ul>
 	 <li>
 	 	<strong>ALL Terms (AND)</strong> – Searches for records that match the content of all search fields. </li>
 	 <li>
 	 	<strong>ANY Terms (OR)</strong> – Searches for records that match the content of one or more search fields. 
 	 </li>
 	 <li> <strong>NO Terms (NOT)</strong> – Searches for records which do not feature the content of any of the search fields.  </li>
 	 </ul>
     <ul>
 	 <li> <strong>Add Search Field</strong> allows you to add a new search field to the form.</li>
  <li> <strong>Add Search Group</strong> allows you to add search fields for a new group.</li>
  <li><strong>Remove Search Group</strong> allows you to delete groups. </li>
  </ul>
  
  
	<p>To define the relationships between search groups, use the <strong>ALL Groups (AND)</strong> and <strong>ANY Groups (OR)</strong> search operators. </p>
<p>The above example concerning the history of India or China can be implemented with search groups as follows: </p>
<ul>
  <li>Add the terms “India” and “China” to the search fields of the first search group, and define the relationship between the search fields by selecting <strong>ANY Terms (OR)</strong> from the <strong>Match</strong> drop-down menu. </li>
  <li>
  Create a new search group and add the term “history” to its search field. Define the relationship between search groups as <strong>ALL Groups (AND).</strong> </li>
  </ul>
	{/literal}
{/capture}
{capture append="sections"}
<h2 title="My account" id="myaccount">Own account and registration</h2>
  <p>Registered users can save searches, comment on content and reserve material.</p>
  <h3>Logging in</h3>
   <p>
   		You can log in to Finna by clicking on <a href="{$url}/MyResearch/Home">Login</a> at the top of the page and choosing one of the following three options:</p>
   <ul>
	 <li>
	 	All users can create a <strong>Mozilla Persona account. </strong>You can also add your library card to the account if the library participates in Finna.	</li>
	 <li>Students and staff of Finnish institutions of higher education can use the <strong>Haka institutional login.</strong> You can add your library card to the service if the library participates in Finna. This can be done after logging in.</li>
	 <li>If your library participates in Finna, you can log in to the service directly with your library card.
	   <p><a href="{$url}/Content/organisations">See the libraries whose cards can be used for logging in</a></p>
	 </li>
   </ul>
   <h3>Account functions:</h3>
   <h4><i>Favourites</i></h4>
  	 <p>You can add records to your favourites using the heart-shaped button on the search results page or the record page. You can sort selected records into lists of favourites, export records to Refworks, email records or print them in MARC format.</p> 
   <h4><em>Saved searches, search history and new entries alert</em></h4>
   <p>You can save your latest searches either on the search results page or by selecting Save in the latest searches under your saved searches. </p>
<p>Saved searches appear at the top. You can use the new entries alert to receive emails about new records either weekly or daily.</p>
<h4><em>Loans</em></h4>
<p>You can view information about your loans and renew loans.</p>
   <h4><em>Reservations and requests</em></h4>
     <p>You can view information about your reservations and requests, and cancel reservations.
     <h4><em>Fees</em></h4>
     	<p>You can view the fees (e.g., overdue items) recorded for your library card.</p>
    <h4><em>Library cards and adding your library card</em></h4>
     <p>You can add your library card(s) to Finna by selecting Add if your library has joined Finna.</p>
    <h4><em>My information</em></h4>
     <p>You can change your email address, set a due date reminder or select the library to which your reservations and inter-library loans are sent.</p>
<p> Contact your library to change its contact information.</p>
	 <h4><em>Changing your PIN code or password</em></h4>
	 <p>You can change your password or PIN code under My information.</p>
	 	     
	{/capture}
	{capture append="sections"}
<h2 title="Contact us" id="contactus">Feedback</h2>
	<p>You can send feedback on Finna (e.g., concerning the user interface and technical issues) using the general <a href="{$url}/Feedback/Home">feedback form.</a> Your feedback will be sent to the National Library of Finland, where it will be forwarded to the responsible individual. </p>
<p>If you have feedback on the content of Finna or on metadata relating to material in the service, click on <strong>Send Feedback</strong> on the webpage of the relevant record. This feedback will be sent to the organisation that submitted the material to Finna.</p>
	{/capture}
	{capture append="sections"}
  {literal}
<h2 title="Boolean operators" id="booleanoperators">Logical search operators</h2>
  <p>You can combine terms into complex queries with Boolean operators. The following operators can be used: <strong>AND</strong>, <strong>+</strong>, <strong>OR</strong>,<strong> NOT</strong>, and <strong>-</strong>. </p>
  <p><strong>NB!</strong> Boolean operators must be typed in CAPITAL LETTERS.</p>
  <h3 title="AND">AND</h3>
  <p><strong>AND</strong>, the conjunction operator, is the system’s default operator for multi-term queries that do not include an operator. When using the <strong>AND</strong> operator, the records included in the search results feature each of the terms in the search fields. </p>
  <p>For example, to search for records that include “economics” and “Keynes”: </p>
  <pre class="code">economics Keynes</pre>
  <p>or</p>
  <pre class="code">economics AND Keynes</pre>
  <h3 title="+">+</h3>
  <p>Merkillä <strong>+</strong> voidaan ilmaista vaatimusta siitä, että termin on esiinnyttävä jokaisessa hakutuloksessa.
  </p>
  <p>Esimerkki: etsitään tietueita, joissa esiintyy ehdottomasti "economics" ja joissa voi lisäksi esiintyä "Keynes":
  </p>
  <pre class="code">+economics Keynes</pre>
  <h3 title="OR">OR</h3>
  <p>The + sign can be used to indicate that the term must appear in each search result.  </p>
  <p>For example, to search for records that must include “economics” and may include “Keynes”: </p>
  <pre class="code">"economics Keynes" OR Keynes</pre>
  <h3 title="NOT">NOT / -</h3>
  <p>The<strong> NOT</strong> operator removes those records from the search results that include the term following the operator.  </p>
  <p>For example, to search for records that include the term “economics”, but not the term “Keynes”: </p>
  <pre class="code">economics NOT Keynes</pre>
  <p>NB! The<strong> NOT</strong> operator cannot be used in single-term queries. </p>
  <p>For example, the following query will produce no search results:</p>
  <pre class="code">NOT economics</pre>
  <p>The <strong>NOT</strong> operator can also be replaced with the - operator. </p>
  <h3 title="Phrase searches">Phrase searches</h3>
  <p>You can search for an exact phrase by writing your search terms within quotation marks.</p>
  <p> For example, to search only for records which include the phrase “mediaeval history”, not “mediaeval cultural history” or similar phrases: </p>
  <pre class="code">"keskiajan historia"</pre>
  <p>Fraasihakua voi käyttää myös yksittäisen hakusanan kohdalla, jolloin haku kohdistuu vain annettuun hakusanaan, eikä esimerkiksi muihin taivutusmuotoihin.
  </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Wildcard Searches" id="wildcardsearches">Wildcard characters</h2>
  <p>? replaces one character in a search term. </p>
  <p>For example, the terms “text” and “test” can be searched for using the same query:</p>
  <pre class="code">te?t</pre>
  <p><strong class="helpTerm">*</strong> replaces zero, one or several characters in a search term. </p>
  <p>For example, the terms “test”, “tests” and “tester” can be searched for using the query:</p>
  <pre class="code">test*</pre>
  <p>Jokerimerkkejä voi käyttää myös hakutermin keskellä:</p>
  <pre class="code">te*t</pre>
  <p>NB! The wildcards ? and * cannot replace the first character in a search term. </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Fuzzy Searches" id="fuzzysearches">Fuzzy searches</h2>
  <p>A fuzzy search generates results in which words similar to the actual search word also appear. </p>
  <p>~ carries out a fuzzy search when used as the last character in a single-term search. </p>
  <p>For example, a fuzzy search for the term “roam”:</p>
  <pre class="code">roam~</pre>
  <p>This search finds such terms as “foam” and “roams”. The similarity of the search to the original term can be regulated with a parameter between zero and one. </p>
  <p>The closer the value is to one, the more similar the term will be to the original term.  roam~0.8</p>
  <pre class="code">roam~0.8</pre>
  <p>The default value of the parameter is 0.5 if it is not separately defined for a fuzzy search. </p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Proximity Searches" id="proxitimitysearches">Proximity searches</h2>
  <p>Proximity searches look for documents in which the search terms are within a specified distance, but not necessarily one after the other.  </p>
  <p>~ performs a proximity search at the end of a multi-term search phrase when combined with a proximity value.  </p>
  <p>For example, to search for the terms “economics” and “Keynes” when they appear within a distance of no more than ten terms from each other: </p>   
  <pre class="code">"economics Keynes"~10</pre>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
  <h2 title="Range Searches" id="rangesearches">Range searches</h2>
  <p>Range searches can be conducted using either curvy brackets { } or square brackets [ ]. When using curvy brackets, the search takes into account only the values between the terms entered, excluding the terms itself. Square brackets, in contrast, also include the terms entered in the range searched for.  </p>
  <p>For example, to search for a term that begins with the letter B or C using the query: </p>
  <pre class="code">{A TO D}</pre>
  <p>For example, to search for the values 2002–2003: </p>
  <pre class="code">[2002 TO 2003]</pre>
  <p>NB! The word TO between the values must be typed in CAPITAL LETTERS.</p>
  {/literal}
{/capture}
{capture append="sections"}
  {literal}
<h2 title="Boosting a Term" id="boostingaterm">Weighted search terms</h2>
  <p>^ assigns a weight to the search term in a query.</p>
  <p>For example, to assign added weight to the search term “Keynes”:</p>
  <pre class="code">economics Keynes^5</pre>
  {/literal}
{/capture}
{include file="$module/content.tpl" title=$title sections=$sections menu=true}

<!-- END of: Content/searchhelp.en-gb.tpl -->
