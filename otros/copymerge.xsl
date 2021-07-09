<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
<xsl:output method="xml" indent="yes"/>
  <!--<xsl:variable name="commentaryslug"><xsl:value-of select="tokenize(//body/div/@xml:id, '-')[1]"/></xsl:variable>
    <xsl:variable name="suffixpart"><xsl:value-of select="tokenize(//body/div/@xml:id, '-')[last()]"/></xsl:variable>-->
    
 
    
    <!-- IdentityTransform -->
    
    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
  
</xsl:stylesheet>
