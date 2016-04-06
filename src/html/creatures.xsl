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

	<xsl:template match="rpg:abbrevcreature">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" />
			</div>
			<xsl:apply-templates select="./*[not(self::rpg:creaturename or self::rpg:challengerating)]"/>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<div class="{local-name(.)}-header">
				<xsl:apply-templates select="./rpg:creaturename|./rpg:challengerating" />
			</div>
			<xsl:apply-templates select="./rpg:xpreward" />
			<div class="{local-name(.)}-raceClassLevels">
				<xsl:for-each select="./rpg:race">
					<xsl:apply-templates select="." />
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:for-each select="./rpg:class">
					<xsl:apply-templates select="." >
						<xsl:with-param name="separator" select="'/'"/>
					</xsl:apply-templates>
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
			<xsl:if test="./rpg:aura">
				<xsl:call-template name="trpg:named-container-div">
					<xsl:with-param name="name">
						<xsl:call-template name="gentext">
							<xsl:with-param
									name="key"
									select="'aura'" />
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="contents">
						<xsl:apply-templates select="./rpg:aura">
							<xsl:with-param name="separator" select="', '"/>
						</xsl:apply-templates>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<xsl:apply-templates select="./rpg:defenses | ./rpg:offenses | ./rpg:statistics | ./rpg:statblocksection" />
		</div>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities/rpg:resistance
		| rpg:defensiveabilities/rpg:immunity
		| rpg:defensiveabilities/rpg:dr
		| rpg:defensiveabilities/rpg:defensiveability
		| rpg:creaturesaves/rpg:save
		| rpg:defenses/rpg:weaknesses/rpg:weakness
		| rpg:offenses/rpg:creaturespeeds/rpg:speed
		| rpg:offenses/rpg:specialattacks/rpg:specialattack
		| rpg:slatier/rpg:sla
		| rpg:spelltier/rpg:spell
		| rpg:creaturefeats/rpg:feat
		| rpg:creatureskills/rpg:skill">

		<xsl:variable name="localName" select="local-name(.)"/>
		<xsl:variable name="nsUri" select="namespace-uri(.)"/>
		<xsl:next-match />
		<xsl:if test="following-sibling::*[1][namespace-uri(.) = $nsUri and local-name(.) = $localName]">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="rpg:defensiveabilities">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:call-template name="trpg:gentext-container-span">
				<xsl:with-param name="key" select="local-name(.)"/>
				<xsl:with-param name="contents">
					<xsl:apply-templates select="./rpg:defensiveability" />
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="./rpg:dr">
				<xsl:if test="./rpg:dr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
                <xsl:call-template name="trpg:gentext-container-span">
                    <xsl:with-param name="key" select="'dr'"/>
                    <xsl:with-param name="contents">
                        <xsl:apply-templates select="./rpg:dr" />
                    </xsl:with-param>
                </xsl:call-template>
			</xsl:if>
			<xsl:if test="./rpg:immunity">
				<xsl:if test="./rpg:immunity[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
                <xsl:call-template name="trpg:gentext-container-span">
                    <xsl:with-param name="key" select="'immunity'"/>
                    <xsl:with-param name="contents">
                        <xsl:apply-templates select="./rpg:immunity" />
                    </xsl:with-param>
                </xsl:call-template>
			</xsl:if>
			<xsl:if test="./rpg:resistance">
				<xsl:if test="./rpg:resistance[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
                <xsl:call-template name="trpg:gentext-container-span">
                    <xsl:with-param name="key" select="'resistance'"/>
                    <xsl:with-param name="contents">
                        <xsl:apply-templates select="./rpg:resistance" />
                    </xsl:with-param>
                </xsl:call-template>
			</xsl:if>
			<xsl:if test="./rpg:sr">
				<xsl:if test="./rpg:sr[1]/preceding-sibling::*">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates select="./rpg:sr" />
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="rpg:creaturesaves">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:defenses/rpg:hp | rpg:abbrevcreature/rpg:statblocksection/rpg:hp">
		<xsl:call-template name="trpg:gentext-container-div">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates select="./rpg:hpval" />
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
				<xsl:if test="./rpg:fasthealing | ./rpg:regeneration">
					<xsl:text>; </xsl:text>
					<xsl:for-each select="./rpg:fasthealing | ./rpg:regeneration">
						<xsl:if test="position() != 1">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:apply-templates select="." />
					</xsl:for-each>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:defenses
	| rpg:offenses
	| rpg:creature/rpg:defenses/rpg:weaknesses
	| rpg:offenses/rpg:meleeattacks | rpg:offenses/rpg:rangedattacks
	| rpg:offenses/rpg:creaturespeeds
	| rpg:offenses/rpg:creaturedimensions
	| rpg:offenses/rpg:specialattacks
	| rpg:statistics
	| rpg:statistics/rpg:creaturefeats | rpg:statistics/rpg:creatureskills">
		<xsl:call-template name="trpg:gentext-container-div">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:apply-templates />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:creaturedimensions/rpg:space | rpg:creaturedimensions/rpg:reach">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:next-match />
				<xsl:if test="following-sibling::rpg:*">
					<xsl:text>; </xsl:text>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>


	<xsl:template match="rpg:senses">
		<xsl:call-template name="trpg:gentext-container-span">
            <xsl:with-param name="key" select="local-name(.)"/>
            <xsl:with-param name="contents">
                <xsl:apply-templates select="./rpg:sense">
                    <xsl:with-param name="separator" select="', '"/>
                </xsl:apply-templates>
                <xsl:if test="./rpg:skill">
                    <xsl:if test="count(./rpg:sense) > 0">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="./rpg:skill">
                        <xsl:with-param name="separator" select="', '"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template
		match="rpg:creature/rpg:challengerating | rpg:abbrevcreature/rpg:challengerating
		| rpg:creature/rpg:initiative
		| rpg:attackstatistics/rpg:bab | rpg:attackstatistics/rpg:cmb | rpg:attackstatistics/rpg:cmd">
		<xsl:call-template name="trpg:gentext-container-span">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:next-match />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:creature/rpg:xpreward | rpg:abbrevcreature/rpg:xpreward">
		<xsl:call-template name="trpg:gentext-container-div">
			<xsl:with-param name="key" select="local-name(.)"/>
			<xsl:with-param name="contents">
				<xsl:next-match />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="rpg:creaturetypes">
		<span>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates select="./rpg:creaturetype" />
			<xsl:if test="./rpg:creaturesubtype">
				<xsl:text> (</xsl:text>
				<xsl:apply-templates select="./rpg:creaturesubtype">
					<xsl:with-param name="separator" select="', '"/>
				</xsl:apply-templates>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:slas | rpg:offenses/rpg:spellsprepped">
		<xsl:variable name="titleOverride">
			<xsl:choose>
				<xsl:when test="@title"><xsl:value-of select="@title"/></xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="contents">
			<span class="{local-name(.)}-clConcentration">
				<xsl:text>(</xsl:text>
				<xsl:variable name="clAndCon" select="./rpg:casterlevel and ./rpg:concentration"/>
				<xsl:apply-templates select="./rpg:casterlevel"/>
				<xsl:if test="$clAndCon">
					<xsl:text>; </xsl:text>
				</xsl:if>
				<xsl:apply-templates select="./rpg:concentration"/>
				<xsl:text>)</xsl:text>
			</span>
			<ul class="{local-name(.)}">
				<xsl:apply-templates select="./rpg:slatier | ./rpg:spelltier"/>
			</ul>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$titleOverride != ''">
				<xsl:call-template name="trpg:named-container-div">
					<xsl:with-param name="name" select="$titleOverride"/>
					<xsl:with-param name="contents" select="$contents"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="trpg:gentext-container-div">
					<xsl:with-param name="key" select="local-name(.)"/>
					<xsl:with-param name="contents" select="$contents"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="rpg:offenses/rpg:slas/rpg:slatier | rpg:offenses/rpg:spellsprepped/rpg:spelltier">
		<li>
			<xsl:sequence select="f:html-attributes(.)" />
			<span class="{local-name(.)}-frequency">
				<xsl:value-of select="@frequency | @tiername"/>
			</span>
			<xsl:text> &#x2014; </xsl:text>
			<span class="{local-name(.)}-body">
				<xsl:apply-templates/>
			</span>
		</li>
	</xsl:template>

	<xsl:template match="rpg:statistics/rpg:abilityscores">
		<xsl:next-match>
			<xsl:with-param name="separator" select="', '"/>
		</xsl:next-match>
	</xsl:template>

	<xsl:template match="rpg:statistics/rpg:attackstatistics">
		<div>
			<xsl:sequence select="f:html-attributes(.)" />
			<xsl:apply-templates select="./rpg:bab"/>
			<xsl:for-each select="./rpg:cmb | rpg:cmd">
				<xsl:text>; </xsl:text>
				<xsl:apply-templates select="."/>
			</xsl:for-each>
		</div>
	</xsl:template>
</xsl:stylesheet>