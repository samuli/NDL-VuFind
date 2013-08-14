<!-- START of: footer.tpl -->

<div class="span12 well well-small">

  <div class="row-fluid">
    <div class="pull-left">
      <h2>{translate text='navigation_about'}</h2>
      <ul class="unstyled">
        <li><a href="{$path}/Content/about">{translate text='navigation_about_finna'}</a></li>
        <li><a href="{$path}/Content/terms_conditions">{translate text='navigation_terms_conditions'}</a></li>
        <li><a href="{$path}/Content/register_details">{translate text='navigation_register_details'}</a></li>
        {*
        <li><a href="{$path}/Search/History">{translate text='Search History'}</a></li>
        <li><a href="{$path}/Search/Advanced">{translate text='Advanced Search'}</a></li>
        *}
      </ul>
    </div>

    <div class="pull-left">
      <h2>{translate text='navigation_search'}</h2>
      <ul class="unstyled">
        <li><a href="{$path}/Search/History">{translate text='Search History'}</a></li>
        <li><a href="{$path}/Search/Advanced">{translate text='Advanced Search'}</a></li>
        <li><a href="{$path}/Browse/Home">{translate text='Browse the Catalog'}</a></li>
        {*
        <li><a href="{$path}/Browse/Home">{translate text='Browse the Catalog'}</a></li>
        <li><a href="{$path}/AlphaBrowse/Home">{translate text='Browse Alphabetically'}</a></li>
        <li><a href="{$path}/Search/TagCloud">{translate text='Browse by Tag'}</a></li>
        <li><a href="{$path}/Search/Reserves">{translate text='Course Reserves'}</a></li> not used
        <li><a href="{$path}/Search/NewItem">{translate text='New Items'}</a></li> not used
        *}
      </ul>
    </div>

    <div class="pull-left">
      <h2>{translate text='navigation_help'}</h2>
      <ul class="unstyled">
        <li><a href="{$path}/Content/searchhelp" class="searchHelp">{translate text='Search Tips'}</a></li>
        <li><a href="{$path}/Feedback/Home" class="searchHelp">{translate text='navigation_feedback'}</a></li>
        <li>{*<a href="#">{translate text='Ask a Librarian'}</a>*}&nbsp;</li>
        {*
        <li><a href="#">{translate text='FAQs'}</a></li>
        *}
      </ul>
    </div>

    <div class="pull-left text-center">
      <a href="http://www.kdk.fi{if $userLang=='fi'}/{elseif $userLang=='sv'}/sv{else}/en{/if}" class="KDK-logo">
      {if $userLang=='fi'}
        {image src="kdk-logo_fi.png" alt="Kansallinen digitaalinen kirjasto"}
      {elseif $userLang=='sv'}
        {image src="kdk-logo_sv.png" alt="Det nationella digitala biblioteket"}
      {else}
        {image src="kdk-logo_en.png" alt="The National Digital Library"}
      {/if}
      </a>
      <a href="http://www.vufind.org" class="vufind-logo">{image src="vufind-logo_small.png" alt="www.vufind.org"}</a>

    {* Comply with Serials Solutions terms of service -- this is intentionally left untranslated. *}
    {if $module == "Summon"}
      <br /><p>Powered by Summon™ from Serials Solutions, a division of ProQuest.
      </p>
    {/if}
    </div>
  </div>

</div>

{literal}
<script type="text/javascript">   
  $(document).ready(function(){
    $('.toggleHeader').parent().next().hide();
	  $('.toggleHeader').click(function(){
	    $(this).parent().next().toggle('fast');
	    return false;
	  });
  });
</script>
{/literal}

<!-- END of: footer.tpl -->
