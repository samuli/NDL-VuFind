<!-- START of: Content/terms_conditions.en-gb.tpl -->

{assign var="title" value="Privacy & Terms"}
{capture append="sections"}{literal}
<div class="grid_18">
<h3>Handling customer data in Finna </h3>
<p>When a user logs in to Finna with his or her library card, the service stores the number and PIN code of the card as well as the user’s first and last names, email address and home library. When logging in using Mozilla Persona, only the email is automatically stored in Finna. When logging in using Haka, Finna automatically stores the username, name and email of the user. The information is used for the following purposes:</p>

<table class="privacyTable">
  <tr>
	<td><strong>Information</strong></td>
	<td><strong>Purpose</strong></td>
  </tr>
  <tr>
	<td>Library card number</td>
	<td>User authentication</td>
  </tr>
  <tr>
	<td>PIN-code</td>
	<td>User authentication for service interfaces</td>
  </tr>
  <tr>
	<td>First name</td>
	<td>User authentication and display of information</td>
  </tr>
  <tr>
	<td>Last name</td>
	<td>User authentication and display of information</td>
  </tr>
  <tr>
	<td>Email</td>
	<td>Default address for email, can be edited by the user in Finna</td>
  </tr>
  <tr>
	<td>Home Library</td>
	<td>Default collection point for reservations, can be edited by the user in Finna</td>
  </tr>
</table>

<p>The email address stored in Finna is used only to send emails requested by the user, such as due date reminders and new entries alerts.</p>
<p>
In addition to the above information, Finna may store information about the user’s Finna activities. Such information includes the language of use, the receiving of due date reminders and new entries alerts, records saved in the user’s lists, library cards added by the user, and social metadata (comments, reviews, keywords).
</p>
<p>
Other features that require the handling of user information (e.g., browsing borrowed and reserved material, as well as fees, making reservations, renewing loans) use the service interfaces of the library system, and this information is not stored in Finna with the exception of the optional due date reminders. When a due date reminder is sent, the ID number and due date of the borrowed item is stored to ensure that the reminder is sent only once.
</p>
<p>
Finna accounts created using a library card or a Mozilla Persona or Haka username are separate from each other even if they have the same numerical identifier.
</p>
<p>
A personal data file description has been prepared for handling user information: <a href="{/literal}{$url}{literal}/Content/register_details">Register details</a>
</p>
<br/>
<h3>Terms and conditions</h3>
<p>Users of Finna may search for information from the collections of archives, libraries and museums. The following terms and conditions apply to the use of material:</p>
<ul>
<li><strong>Metadata:</strong> The metadata presented in conjunction with search results can be freely used by all.</li>
<li>
<strong>Digital material:</strong> In the case of digital material, Finna provides a link to the website of the organisation which controls the material in question. Statutory or contractual rights and restrictions may apply to material available through such websites. Any rights and restrictions are specified on the websites.</li>
<li>
<strong id="image_rights">Images:</strong> Finna displays images of a number of museum pieces, works of art, photographs and book covers. Such preview images may be subject to use restrictions similar to those applicable to material on the websites of participating organisations.
</li>
</ul>
<!-- TÄMÄ VASTA KUN TUONTANNOSSA:
<p>The geocoding of material is based on open data from the OpenStreetMap, licensed under an Open Data Commons Open Database licence. -->
</div>
{/literal}{/capture}
{include file="$module/content.tpl" title=$title sections=$sections}
<!-- END of: Content/terms_conditions.en-gb.tpl -->