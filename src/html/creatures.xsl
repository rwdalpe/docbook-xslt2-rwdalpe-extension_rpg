<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2014 Robert Winslow Dalpe

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as published
	by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>
-->
<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:db="http://docbook.org/ns/docbook"
	xmlns:f="http://docbook.org/xslt/ns/extension"
	xmlns:rpg="http://docbook.org/ns/docbook"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"

	exclude-result-prefixes="xsl db f rpg h xs">

	<xsl:template match="rpg:creature">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" />
			</div>
			<xsl:apply-templates select="./rpg:xpreward" />
			<div class="{local-name(.)}-raceClassLevels">
				<xsl:for-each select="./rpg:race | ./rpg:class">
					<xsl:apply-templates select="." />
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-alignmentSizeTypes">
				<xsl:for-each select="./rpg:alignment | ./rpg:size | ./rpg:creaturetypes">
					<xsl:apply-templates select="." />
					<xsl:text> </xsl:text>
				</xsl:for-each>
			</div>
			<div class="{local-name(.)}-initSenses">
				<xsl:apply-templates select="./rpg:initiative" />
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:senses" />
			</div>
			<div class="{local-name(.)}-auras">
				<span class="aura-title">
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="'aura'" />
					</xsl:call-template>
				</span>
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:aura" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="rpg:senses">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:sense" />
			<xsl:if test="./rpg:skill">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="./rpg:skill" />
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:challengerating">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:next-match />
		</span>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:xpreward">
		<div class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:next-match />
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:initiative">
		<span class="{local-name(.)}-container">
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:next-match />
		</span>
	</xsl:template>

	<xsl:template match="rpg:creaturetypes">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates select="./rpg:creaturetype" />
			<xsl:if test="./rpg:creaturesubtype">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="./rpg:creaturesubtype" />
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>
</xsl:stylesheet>