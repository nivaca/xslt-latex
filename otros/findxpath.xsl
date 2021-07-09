<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
  
  <xsl:template match="/">
    <xsl:for-each select="//ref">
      <xsl:value-of select="@target" />
      <xsl:text>
        
      </xsl:text>
    </xsl:for-each>
  </xsl:template>
    
<!--  <xsl:template match="ref">
    <xsl:value-of select="@target" />
  </xsl:template>-->
  
  <!--<xsl:template match="/">
    <xsl:apply-templates select="//ref"/>
  </xsl:template>
  
  <xsl:template match="ref">
    <xsl:value-of select="@target" />
  </xsl:template>-->
</xsl:stylesheet>