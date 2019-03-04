<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- This XSL is created to transform the XML results of a SOLR query to DataONE into a csv used to make
    requests for EML XML via a python function in the MDeval module.
    The query identified records from the LTER membernode that were all created at a particular LTER site.
    These requests are downloaded to directories based on the year they were uploaded to create collections.
    The collections are created from the most recent record in a year period. If a record is obsoleted by another
    record, and that record was also uploaded in the same year, only the most recent is downloaded from DataONE
     
    -->
    
    <!-- 
        Create a key from each record's id and dateUploaded
    -->
    <xsl:key name="obsoletedByAndYear" match="//doc" use="concat(str[@name = 'identifier'], substring(date[@name = 'dateUploaded'], 0, 5))"/>
    <!-- In case you like pipes better, commas are default though -->
    <xsl:param name="delimiter" select="','"/>
    <!-- As a text file -->
    <xsl:output method="text"/>
    
    <!-- For each doc element in the document get the download url for the metadata
        and the local filepath to save the results at -->
    
    <xsl:template match="/">
        <xsl:value-of select="concat('recordURL', ',','recordPath')"/>
        <xsl:value-of select="'&#xA;'"/>
        <xsl:for-each select="//doc">
            
            <!-- create an identifying string to compare with the key -->
            <xsl:variable name="searchString" select="concat(str[@name = 'obsoletedBy'], substring(date[@name = 'dateUploaded'], 0, 5))"/>
            <!-- use xsl 1.0 transform to make Site upper case for directories -->
            <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
            <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
            
            
           <!-- check to see if the record is obsoleted by anything. If it is test to see if the obsoleted identifier and the year
                are contained in a key of all the identifiers so that if the records were uploaded in the same year. If the record isn't add it to the csv for download. --> 
            <xsl:choose>
                <xsl:when test="boolean(str[@name = 'obsoletedBy'])">
                    <xsl:choose><xsl:when test="key('obsoletedByAndYear',$searchString)">
                    </xsl:when><xsl:otherwise> <!--download url-->
                        
                        <xsl:value-of select="./str[@name='dataUrl']"/>
                        
                        <!--a separator between url and filepath-->
                        
                        <xsl:value-of select="$delimiter"/>
                        
                        <!--Build local filepath to save the results at-->
                        
                        <xsl:text>../collections/LTER/</xsl:text>
                        <!-- directory for each site/year -->
                        <xsl:value-of select="translate(substring(substring-after(./str[@name='dataUrl'], 'lter-'),0,4),$lowercase,$uppercase)"/>
                        <xsl:text>__</xsl:text>
                      
                        <xsl:value-of select='substring(./date[@name = "dateUploaded"], 0, 5)'/>
                        <xsl:text>/</xsl:text>
                        <!-- use the end of the identifier to create a name for the record that
                             is easily traceable back to the original record on DataONE -->
                        <xsl:value-of select="translate(
                            substring(substring-after(./str[@name='identifier'], 'lter-'),5),'/', '.'
                            )"/>
                        <xsl:text>.xml</xsl:text>
                        
                        
                        <!-- Create a new line if it's not the last doc element to be be written to file -->
                        
                        <xsl:if test="not(position() = last())">
                            <xsl:value-of select="'&#xA;'"/>
                        </xsl:if>
                    </xsl:otherwise></xsl:choose>
                    
                    
                </xsl:when>
                <xsl:otherwise><!--download url-->
                    
                    <xsl:value-of select="./str[@name='dataUrl']"/>
                    
                    <!--a separator between url and filepath-->
                    
                    <xsl:value-of select="$delimiter"/>
                    
                    <!--Build local filepath to save the results at-->
                    
                    <xsl:text>../collections/LTER/</xsl:text>
                    <!-- directory for each site/year -->
                    <xsl:value-of select="translate(substring(substring-after(./str[@name='dataUrl'], 'lter-'),0,4),$lowercase,$uppercase)"/>
                    <xsl:text>__</xsl:text>                    
                    <xsl:value-of select='substring(./date[@name = "dateUploaded"], 0, 5)'/>
                    <xsl:text>/</xsl:text>
                    <!-- use the end of the identifier to create a name for the record that
                         is easily traceable back to the original record on DataONE -->
                    <xsl:value-of select="translate(
                        substring(substring-after(./str[@name='identifier'], 'lter-'),5),'/', '.'
                        )"/>
                    <xsl:text>.xml</xsl:text>
                    
                    
                    <!-- Create a new line if it's not the last doc element to be be written to file -->
                    
                    <xsl:if test="not(position() = last())">
                        <xsl:value-of select="'&#xA;'"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
