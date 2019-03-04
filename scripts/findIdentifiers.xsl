<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="text"/>   
    <xsl:template match="/">
        <xsl:value-of select="concat('baseIDyear', ',', 'Identifier', ',', 'Year', ',', 'ObsoletedByID', ',', 'dataUrl')"/>
        <xsl:value-of select="'&#xA;'"/>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="doc">
        <xsl:variable name="identifier" select="translate(
            substring-after(str[@name='identifier'], 'lter-'),'/', '.'
            )"/>
        <xsl:variable name="baseIdentifier">
            <xsl:call-template name="getBaseIdentifier">
                <xsl:with-param name="identifier" select="$identifier"/>
                <xsl:with-param name="date" select="substring(date[@name='dateUploaded'], 0, 5)"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$baseIdentifier"/>               
    </xsl:template>
    <xsl:template name="getBaseIdentifier">
        <xsl:param name="identifier"/>
        <xsl:param name="date"/>       
        <!--<xsl:variable name="tokenizeID" select="tokenize($identifier,'.')"/>-->
        <xsl:variable name="siteBaseID" select="concat(substring-before($identifier, '.'), '.', substring-before(substring-after($identifier, '.'), '.'), ' ', $date)"/>

        <xsl:value-of select="concat($siteBaseID, ',', $identifier, ',', $date, ',')"/>
        <xsl:choose>
            <xsl:when test="str[@name='obsoletedBy']"><xsl:value-of select="translate(
                substring-after(str[@name='obsoletedBy'], 'lter-'),'/', '.'
                )"/></xsl:when><xsl:otherwise>None</xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="','"/><xsl:value-of select="str[@name='dataUrl']"/>
        <xsl:if test="not(position() = last())">
            <xsl:value-of select="'&#xA;'"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text()"/>
</xsl:stylesheet>
