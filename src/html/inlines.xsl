<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Copyright (C) 2014 Robert Winslow Dalpe
  
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.
  
  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:db="http://docbook.org/ns/docbook" xmlns:f="http://docbook.org/xslt/ns/extension"
  xmlns:rpg="http://docbook.org/ns/docbook"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  
  exclude-result-prefixes="xsl db f rpg h xs">

  <xsl:template match="rpg:alignment|rpg:location|rpg:settlementtype
                            |rpg:government|rpg:settlementquality|rpg:settlementdisadvantage">
    <span>
      <xsl:sequence select="f:html-attributes(.)"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="rpg:settlementdanger">
    <xsl:param name="prependSpace" as="xs:boolean" select="false()" required="no"/>
    <xsl:variable name="hasMod" select="./@modifier"/>
    <xsl:variable name="hasBody" select="./(*|text())"/>
    
    <span>
      <xsl:sequence select="f:html-attributes(.)"/>
      
      <xsl:if test="$hasBody">
        <xsl:if test="$prependSpace">
            <xsl:text> </xsl:text>
        </xsl:if>
        <span class="{local-name(.)}-body"><xsl:apply-templates/></span>
      </xsl:if>
      <xsl:if test="$hasMod">
        <xsl:if test="$prependSpace or $hasBody">
            <xsl:text> </xsl:text>
        </xsl:if>
        <span class="{local-name(.)}-modifier">
          <xsl:choose>
            <xsl:when test="$hasBody">(<xsl:value-of select="@modifier"/>)</xsl:when>
            <xsl:otherwise><xsl:value-of select="@modifier"/></xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:if>
    </span>
  </xsl:template>
  
  <xsl:template match="rpg:population">
    <xsl:variable name="hasCount" select="@count"/>
    <xsl:variable name="hasBody" select="./(*|text())"/>
    
    <span>
      <xsl:sequence select="f:html-attributes(.)"/>
      
      <xsl:if test="$hasCount">
        <span class="{local-name(.)}-count">
          <xsl:value-of select="@count"/>
        </span>
      </xsl:if>
      <xsl:if test="$hasBody">
        <xsl:if test="$hasCount">
            <xsl:text> </xsl:text>
        </xsl:if>
        <span class="{local-name(.)}-body"><xsl:apply-templates/></span>
      </xsl:if>
    </span>
  </xsl:template>
  
  <xsl:template match="rpg:attribute">
    <xsl:param name="separator" as="xs:string" select="', '"/>
    
    <xsl:variable name="hasScore" select="@score"/>
    <xsl:variable name="hasMod" select="@modifier"/>
    
    <span>
      <xsl:sequence select="f:html-attributes(.)"/>
      <span class="{local-name(.)}-name"><xsl:apply-templates/></span>
      <xsl:if test="$hasScore">
        <xsl:text> </xsl:text>
        <span class="{local-name(.)}-score"><xsl:value-of select="@score"/></span>
      </xsl:if>
      <xsl:if test="$hasMod">
        <xsl:text> </xsl:text>
        <span class="{local-name(.)}-modifier">
          <xsl:choose>
            <xsl:when test="$hasScore">(<xsl:value-of select="@modifier"/>)</xsl:when>
            <xsl:otherwise><xsl:value-of select="@modifier"/></xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:if>
    </span>
    <xsl:if test="following-sibling::rpg:attribute">
      <xsl:value-of select="$separator"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>