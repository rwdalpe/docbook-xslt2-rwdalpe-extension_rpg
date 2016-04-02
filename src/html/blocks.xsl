<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  Copyright (C) 2016 Robert Winslow Dalpe
  
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
  xmlns:et="http://docbook.org/ns/docbook/extensions/rpg/private"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:t="http://docbook.org/xslt/ns/template"

  exclude-result-prefixes="xsl db f rpg h xs et">

  <xsl:template match="rpg:abilityscores">
    <xsl:param name="separator" as="xs:string" select="''"/>
    <div>
      <xsl:sequence select="f:html-attributes(.)"/>
      <xsl:apply-templates>
        <xsl:with-param name="separator" select="$separator"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <xsl:template match="rpg:statblocksection">
    <div>
      <xsl:sequence select="f:html-attributes(.)"/>
      <xsl:call-template name="t:titlepage"/>
      <xsl:apply-templates />
    </div>
  </xsl:template>
</xsl:stylesheet>