<!-- START of: Content/searchhelp.fi.tpl -->

<div class="span12 well-small">
  <h2>Search Tips</h2>
</div>
<div class="row-fluid">
  <div class="span3">
    <ul class="well-small nav nav-tabs nav-stacked pageMenu">
      <li><a href="#Wildcard Searches">Wildcard Searches</a></li>
      <li><a href="#Fuzzy Searches">Fuzzy Searches</a></li>
      <li><a href="#Proximity Searches">Proximity Searches</a></li>
      <li><a href="#Range Searches">Range Searches</a></li>
      <li><a href="#Boosting a Term">Boosting a Term</a></li>
      <li><a href="#Boolean operators">Boolean Operators</a></li>
      <li><a href="#Phrase searches">Phrase searches</a></li>
      <li style="margin: .5em;"><strong>Advanced Searching Tips</strong></li>
      <li><a href="#Search Fields">Search Fields</a></li>
      <li><a href="#Search Groups">Search Groups</a></li>
    </ul>
  </div>

  <div class="span9 mainContent">
    <section id="Wildcard Searches">
      <h4>Wildcard Searches</h4>
      <p>To perform a single character wildcard search use the <strong class="label helpTerm">?</strong> symbol.</p>
      <p>For example, to search for "text" or "test" you can use the search:</p>
      <pre class="code">te?t</pre>
      <p>To perform a multiple character, 0 or more, wildcard search use the <strong>*</strong> symbol.</p>
      <p>For example, to search for test, tests or tester, you can use the search: </p>
      <pre class="code">test*</pre>
      <p>You can also use the wildcard searches in the middle of a term.</p>
      <pre class="code">te*t</pre>
      <p>Note: You cannot use a * or ? symbol as the first character of a search.</p>
    </section>
    <hr />
  
    <section id="Fuzzy Searches">
      <h4>Fuzzy Searches</h4>
      <p>Use the tilde <strong class="label helpTerm">~</strong> symbol at the end of a <strong>Single</strong> word Term. For example to search for a term similar in spelling to "roam" use the fuzzy search: </p>
      <pre class="code">roam~</pre>
      <p>This search will find terms like foam and roams.</p>
      <p>An additional parameter can specify the required similarity. The value is between 0 and 1, with a value closer to 1 only terms with a higher similarity will be matched. For example:</p>
      <pre class="code">roam~0.8</pre>
      <p>The default that is used if the parameter is not given is 0.5.</p>
    </section>
    <hr /> 
  
    <section id="Proximity Searches">
      <h4>Proximity Searches</h4>
      <p>
        Use the tilde <strong class="label helpTerm">~</strong> symbol at the end of a <strong>Multiple</strong> word Term.
        For example, to search for economics and keynes that are within 10 words apart:
      </p>
      <pre class="code">"economics Keynes"~10</pre>
    </section>
    <hr />
  
    {literal}
    <section id="Range Searches">
      <h4>Range Searches</h4>
      <p>
        To perform a range search you can use either the <strong class="label helpTerm">{ }</strong> or the <strong class="label helpTerm">[ ]</strong> characters. 
        The <strong>{ }</strong> characters are exclusive and the <strong>[ ]</strong> characters are inclusive of the
        upper and lower bounds.
        For example to search for a term that starts with either B, or C:
      </p>
      <pre class="code">{A TO D}</pre>
      <p>
        The searches can be done with numeric fields such as the Year:
      </p>
      <pre class="code">[2002 TO 2003]</pre>
    </section>
    <hr />
    {/literal}
  
    <section id="Boosting a Term">
      <h4>Boosting a Term</h4>
      <p>
        To apply more value to a term, you can use the <strong class="label helpTerm">^</strong> character.
        For example, you can try the following search:
      </p>
      <pre class="code">economics Keynes^5</pre>
      <p>Which will give more value to the term "Keynes"</p>
    </section>
    <hr />
  
    <section id="Boolean operators">
      <h4>Boolean Operators</h4>
      <p>
        Boolean operators allow terms to be combined with logic operators.
        The following operators are allowed: <strong>AND</strong>, <strong>+</strong>, <strong>OR</strong>, <strong>NOT</strong> and <strong>-</strong>.
      </p>
      <p>Note: Boolean operators must be ALL CAPS</p>
      <dl>
        <dt><a name="AND"></a><h4 class="label">AND</h4></dt>
        <dd>
          <p>The <strong>AND</strong> operator is the default conjunction operator. This means that if there is no Boolean operator between two terms, the AND operator is used. The AND operator matches records where both terms exist anywhere in the field of a record.</p>
          <p>To search for records that contain "economics" and "Keynes" use the query: </p>
          <pre class="code">economics Keynes</pre>
          <p>or</p>
          <pre class="code">economics AND Keynes</pre>
        </dd>
        <dt><a name="+"></a><h4 class="label">+</h4></dt>
        <dd>
          <p>The "+" or required operator requires that the term after the "+" symbol exist somewhere in the field of a record.</p>
          <p>To search for records that must contain "economics" and may contain "Keynes" use the query:</p>
          <pre class="code">+economics Keynes</pre>
        </dd>
        <dt><a name="OR"></a><h4 class="label">OR</h4></dt>
        <dd>
          <p>The OR operator links two terms and finds a matching record if either of the terms exist in a record.</p>
          <p>To search for documents that contain either "economics Keynes" or just "Keynes" use the query:</p>
          <pre class="code">"economics Keynes" OR Keynes</pre>
        </dd>
        <dt><a name="NOT"></a><h4 class="label">NOT</h4></dt>
        <dd>
          <p>The NOT operator excludes records that contain the term after NOT.</p>
          <p>To search for documents that contain "economics" but not "Keynes" use the query: </p>
          <pre class="code">economics NOT Keynes</pre>
          <p>Note: The NOT operator cannot be used with just one term. For example, the following search will return no results:</p>
          <pre class="code">NOT economics</pre>
        </dd>
        <dt><a name="-"></a><h4 class="label">-</h4></dt>
        <dd>
          <p>The <Strong>-</strong> or prohibit operator excludes documents that contain the term after the "-" symbol.</p>
          <p>To search for documents that contain "economics" but not "Keynes" use the query: </p>
          <pre class="code">economics -Keynes</pre>
        </dd>
      </dl>
    </section>
    <hr />

    <section id="Phrase searches">
      <h4>Phrase searches</h4>
      <p>Search term or terms enclosed in quotation marks will be used literally.</p>
      <p>To search for records containing the exact phrase "ancient history" and not e.g. "history in the ancient times":</p>
      <pre class="code">"ancient history"</pre>
      <p>Also single words can be enclosed in quotation marks to use the term literally, ignoring different conjugations.</p>
    </section>
    <hr />

    <h3>Advanced Searching Tips</h3>

    <section id="Search Fields">
      <h4>Search Fields</h4>
      <p>When you first visit the Advanced Search page, you are presented with 
         several search fields.  In each field, you can type the keywords you 
         want to search for. Search operators are allowed.</p>
      <p>Each field is accompanied by a drop-down that lets you specify the type 
         of data (title, author, etc.) you are searching for.  You can mix and
         match search types however you like.</p>
      <p>The "Match" setting lets you specify how multiple search fields should
         be handled.</p>
      <ul>
        <li>ALL Terms - Return only records that match every search field.</li>
        <li>ANY Terms - Return any records that match at least one search field.</li>
        <li>NO Terms -- Return all records EXCEPT those that match search fields.</li>
      </ul>
      <p>The "Add Search Field" button may be used to add additional search fields
         to the form.  You may use as many search fields as you wish.</p>
    </section>
    <hr />
      
    <section id="Search Groups">
      <h4>Search Groups</h4>
      <p>For certain complex searches, a single set of search fields may not be 
         enough.  For example, suppose you want to find books about the history of
         China or India.  If you did an ALL Terms search for China, India, and 
         History, you would only get books about China AND India.  If you did an
         ANY Terms search, you would get books about history that had nothing to
         do with China or India.</p>
      <p>Search Groups provide a way to build searches from multiple groups of
         search fields.  Every time you click the "Add Search Group" button, a new
         group of fields is added.  Once you have multiple search groups, you can
         remove unwanted groups with the "Remove Search Group" button, and you can
         specify whether you want to match on ANY or ALL search groups.</p>
      <p>In the history of China or India example described above, you could solve
         the problem using search groups like this:</p>
      <ul>
        <li>In the first search group, enter "India" and "China" and make sure that
            the "Match" setting is "ANY Terms."</li>
        <li>Add a second search group and enter "history."</li>
        <li>Make sure the match setting next to the Search Groups header is set to
            "ALL Groups."</li>
      </ul>
    </section>
    <hr />

  </div>
  <p style="margin-top: 3em;"><a href="{$path}/">&laquo; {translate text="To Home"}</a></p>
  <div class="clearfix">&nbsp;</div>
</div>

<!-- END of: Content/searchhelp.fi.tpl -->
