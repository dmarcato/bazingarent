<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method='html' version='1.0' encoding='UTF-8' indent='yes'/>
<xsl:template match="/">
	<div class="contBox">
		<xsl:for-each select="lista/film">
			
			<xsl:if test="(position() mod 2)=1">
		
				<div class="boxFilmL">
					<img alt="La principessa e il ranocchio">
						<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
					</img>
					<p class="titolo"><xsl:value-of select="titolo" /></p>
					<p class="info"><xsl:value-of select="uscita" /></p>
					<p class="descrizione">Bla bla bla bla</p>
					<a href="" title="Scheda film" class="more">Scheda film</a>
				</div>
				
			</xsl:if>
			
			<xsl:if test="(position() mod 2)=0">
		
				<div class="boxFilmR">
					<img alt="La principessa e il ranocchio">
						<xsl:attribute name="src"><xsl:value-of select="image" /></xsl:attribute>
					</img>
					<p class="titolo"><xsl:value-of select="titolo" /></p>
					<p class="info"><xsl:value-of select="uscita" /></p>
					<p class="descrizione">Bla bla bla bla</p>
					<a href="" title="Scheda film" class="more">Scheda film</a>
				</div>
				
			</xsl:if>
		</xsl:for-each>
	</div>

</xsl:template>

<xsl:template match=""
