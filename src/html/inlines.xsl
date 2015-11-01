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
	xmlns:t="http://docbook.org/xslt/ns/template"

	exclude-result-prefixes="xsl db f rpg h xs t">

	<xsl:template
		match="rpg:alignment|rpg:location|rpg:settlementtype
														|rpg:government|rpg:settlementquality|rpg:settlementdisadvantage
														|rpg:creaturename | rpg:challengerating | rpg:xpreward
														| rpg:race | rpg:size | rpg:creaturetype">
		<xsl:call-template name="t:inline-charseq" />
	</xsl:template>

	<xsl:template match="rpg:skill">
		<xsl:param
			name="separator"
			as="xs:string"
			select="', '" />

		<xsl:variable
			name="hasModifier"
			select="@modifier" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-body">
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()[not(self::rpg:qualifier)]">
						<xsl:choose>
							<xsl:when test="self::text()">
								<xsl:copy-of select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="t:inline-charseq" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="t:xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</span>
			<xsl:if test="$hasModifier">
				<xsl:text> </xsl:text>
				<span class="{local-name(.)}-modifier">
					<xsl:value-of select="@modifier" />
				</span>
			</xsl:if>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</span>
		<xsl:if test="following-sibling::*[1][self::rpg:sense]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:qualifier">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:text>(</xsl:text>
			<xsl:call-template name="t:inline-charseq" />
			<xsl:text>)</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="rpg:sense">
		<xsl:param
			name="separator"
			as="xs:string"
			select="', '" />

		<xsl:variable
			name="hasRange"
			select="@range" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-body">
				<xsl:call-template name="t:inline-charseq" />
			</span>
			<xsl:if test="$hasRange">
				<xsl:text> </xsl:text>
				<span class="{local-name(.)}-range">
					<xsl:value-of select="@range" />
				</span>
			</xsl:if>
		</span>
		<xsl:if test="following-sibling::*[1][self::rpg:sense]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:creaturesubtype">
		<xsl:param
			name="separator"
			select="', '" />

		<xsl:call-template name="t:inline-charseq" />
		<xsl:if test="following-sibling::*[1][self::rpg:creaturesubtype]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:initiative">
		<xsl:variable
			name="hasBody"
			select="./text()|./*" />
		<xsl:variable
			name="hasMod"
			select="@modifier" />
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:if test="$hasBody">
				<span class="{local-name(.)}-body">
					<xsl:call-template name="t:inline-charseq" />
				</span>
			</xsl:if>
			<xsl:if test="$hasMod">
				<xsl:text> </xsl:text>
				<span class="{local-name(.)}-modifier">
					<xsl:choose>
						<xsl:when test="$hasBody">
							<xsl:text>(</xsl:text>
							<xsl:value-of select="@modifier" />
							<xsl:text>)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@modifier" />
						</xsl:otherwise>
					</xsl:choose>
				</span>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:class">
		<xsl:param
			name="separator"
			as="xs:string"
			select="'/'" />
		<span class="class-container">
			<xsl:call-template name="t:inline-charseq" />
			<xsl:if test="@level">
				<xsl:text> </xsl:text>
				<span class="class-level">
					<xsl:value-of select="@level" />
				</span>
			</xsl:if>
		</span>
		<xsl:if test="following-sibling::*[1][self::rpg:class]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:settlementdanger">
		<xsl:param
			name="prependSpace"
			as="xs:boolean"
			select="false()"
			required="no" />
		<xsl:variable
			name="hasMod"
			select="./@modifier" />
		<xsl:variable
			name="hasBody"
			select="./(*|text())" />

		<span class="settlementdanger-container">
			<xsl:if test="$hasBody">
				<xsl:if test="$prependSpace">
					<xsl:text> </xsl:text>
				</xsl:if>
				<span class="{local-name(.)}-body">
					<xsl:call-template name="t:inline-charseq" />
				</span>
			</xsl:if>
			<xsl:if test="$hasMod">
				<xsl:if test="$prependSpace or $hasBody">
					<xsl:text> </xsl:text>
				</xsl:if>
				<span class="{local-name(.)}-modifier">
					<xsl:choose>
						<xsl:when test="$hasBody">
							(
							<xsl:value-of select="@modifier" />
							)
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@modifier" />
						</xsl:otherwise>
					</xsl:choose>
				</span>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:population">
		<xsl:variable
			name="hasCount"
			select="@count" />
		<xsl:variable
			name="hasBody"
			select="./(*|text())" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />

			<xsl:if test="$hasCount">
				<span class="{local-name(.)}-count">
					<xsl:value-of select="@count" />
				</span>
			</xsl:if>
			<xsl:if test="$hasBody">
				<xsl:if test="$hasCount">
					<xsl:text> </xsl:text>
				</xsl:if>
				<span class="{local-name(.)}-body">
					<xsl:call-template name="t:inline-charseq" />
				</span>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:abilityscore">
		<xsl:param
			name="separator"
			as="xs:string"
			select="', '" />

		<xsl:variable
			name="hasScore"
			select="@score" />
		<xsl:variable
			name="hasMod"
			select="@modifier" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-name">
				<xsl:call-template name="t:inline-charseq" />
			</span>
			<xsl:if test="$hasScore">
				<xsl:text> </xsl:text>
				<span class="{local-name(.)}-score">
					<xsl:value-of select="@score" />
				</span>
			</xsl:if>
			<xsl:if test="$hasMod">
				<xsl:text> </xsl:text>
				<span class="{local-name(.)}-modifier">
					<xsl:choose>
						<xsl:when test="$hasScore">
							(
							<xsl:value-of select="@modifier" />
							)
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@modifier" />
						</xsl:otherwise>
					</xsl:choose>
				</span>
			</xsl:if>
		</span>
		<xsl:if test="following-sibling::*[1][self::rpg:abilityscore]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>