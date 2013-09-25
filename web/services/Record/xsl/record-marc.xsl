<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:marc="http://www.loc.gov/MARC21/slim">
  <xsl:output method="html" indent="yes"/>
	
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
	
  <xsl:template match="marc:record">
      <table border="0" class="citation">
        <tr>
          <th>LEADER</th>
          <td colspan="3">
            <xsl:call-template name="replace-string">
              <xsl:with-param name="text" select="//marc:leader"/>
              <xsl:with-param name="replace" select="' '" />
              <xsl:with-param name="with" select="'·'"/>
            </xsl:call-template>
          </td>
        </tr>
		<xsl:apply-templates select="marc:datafield|marc:controlfield"/>
      </table>
  </xsl:template>
	
  <xsl:template match="//marc:controlfield">
      <tr>
        <th style="text-align: right;" valign="TOP">
          <xsl:value-of select="@tag"/>
        </th>
        <td colspan="3">
          <xsl:call-template name="replace-string">
            <xsl:with-param name="text" select="."/>
            <xsl:with-param name="replace" select="' '" />
            <xsl:with-param name="with" select="'·'"/>
          </xsl:call-template>
        <xsl:variable name="value" select="."/>
        </td>
      </tr>
  </xsl:template>
	
  <xsl:template match="//marc:datafield">
      <tr>
        <th style="text-align: right;" valign="TOP">
          <xsl:value-of select="@tag"/>
        </th>
        <td><xsl:value-of select="@ind1"/></td>
        <td><xsl:value-of select="@ind2"/></td>
        <td>
          <xsl:apply-templates select="marc:subfield"/>
        </td>
      </tr>
	</xsl:template>
	
	<xsl:template match="marc:subfield">
      <strong>|<xsl:value-of select="@code"/></strong>&#160;<xsl:value-of select="."/>&#160;
	</xsl:template>

  <xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text, $replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="substring-after($text, $replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>