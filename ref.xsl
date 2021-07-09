<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://my">
  
  
  
  <xsl:function name="my:cleanref" as="xs:string">
    <xsl:param name="input"/>
    <xsl:sequence select="replace($input, '#', '')"/>
  </xsl:function>
  
  <xsl:function name="my:cleanurl" as="xs:string">
    <xsl:param name="input"/>
    <xsl:variable name="temp" select="replace($input, '#', '\\#')"/>
    <xsl:sequence select="replace($temp, '%', '\\%')"/>
  </xsl:function>
  
  
  <!--
    #####################
         ref @type
    #####################
    a:        \citeauthor
    p:        \parencite
    t:        \citetitle
    y:        \citeyear
    py:       \citeyear in parenthesis
    abbr:     \citeabbr
    pabbr:    \citeabbr in parenthesis: (ZSM, 297)
    abbrpc:    \citeabbr (content)
    fulltext: use text/rend without calling LaTeX's cite
    nc:       \nocite
    pnc:      \nocite in parenthesis
    url:      href
  -->
  
  <xsl:function name="my:processref">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type='a'">
        <xsl:text>\citeauthor*</xsl:text>
      </xsl:when>
      <xsl:when test="$type='p'">
        <xsl:text>\parencite</xsl:text>
      </xsl:when>
      <xsl:when test="$type='t'">
        <xsl:text>\citetitle</xsl:text>
      </xsl:when>
      <xsl:when test="$type='y'">
        <xsl:text>\citeyear</xsl:text>
      </xsl:when>
      <xsl:when test="$type='py'">
        <xsl:text>\parencite*</xsl:text>
      </xsl:when>
      <xsl:when test="$type='abbr'">
        <xsl:text>\citeabbr</xsl:text>
      </xsl:when>
      <xsl:when test="$type='pabbr'">
        <xsl:text>\citeabbr*</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!--debug!-->
        <xsl:text>\myerror{}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  
   <!--                   ref[@type='abbrpc']                -->
  <xsl:template match="ref[@type='abbrpc']" priority="2">
    <xsl:text>\citeabbr{</xsl:text>
    <xsl:value-of select="my:cleanref(@target)"/>
    <xsl:text>}</xsl:text>
    <!--insert rend/text-->
    <xsl:text>\space(</xsl:text>
    <xsl:choose>
      <!--select @rend if present-->
      <xsl:when test="@rend">
        <xsl:value-of select="@rend"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>)</xsl:text>
  </xsl:template>
  
  <!--            ref[@type='nc' or @type='pnc']             -->
  <!--                      nocite refs                      -->
  <xsl:template match="ref[@type='nc' or @type='pnc']" priority="2">
    <xsl:text>\nocite{</xsl:text>
    <xsl:value-of select="my:cleanref(@target)"/>
    <xsl:text>}</xsl:text>
    <!--insert rend/text-->
    <xsl:if test="@type='pnc'">
      <xsl:text>(</xsl:text>
    </xsl:if>
    <xsl:choose>
      <!--select @rend if present-->
      <xsl:when test="@rend">
        <xsl:value-of select="@rend"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@type='pnc'">
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>
  
  
 
  
  <!--                  ref[@type='fulltext']              -->
  <!--              simply insert ref contents             -->
  <!--                    no LaTeX cite                    -->
  <xsl:template match="ref[@type='fulltext']" priority="2">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <!-- ~~~~~~~~~~~~~ ref[@type='url'] ~~~~~~~~~~~~~~~~ -->
  <xsl:template match="ref[@type='url']" priority="2">
    <xsl:text>\href</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:sequence select="my:cleanurl(@target)"/>
    <xsl:text>}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  
  
  <!--               all standalone <ref>             -->
  <!--              (only internal xrefs)             -->
  <xsl:template match="ref[@type='internal']" priority="2">
    <xsl:text>\hyperref[</xsl:text>
    <xsl:sequence select="my:cleanref(@target)"/>
    <xsl:text>]{</xsl:text>
    <xsl:choose>
      <!--select @rend if present-->
      <xsl:when test="@rend">
        <xsl:value-of select="@rend"/>
      </xsl:when>
      <xsl:otherwise>
        <!--only if ref has content-->
        <xsl:if test="./text()">
          <xsl:apply-templates/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  
  
  <!-- . . . . . . . . .  ref[parent::cit] . . . . . . . .-->
  <xsl:template match="ref[parent::cit]">
    <!--Two possibilities:
      1. refers to EnM or Lat editions (incunabula)
      2. refers to a bibliographic entry-->
    <xsl:choose>
      <!--                                                        -->
      <!--                1. refers to incunabula                 -->
      <!--                                                        -->
      <xsl:when test="@target[starts-with(.,'salmarc')]">
        <xsl:text>\LinkSM{</xsl:text>
        <xsl:choose>
          <!--select @rend if present-->
          <xsl:when test="@rend">
            <xsl:text>{</xsl:text>
            <xsl:value-of select="@rend"/>
            <xsl:text>}</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <!--                                                        -->
      <!--       2. refers to a normal bibliographic entry        -->
      <!--                                                        -->
      <xsl:when test="@target[starts-with(.,'#')] 
        and not(starts-with(@corresp, 'vulgClem'))">
        <xsl:choose>
          <xsl:when test="@type">
            <xsl:sequence select="my:processref(@type)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>\cite</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!-- -->
        <!--insert text/rend-->
        <xsl:choose>
          <!--select @rend if present-->
          <xsl:when test="@rend">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@rend"/>
            <xsl:text>]</xsl:text>
          </xsl:when>
          <!--if there is any content, push it-->
          <xsl:when test="text()">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
        <!-- -->
        <!--insert key-->
        <xsl:text>{</xsl:text>
        <xsl:value-of select="my:cleanref(@target)"/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <!--Vulgata-->
      <xsl:when test="starts-with(@corresp, 'vulgClem')">
        <xsl:text>\VulgCit</xsl:text>
        <xsl:text>{</xsl:text>
        <xsl:sequence select="my:cleanref(@target)"/>
        <xsl:text>}</xsl:text>
        <xsl:choose>
          <!--select @rend if present-->
          <xsl:when test="@rend">
            <xsl:text>{</xsl:text>
            <xsl:value-of select="@rend"/>
            <xsl:text>}</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>{</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!--debug!-->
        <xsl:text>\marginpar{\textcolor{red}{</xsl:text>
        <xsl:text>ERROR!</xsl:text>
        <xsl:text>}}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
</xsl:stylesheet>