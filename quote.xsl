<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://my">
  
  
  <xsl:template name="my:lang">
    <xsl:param name="lname"/>
    <xsl:choose>
      <xsl:when test="$lname='ang'">english</xsl:when>
      <xsl:when test="$lname='enm'">english</xsl:when>
      <xsl:when test="$lname='eng'">english</xsl:when>
      <xsl:when test="$lname='lat'">latin</xsl:when>
      <xsl:when test="$lname='es'">spanish</xsl:when>
      <xsl:when test="$lname='fro'">french</xsl:when>
      <xsl:when test="$lname='frm'">french</xsl:when>
      <xsl:when test="$lname='fra'">french</xsl:when>
      <xsl:when test="$lname='grc'">greek</xsl:when>
      <xsl:when test="$lname='cyn'">welsh</xsl:when>
      <xsl:when test="$lname='deu'">german</xsl:when>
      <xsl:otherwise>english</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:function name="my:lang" as="xs:string">
    <xsl:param name="lname"/>
    <xsl:call-template name="my:lang">
      <xsl:with-param name="lname" select="$lname"/>
    </xsl:call-template>
  </xsl:function>
  
  
  
  <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    <foreign> | <mentioned> | <gloss> |
    and standalone <q>
    
    \MyQ
    % #1: lang
    % #2: label
    % #3: text   -->
  <xsl:template match="foreign | mentioned | gloss | q[not(parent::cit)]">
    <xsl:text>\MyQ</xsl:text>
    <!--insert lang-->
    <xsl:text>{</xsl:text>
    <xsl:choose>
      <xsl:when test="@xml:lang or name(.)='foreign'">
        <xsl:sequence select="my:lang(@xml:lang)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>spanish</xsl:text> 
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
    <!--insert label-->
    <xsl:text>{</xsl:text>
    <xsl:if test="@xml:id">
      <xsl:value-of select="@xml:id"/>
    </xsl:if>
    <xsl:text>}</xsl:text>
    <!--insert text-->
    <xsl:text>{</xsl:text>
    <xsl:if test="@ana='lexeme'">
      <xsl:text>\lexquote{</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="@ana='lexeme'">
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  
  
  <!--=============================================-->
  <!--                    <cit>                    -->
  <!--=============================================-->
  
  <!--cit / quote / q / ref-->
  <!-- 
    #1: language
    #2: label
    #3: original language text
    #4: translation text
    #5: reference
  -->
  <xsl:template match="cit[child::quote]">
    <xsl:text>\MyC</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:sequence select="my:lang(quote/@xml:lang)"/>
    <xsl:text>}</xsl:text>
    <!--insert label-->
    <xsl:text>{</xsl:text>
    <xsl:if test="quote[@xml:id]">
      <xsl:value-of select="quote/@xml:id"/>
    </xsl:if>
    <xsl:text>}</xsl:text>
    <!--insert original quote-->
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="quote"/>
    <xsl:choose>
      <xsl:when test="q">
        <!--insert comma-->
        <xsl:text>,</xsl:text>
        <xsl:text>}</xsl:text>
        <!--insert q trans.-->
        <xsl:text>{</xsl:text>
        <xsl:apply-templates select="q"/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!--simply close group 
          and create an empy one -->
        <xsl:text>}</xsl:text>
        <xsl:text>{}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!--insert ref-->
    <xsl:text>{</xsl:text>
    <xsl:if test="ref">
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="ref"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  
  
  <!-- <cit> without <quote>-->
  <xsl:template match="cit[not(child::quote)]">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <!--       <quote>        -->
  <xsl:template match="quote">
    <xsl:choose>
      <xsl:when test="@ana='verse'">
        <xsl:text>\indentedpar{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <!--       <q>        -->
  
  <xsl:template match="q">
    <xsl:choose>
      <xsl:when test="@rend='indented'">
        <xsl:text>\indentedpar{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>  
  
  
  
</xsl:stylesheet>
