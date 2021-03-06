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
	xmlns:trpg="http://rwdalpe.github.io/docbook/xslt/rpg/extension"

	exclude-result-prefixes="xsl db f rpg h xs t">

	<xsl:template match="rpg:alignment|rpg:location|rpg:settlementtype
		|rpg:government|rpg:settlementquality|rpg:settlementdisadvantage
		|rpg:creaturename | rpg:challengerating | rpg:xpreward
		| rpg:race | rpg:size | rpg:creaturetype | rpg:rating | rpg:hpval
		| rpg:defensiveability | rpg:immunity | rpg:weakness | rpg:damage | rpg:hiteffect
		| rpg:attackname | rpg:sla | rpg:spell | rpg:feat | rpg:language | rpg:sq">

		<xsl:call-template name="t:inline-charseq" />
	</xsl:template>

	<xsl:template match="rpg:attack/rpg:onhit">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:variable name="forXLink">
				<xsl:text>(</xsl:text>
				<xsl:apply-templates />
				<xsl:text>)</xsl:text>
			</xsl:variable>
			<xsl:call-template name="t:xlink">
				<xsl:with-param
					name="content"
					select="$forXLink" />
			</xsl:call-template>
		</span>
	</xsl:template>

	<xsl:template match="rpg:space | rpg:reach">
		<xsl:variable name="forXlink">
			<xsl:call-template name="trpg:no-qualifier-xlink-content" />
		</xsl:variable>
		<xsl:call-template name="t:xlink">
			<xsl:with-param
				name="content"
				select="$forXlink" />
		</xsl:call-template>
		<xsl:if test="./rpg:qualifier">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:qualifier" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:specialattack">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:variable name="forXlink">
				<xsl:call-template name="trpg:no-qualifier-xlink-content" />
			</xsl:variable>
			<xsl:call-template name="t:xlink">
				<xsl:with-param
						name="content"
						select="$forXlink" />
			</xsl:call-template>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:bab | rpg:cmb | rpg:cmd">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-modifier">
				<xsl:variable
						name="mod"
						select="@modifier" />
				<xsl:call-template name="t:xlink">
					<xsl:with-param
							name="content"
							select="string($mod)" />
				</xsl:call-template>
			</span>
			<xsl:for-each select="./rpg:modifierbreakdown | ./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</span>
	</xsl:template>


	<xsl:template match="rpg:attackbonus">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-modifier">
				<xsl:variable
					name="mod"
					select="@modifier" />
				<xsl:call-template name="t:xlink">
					<xsl:with-param
						name="content"
						select="string($mod)" />
				</xsl:call-template>
			</span>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::rpg:attackbonus]">
				<xsl:text>/</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:attack">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:variable
				name="stopAtPosition"
				select="count(./rpg:attackbonus[1]/preceding-sibling::node())" />
			<xsl:variable name="forXlink">
				<xsl:for-each select="./node()[position() lt $stopAtPosition]">
					<xsl:call-template name="trpg:text-or-inline"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:call-template name="t:xlink">
				<xsl:with-param
					name="content"
					select="$forXlink" />
			</xsl:call-template>
			<xsl:for-each select="./rpg:attackbonus | ./rpg:onhit | ./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</span>
	</xsl:template>

	<xsl:template match="rpg:speed">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-body">
				<xsl:variable name="forXlink">
					<xsl:call-template name="trpg:no-qualifier-xlink-content" />
				</xsl:variable>
				<xsl:call-template name="t:xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</span>
			<xsl:if test="@rate">
				<xsl:text> </xsl:text>
				<span class="{local-name(.)}-rate">
					<xsl:value-of select="@rate" />
				</span>
			</xsl:if>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:sr">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents" select="@amount"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:resistance">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-amount">
				<xsl:value-of select="@amount" />
			</span>
			<xsl:text> </xsl:text>
			<span class="{local-name(.)}-body">
				<xsl:variable name="forXlink">
					<xsl:call-template name="trpg:everything-xlink-content"/>
				</xsl:variable>
				<xsl:call-template name="t:xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</span>
		</span>
	</xsl:template>

	<xsl:template match="rpg:dr">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-amount">
				<xsl:value-of select="@amount" />
			</span>
			<span class="{local-name(.)}-body">
				<xsl:text>/</xsl:text>
				<xsl:choose>
					<xsl:when test="./node()">
						<xsl:variable name="forXlink">
							<xsl:call-template name="trpg:everything-xlink-content"/>
						</xsl:variable>
						<xsl:call-template name="t:xlink">
							<xsl:with-param
								name="content"
								select="$forXlink" />
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&#8212;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</span>
		</span>
	</xsl:template>

	<xsl:template match="rpg:save">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-body">
				<xsl:variable name="forXlink">
					<xsl:call-template name="trpg:no-qualifier-xlink-content"/>
				</xsl:variable>
				<xsl:call-template name="t:xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</span>
			<xsl:if test="@modifier">
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
	</xsl:template>

	<xsl:template match="rpg:touch | rpg:flatfoot | rpg:fasthealing | rpg:regeneration">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />

			<xsl:variable name="forXlink">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:apply-templates />
			</xsl:variable>
			<xsl:call-template name="t:xlink">
				<xsl:with-param
					name="content"
					select="$forXlink" />
			</xsl:call-template>
		</span>
	</xsl:template>

	<xsl:template match="rpg:hp">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates select="./rpg:hpval" />
			<xsl:text> </xsl:text>
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:if test="@hdtotal or @expanded">
				<xsl:text> (</xsl:text>
				<xsl:if test="@hdtotal">
					<xsl:value-of select="@hdtotal" />
					<xsl:text> </xsl:text>
					<xsl:call-template name="gentext">
						<xsl:with-param
							name="key"
							select="'hd'" />
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="@hdtotal and @expanded">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:if test="@expanded">
					<xsl:value-of select="@expanded" />
				</xsl:if>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:for-each select="./rpg:fasthealing | ./rpg:regeneration">
				<xsl:choose>
					<xsl:when test="position() != 1">
						<xsl:text>, </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>; </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</span>
	</xsl:template>

	<xsl:template match="rpg:ac">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-title">
				<xsl:call-template name="gentext">
					<xsl:with-param
						name="key"
						select="local-name(.)" />
				</xsl:call-template>
			</span>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="./rpg:rating" />
			<xsl:for-each select="./rpg:touch | ./rpg:flatfoot">
				<xsl:text>, </xsl:text>
				<xsl:apply-templates select="." />
			</xsl:for-each>

			<xsl:variable
				name="body"
				select="./node()[not(self::rpg:modifierbreakdown) and not(self::rpg:rating) and not(self::rpg:touch) and not(self::rpg:flatfoot)]" />

			<xsl:if test="$body">
				<span class="{local-name(.)}-body">
					<xsl:variable name="forXlink">
						<xsl:for-each select="$body">
							<xsl:call-template name="trpg:text-or-inline" />
						</xsl:for-each>
					</xsl:variable>
					<xsl:call-template name="t:xlink">
						<xsl:with-param
							name="content"
							select="$forXlink" />
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</span>
			</xsl:if>

			<xsl:apply-templates select="./rpg:modifierbreakdown">
				<xsl:with-param name="separator" select="', '"/>
			</xsl:apply-templates>
		</span>
	</xsl:template>

	<xsl:template match="rpg:modifierbreakdown">
		<xsl:param
			name="separator"
			as="xs:string"
			select="''" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:text>(</xsl:text>
			<xsl:apply-templates select="./rpg:modifier">
				<xsl:with-param name="separator" select="$separator"/>
			</xsl:apply-templates>
			<xsl:text>)</xsl:text>
		</span>
	</xsl:template>

	<xsl:template match="rpg:modifier">
		<xsl:param
			name="separator"
			as="xs:string"
			select="''" />

		<xsl:variable
			name="body"
			select="./node()[not(self::rpg:qualifier)]" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:if test="$body">
				<span class="{local-name(.)}-body">
					<xsl:variable name="forXlink">
						<xsl:for-each select="$body">
							<xsl:call-template name="trpg:text-or-inline" />
						</xsl:for-each>
					</xsl:variable>
					<xsl:call-template name="t:xlink">
						<xsl:with-param
							name="content"
							select="$forXlink" />
					</xsl:call-template>
					<xsl:text> </xsl:text>
				</span>
			</xsl:if>
			<span class="{local-name(.)}-value">
				<xsl:value-of select="@value" />
			</span>
			<xsl:if test="./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="./rpg:qualifier" />
			</xsl:if>
		</span>
		<xsl:if test="following-sibling::*[1][self::rpg:modifier]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:dc">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents" select="@rating"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:casterlevel">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents" select="@level"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="rpg:aura">
		<xsl:param
			name="separator"
			as="xs:string"
			select="''" />

		<xsl:variable
			name="details"
			select="@range | ./rpg:dc"
			as="node()*" />

		<xsl:variable
			name="context"
			select="." />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-body">
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()[not(self::rpg:dc)]">
						<xsl:call-template name="trpg:text-or-inline" />
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="t:xlink">
					<xsl:with-param
						name="content"
						select="$forXlink" />
				</xsl:call-template>
			</span>
			<xsl:if test="$details">
				<xsl:text> (</xsl:text>
				<xsl:for-each select="$details">
					<xsl:if test="position() > 1">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<span class="{local-name($context)}-{local-name(.)}">
						<xsl:choose>
							<xsl:when test="self::element()">
								<xsl:apply-templates select="." />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="." />
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
		<xsl:if test="following-sibling::*[1][self::rpg:aura]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:skill">
		<xsl:param
			name="separator"
			as="xs:string"
			select="''" />

		<xsl:variable
			name="hasModifier"
			select="@modifier" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-body">
				<xsl:variable name="forXlink">
					<xsl:for-each select="./node()[not(self::rpg:qualifier) and not(self::rpg:modifierbreakdown)]">
						<xsl:call-template name="trpg:text-or-inline" />
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
			<xsl:for-each select="./rpg:modifierbreakdown | ./rpg:qualifier">
				<xsl:text> </xsl:text>
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</span>
		<xsl:if test="following-sibling::*[1][self::rpg:skill]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:concentration">
		<xsl:param
				name="separator"
				as="xs:string"
				select="''" />

		<xsl:variable
				name="hasModifier"
				select="@modifier" />

		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-body">
				<xsl:variable name="forXlink">
					<xsl:call-template name="gentext">
						<xsl:with-param
								name="key"
								select="local-name(.)" />
					</xsl:call-template>
					<xsl:call-template name="trpg:no-qualifier-xlink-content" />
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
		<xsl:if test="following-sibling::*[1][self::rpg:skill]">
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
			select="''" />

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
			select="''" />

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
			select="''" />
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
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
			select="''" />

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
		<xsl:if test="following-sibling::*[1][self::rpg:abilityscore]">
			<xsl:value-of select="$separator" />
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>