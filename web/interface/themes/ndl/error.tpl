{capture name=errorContent assign=errorContent}
  <div class="contentHeader noResultHeader"><div class="content"><h1>{translate text="An error has occurred"}</h1></div></div>
    <div class="content">
      <div class="grid_24">
        <div class="error fatalError">
        <p class="errorMsg">{$error->getMessage()|translate|escape}</p>
        {if $debug}
          <p class="errorStmt">{$error->getDebugInfo()}</p>
        {/if}
        <p>
          {translate text="Please contact the Library Reference Department for assistance"}
          <br/>
          <a href="mailto:{$supportEmail}">{$supportEmail}</a>
        </p>
        {if $debug}
        <div class="debug">
          <h2>{translate text="Debug Information"}</h2>
          {assign var=errorCode value=$error->getCode()}
          {if $errorCode}
          <p class="errorMsg">{translate text="Code"}: {$errorCode}</p>
          {/if}
          <p>{translate text="Backtrace"}:</p>
          <code>
          {foreach from=$error->backtrace item=trace}
            [{$trace.line}] {$trace.file}<br/>
          {/foreach}
          </code>
        </div>
        {/if}
      </div>
    </div>
  </div>
{/capture}


{include file="layout.tpl" errorPage=true errorContent=$errorContent userLang = $site.language}