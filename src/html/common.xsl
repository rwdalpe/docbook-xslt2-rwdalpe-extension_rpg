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

                exclude-result-prefixes="xsl db f rpg h xs et">

    <xsl:template name="container-span">
        <xsl:param name="key" required="yes"/>
        <xsl:param name="contents" as="node()*" select="()"/>

        <span class="{$key}-container">
            <span class="{$key}-title">
                <xsl:call-template name="gentext">
                    <xsl:with-param
                            name="key"
                            select="$key"/>
                </xsl:call-template>
            </span>
            <xsl:text> </xsl:text>
            <span class="{$key}-body">
                <xsl:copy-of select="$contents"/>
            </span>
        </span>
    </xsl:template>

    <xsl:template name="container-div">
        <xsl:param name="key" required="yes"/>
        <xsl:param name="contents" as="node()*" select="()"/>

        <div>
            <xsl:sequence select="f:html-attributes(.)"/>
            <span class="{$key}-title">
                <xsl:call-template name="gentext">
                    <xsl:with-param
                            name="key"
                            select="$key"/>
                </xsl:call-template>
            </span>
            <xsl:text> </xsl:text>
            <span class="{$key}-body">
                <xsl:copy-of select="$contents"/>
            </span>
        </div>
    </xsl:template>

    <xsl:template name="named-container-div">
        <xsl:param name="name" required="yes"/>
        <xsl:param name="contents" as="node()*" select="()"/>

        <div>
            <xsl:sequence select="f:html-attributes(.)"/>
            <span class="{translate($name, ' ','')}-title">
                <xsl:value-of select="$name"/>
            </span>
            <xsl:text> </xsl:text>
            <span class="{translate($name, ' ','')}-body">
                <xsl:copy-of select="$contents"/>
            </span>
        </div>
    </xsl:template>

</xsl:stylesheet>