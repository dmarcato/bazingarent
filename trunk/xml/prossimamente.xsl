<?xml version="1.0" encoding="UTF-8"?>
<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" />
<xsl:template match="/">
	
		<xsl:for-each select="lista/film">
			
			<xsl:sort select="data"/>
			
			<xsl:if test="((position() mod 2)=1) and (data/anno = '--')">
		
				<div class="boxFilmL">
					<img>
						<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
						<xsl:attribute name="alt"><xsl:value-of select="titolo" /></xsl:attribute>
					</img>
					<p class="titolo"><xsl:value-of select="titolo" /></p>
					<p class="info"><xsl:value-of select="uscita" /></p>
					<div class="descr">
						<p class="descrizione"><xsl:value-of select="descrizione" /></p>
					</div>
					<a title="Scheda film" class="more">
						<xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
					Scheda film</a>
				</div>
				
			</xsl:if>
			
			<xsl:if test="((position() mod 2)=0) and (data/anno = '--')">
		
				<div class="boxFilmR">
					<img>
						<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
						<xsl:attribute name="alt"><xsl:value-of select="titolo" /></xsl:attribute>
					</img>
					<p class="titolo"><xsl:value-of select="titolo" /></p>
					<p class="info"><xsl:value-of select="uscita" /></p>
					<div class="descr">
						<p class="descrizione"><xsl:value-of select="descrizione" /></p>
					</div>
					<a title="Scheda film" class="more">
						<xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
					Scheda film</a>
				</div>
				
			</xsl:if>
		</xsl:for-each>

</xsl:template>
