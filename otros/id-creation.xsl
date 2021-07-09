<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xi="http://www.w3.org/2001/XInclude" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
<xsl:output method="xml" indent="no"/>
  <!--<xsl:variable name="commentaryslug"><xsl:value-of select="tokenize(//body/div/@xml:id, '-')[1]"/></xsl:variable>
    <xsl:variable name="suffixpart"><xsl:value-of select="tokenize(//body/div/@xml:id, '-')[last()]"/></xsl:variable>-->
    
    <xsl:template match="body//lb">
        <xsl:copy copy-namespaces="no">
            <xsl:attribute name="xml:id">
                <xsl:value-of select="generate-id()"></xsl:value-of>
            </xsl:attribute>
            <xsl:apply-templates select="./@* | node()"/>
        </xsl:copy>
    </xsl:template>
  
  
  <xsl:template match="body//head">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="xml:id">
        <xsl:value-of select="generate-id()"></xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates select="./@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  
  <xsl:template match="body//p">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="xml:id">
        <xsl:value-of select="generate-id()"></xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates select="./@* | node()"/>
    </xsl:copy>
  </xsl:template>
    
  <xsl:template match="body//q">
      <xsl:copy copy-namespaces="no">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="generate-id()"></xsl:value-of>
        </xsl:attribute>
        <xsl:apply-templates select="./@* | node()"/>
      </xsl:copy>
    </xsl:template>
  
  <xsl:template match="body//l">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="xml:id">
        <xsl:value-of select="generate-id()"></xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates select="./@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
    <!--<xsl:template match="body//quote">
      <xsl:copy copy-namespaces="no">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="concat($commentaryslug, '-', $suffixpart, '-Q', generate-id())"></xsl:value-of>
        </xsl:attribute>
        <xsl:apply-templates select="./@* | node()"/>
      </xsl:copy>
    </xsl:template>
  <xsl:template match="body//ref[not(parent::bibl)]">
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="xml:id">
        <xsl:value-of select="concat($commentaryslug, '-', $suffixpart, '-R', generate-id())"></xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates select="./@* | node()"/>
    </xsl:copy>
  </xsl:template>
    <xsl:template match="body//head">
      <xsl:copy copy-namespaces="no">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="concat($commentaryslug, '-', $suffixpart, '-H', generate-id())"></xsl:value-of>
        </xsl:attribute>
        <xsl:apply-templates select="./@* | node()"/>
      </xsl:copy>
    </xsl:template>-->
    
    <!-- IdentityTransform -->
    
    <xsl:template match="@* | node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
  
</xsl:stylesheet>
