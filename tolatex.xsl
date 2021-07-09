<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://my">
  
  
  
  <!-- -  -  -  -  -  -  IMPORTS  -  -  -  -  -  - --> 
  
  <!--contains <ref> related templates-->
  <xsl:import href="ref.xsl"/> 
  
  
  
  <!--contains citation related templates-->
  <xsl:import href="quote.xsl"/>
  
  <!-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  - -->
  
  
  
  <!-- Variables from XML teiHeader -->
  <xsl:variable name="title"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/title"/></xsl:variable>
  <xsl:variable name="author"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/author"/></xsl:variable>
  <xsl:variable name="editor"><xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/editor"/></xsl:variable>
  <xsl:param name="targetdirectory">null</xsl:param>
  
  <!-- get versioning numbers -->
  <xsl:param name="sourceversion"><xsl:value-of select="/TEI/teiHeader/fileDesc/editionStmt/edition/@n"/></xsl:param>
  <xsl:param name="sourcedate"><xsl:value-of select="/TEI/teiHeader/fileDesc/editionStmt/edition/date/@when"/></xsl:param>
  
  <!-- combined version number should have mirror syntax of an equation x+y source+conversion -->
  <xsl:variable name="combinedversionnumber">
    <xsl:value-of select="$sourceversion"/><xsl:text>, </xsl:text>
    <xsl:value-of select="$sourcedate"/>
  </xsl:variable>
  <!-- end versioning numbers -->
  
  
  
  <!-- Processing variables -->
  <xsl:variable name="fs"><xsl:value-of select="/TEI/text/body/div/@xml:id"/></xsl:variable>
  <xsl:variable name="name-list-file">prosopography.xml</xsl:variable>
  <xsl:variable name="work-list-file">bibliography.xml</xsl:variable>
  
  
  <!-- BEGIN: Document configuration -->
  
  
  <xsl:output method="text" encoding="UTF-8" indent="no"/>
  
  <xsl:template match="text()">
    <xsl:value-of select="replace(., '\s+', ' ')"/>
  </xsl:template>
  
  
  
  
  <!--function my:cleantext-->
  <xsl:function name="my:cleantext">
    <xsl:param name="input"/>
    <xsl:variable name="step1" select="replace($input, '\n+', ' ')"/>
    <xsl:variable name="step2" select="normalize-space($step1)"/>
    <xsl:sequence select="$step2"/>
  </xsl:function>
  
  
  
  <!--     Main Template    -->
  <!--                      -->
  
  <xsl:template match="/">
    \def\SMVersion{<xsl:value-of select="$combinedversionnumber"/>}
    \input{smpreamble.tex}
    % -----------------------------------------------
    \begin{document}
    \input{frontmatter.tex}
    \mainmatter
    \pagestyle{smtrad}
    \chapterstyle{smtrad}
    
    <xsl:apply-templates select="//body"/>
    
    \input{backmatter.tex}
    \end{document}
    % ===============================================
  </xsl:template>
  
  
  
  <!--  div head  -->
  <!--
    level1 are part divisions
    level2 are chapter divisions
  -->
  <xsl:template match="div[child::head]">
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:choose>
      <xsl:when test="head[@ana='level1']">
        <xsl:text>\part</xsl:text>
      </xsl:when>
      <xsl:when test="head[@ana='level2']">
        <xsl:text>\chapter</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\section</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>{</xsl:text>
    <xsl:copy-of select="head"/>
    <xsl:text>}</xsl:text>
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <xsl:template match="head">
    <!--<xsl:apply-templates/>-->
  </xsl:template>
  
  <xsl:template match="head[note]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- - - - - - - - - - - - - - - - - - - - -->
  <!--                   <p>                 -->
  <!-- - - - - - - - - - - - - - - - - - - - -->
  
  <xsl:template match="p">
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:choose>
      <!--special centered paragraph, quasi header-->
      <xsl:when test="@ana='h1' or @ana='h2'">
        <xsl:text>
          \begin{adjustwidth}{.2\textwidth}{.2\textwidth}
          \begin{center}</xsl:text>
        <xsl:if test="@ana='h1'">
          <xsl:text>\large{}</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:text>\end{center}
          \end{adjustwidth}
          
          \bigskip
        </xsl:text>
      </xsl:when>
      <!--indented paragraph-->
      <xsl:when test="@rend='indented'">
        <xsl:text>\begin{indentedpar}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{indentedpar}</xsl:text>
      </xsl:when>
      <!-- -->
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!--a paragraph inside a note-->
  <xsl:template match="p[parent::note]">
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:if test="@n > 1 and not(@rend='nofirstlineindent')">
      <xsl:text>\par\hspace*{14pt}</xsl:text>
    </xsl:if>
    <xsl:choose>
      <!--indented paragraph-->
      <xsl:when test="@rend='indented'">
        <xsl:text>\begin{indentedpar}</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\end{indentedpar}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
        <!--only insert \par if next paragraph 
          doesn't include a quote-->
        <xsl:if test="not(following-sibling::p[descendant::quote])">
          <xsl:text>\par</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- - - - - - - - - - - - - - - - - - - - -->
  <!--                   <lb>                 -->
  <!-- - - - - - - - - - - - - - - - - - - - -->
  
  <xsl:template match="lb[@type='nonumber']" priority="2">
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@xml:id"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  <!-- only first <lb>-->
  <xsl:template match="lb[@n='1']">
    <xsl:text>&#10;&#10;{\tiny\sidepar{\small¶</xsl:text>
    <xsl:value-of select="../@n"/>
    <xsl:text>}}</xsl:text>
    <xsl:text>\hspace*{14pt}</xsl:text>
    <xsl:text>\Linum{</xsl:text>
    <xsl:value-of select="@n"/>
    <xsl:text>}</xsl:text>
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="@xml:id"/>
    <xsl:text>}~</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
  
  
  
  <!-- <lb> -->
  <xsl:template match="lb">
    <!--do not insert \n if its parent is a <q> -->
    <xsl:if test="not(parent::q)">
      <xsl:text></xsl:text>
    </xsl:if>
    <xsl:choose>
      <!--        only for Dialogue:      -->
      <xsl:when test="../@n='4'">
        <!--<xsl:if test="contains(./@n, 'a')">
          <xsl:text>\bigskip{}</xsl:text>
          </xsl:if>-->
        <xsl:text>&#10;&#10;</xsl:text>
        <xsl:text>\par</xsl:text>
        <xsl:text>\hspace*{14pt}\Linum{</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>}</xsl:text>
        <xsl:text>\label{</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>}~</xsl:text>
        <xsl:apply-templates/>
      </xsl:when>
      <!--for all others: -->
      <xsl:otherwise>
        <xsl:if test="(preceding-sibling::lb)">
          <xsl:text></xsl:text>
        </xsl:if>
        <xsl:text>\Linum{</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>}</xsl:text>
        <xsl:text>\label{</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>}~</xsl:text>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <!-- - - - - - - - - - - - - - - - - - - - -->
  <!--                  <title>               -->
  <!-- - - - - - - - - - - - - - - - - - - - -->
  
  <xsl:template match="title">
    <xsl:choose>
      <!--manuscripts-->
      <xsl:when test="@type='ms'">
        <xsl:text>\MS</xsl:text>
      </xsl:when>
      <!--editions-->
      <xsl:when test="@type='ed'">
        <xsl:text>\ED</xsl:text>
      </xsl:when>
      <!--normal titles-->  
      <xsl:otherwise>
        <xsl:text>\Title</xsl:text>
        <xsl:if test="@rend='upshape'">
          <xsl:text>*</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <!-- index: -->
    <xsl:text>{</xsl:text>
    <xsl:choose>
      <xsl:when test="@ana">
        <xsl:sequence select="my:cleantext(@ana)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
    <!-- title/ms/ed name --> 
    <xsl:text>{</xsl:text>
    <xsl:choose>
      <xsl:when test="@ana">
        <xsl:sequence select="my:cleantext(@ana)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  
  
  
  <!-- - - - - - - - - - - - - - - - - - - - -->
  <!--                  <name>               -->
  <!-- - - - - - - - - - - - - - - - - - - - -->
  
  <xsl:template match="name">
    <xsl:text>\Nombre{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
    <xsl:text>\index[names]</xsl:text>
    <xsl:text>{</xsl:text> 
    <xsl:choose>
      <xsl:when test="@ana">
        <xsl:sequence select="my:cleantext(@ana)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
  
  
  <!--standalone <l> -->
  <xsl:template match="l[not(parent::lg)]">
    <xsl:if test="preceding-sibling::l">
      <xsl:text> /
      </xsl:text>
    </xsl:if>
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- <l> within an <lg> -->
  <xsl:template match="l[parent::lg]">
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>\\</xsl:text>
  </xsl:template>
  
  
  
  <xsl:template match="lg">
    <xsl:text>\begin{myverse}</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{myverse}</xsl:text>
  </xsl:template>
  
  
  
  
  
  <!-- -  -  -  -  -  <hi>  -  -  -  -  - -->
  
  <xsl:template match="hi">
    <xsl:choose>
      <xsl:when test="@rend='sc'">
        <xsl:text>\textsc{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="@rend='bf'">
        <xsl:text>\textbf{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="@rend='superscript'">
        <xsl:text>\textsuperscript{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:when test="@rend='upshape'">
        <xsl:text>\textup{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\emph{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <xsl:template match="gap">
    <xsl:text>\elipsis{}</xsl:text>
  </xsl:template>
  
  
  
  <!-- supplied --> 
  <!-- @ana='eq' produces: [$=$ ]-->
  <!-- @ana='q' uses parenthesis instead of brackets -->
  <!-- @ana='peq' produces: ($=$ ) -->
  <xsl:template match="supplied">
    <xsl:choose>
      <xsl:when test="@rend='nobrackets'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@ana='p' or @ana='peq'">
            <xsl:text>(</xsl:text>
          </xsl:when>  
          <xsl:otherwise>
            <xsl:text>[</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@ana='p' or @ana='peq'">
          <xsl:text>$=$</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:choose>
          <xsl:when test="@ana='p' or @ana='peq'">
            <xsl:text>)</xsl:text>
          </xsl:when>  
          <xsl:otherwise>
            <xsl:text>]</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  
  <!-- . . . . . . . . . . . . -->
  <!--         endnotes        -->
  
  <xsl:template match="note">
    <!--check if two notes go together-->
    <xsl:if test="preceding-sibling::node()[not(self::text()[normalize-space()=''])][1][self::note]">
      <xsl:text>\notesep</xsl:text>
    </xsl:if>
    <xsl:text>\endnote{</xsl:text>
    <!--insert label-->
    <xsl:if test="@xml:id">
      <xsl:text>\label{</xsl:text>
      <xsl:value-of select="@xml:id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
 
 
 
  
  
  <xsl:template match="caesura">
    <xsl:text>\caesura{}</xsl:text>
  </xsl:template>
  
  
  <!--                 Tables                   -->
  
  <!-- table -->
  <xsl:template match="table">
    <xsl:text>&#10;&#10;\begin{ctabular}{</xsl:text>
    <xsl:value-of select="@rend"/>
    <xsl:text>}</xsl:text>
    <xsl:text>\toprule&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\bottomrule&#10;</xsl:text>
    <xsl:text>\end{ctabular}&#10;&#10;</xsl:text>
  </xsl:template>
  
  
  <!-- row -->
  <xsl:template match="row">
    <xsl:apply-templates/>
    <xsl:text> \\&#10;</xsl:text>
  </xsl:template>
  
  <!-- cell -->
  <xsl:template match="cell">
    <xsl:apply-templates/>
    <!--insert &amp; if not last cell in row-->
    <xsl:choose>
      <xsl:when test="following-sibling::cell">
        <xsl:text> &amp; </xsl:text>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  
  
  
  <!--      required by LaTeX sometimes    -->
  
  <xsl:template match="ab[@ana='leavevmode']">
    <xsl:text>\leavevmode</xsl:text>
  </xsl:template>
  
  
  
  <!--      forced new line      -->
  <xsl:template match="ab[@ana='nl']">
    <xsl:text>\par</xsl:text>
  </xsl:template>
  
  
  <!-- separator between consecutive notes -->
  <!--  <xsl:template match="pc[@ana='notesep']">
    <xsl:text>\notesep</xsl:text>
    </xsl:template>
  -->  
  
</xsl:stylesheet>
