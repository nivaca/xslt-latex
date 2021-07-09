<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  version="2.0">
  
  <xsl:strip-space elements="*" />
  <xsl:preserve-space elements="q p" />
  
  <xsl:output method="text" indent="no"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  
</xsl:stylesheet>