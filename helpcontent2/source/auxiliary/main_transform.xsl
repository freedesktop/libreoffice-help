<?xml version="1.0" encoding="UTF-8"?>

<!-- 
              =========================
                  DEBUG VERSION ONLY
							=========================
 
//-->

<!--***********************************************************************
  This is the main transformation style sheet for transforming.
  Only use with OOo 2.0
  Owner: fpe@openoffice.org
  =========================================================================
  Changes Log
    May 24 2004 Created
    Aug 24 2004 Fixed for help2 CWS
    Aug 27 2004 Added css link, fixed missing embed-mode for variable
                Removed width/height for images
		Sep 03 2004 Modularized xsl, added some embedded modes
		Oct 08 2004 Fixed bug wrong mode "embedded" for links
		            Added embedded modes for embed and embedvar (for cascaded embeds)
								Added <p> tags around falsely embedded pars and vars
***********************************************************************//-->

<!--***********************************************************************

 *
 *  The Contents of this file are made available subject to the terms of
 *  either of the following licenses
 *
 *         - GNU Lesser General Public License Version 2.1
 *         - Sun Industry Standards Source License Version 1.1
 *
 *  Sun Microsystems Inc., October, 2000
 *
 *  GNU Lesser General Public License Version 2.1
 *  =============================================
 *  Copyright 2000 by Sun Microsystems, Inc.
 *  901 San Antonio Road, Palo Alto, CA 94303, USA
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License version 2.1, as published by the Free Software Foundation.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 *  MA  02111-1307  USA
 *
 *
 *  Sun Industry Standards Source License Version 1.1
 *  =================================================
 *  The contents of this file are subject to the Sun Industry Standards
 *  Source License Version 1.1 (the "License"); You may not use this file
 *  except in compliance with the License. You may obtain a copy of the
 *  License at http://www.openoffice.org/license.html.
 *
 *  Software provided under this License is provided on an "AS IS" basis,
 *  WITHOUT WARRUNTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING,
 *  WITHOUT LIMITATION, WARRUNTIES THAT THE SOFTWARE IS FREE OF DEFECTS,
 *  MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE, OR NON-INFRINGING.
 *  See the License for the specific provisions governing your rights and
 *  obligations concerning the Software.
 *
 *  The Initial Developer of the Original Code is: Sun Microsystems, Inc..
 *
 *  Copyright: 2000 by Sun Microsystems, Inc.
 *
 *  All Rights Reserved.
 *
 *  Contributor(s): _______________________________________
 *
 *
 ************************************************************************-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output indent="yes" method="html"/>

<!--
############################
# Variables and Parameters #
############################
//-->

<!-- General Usage -->
<xsl:variable name="am" select="'&amp;'"/>
<xsl:variable name="sl" select="'/'"/>
<xsl:variable name="qt" select="'&quot;'"/>

<!-- generic Icon alt text -->
<xsl:variable name="alttext" select="'text/shared/00/icon_alt.xhp'"/>

<!-- For calculating pixel sizes -->
<xsl:variable name="dpi" select="'96'"/>
<xsl:variable name="dpcm" select="'38'"/>

<!-- Product brand variables used in the help files -->
<xsl:variable name="brand1" select="'$[officename]'"/>
<xsl:variable name="brand2" select="'$[officeversion]'"/>
<xsl:variable name="brand3" select="'%PRODUCTNAME'"/>
<xsl:variable name="brand4" select="'%PRODUCTVERSION'"/>

<!-- meta data variables from the help file -->
<xsl:variable name="filename" select="/helpdocument/meta/topic/filename"/>
<xsl:variable name="topic_id" select="/helpdocument/meta/topic/@id"/>
<xsl:variable name="topic_status" select="/helpdocument/meta/topic/@status"/>
<xsl:variable name="title" select="/helpdocument/meta/topic/title"/>
<xsl:variable name="lang" select="/helpdocument/meta/topic/title/@xml-lang"/>

<!-- Module and the corresponding switching values-->
<xsl:param name="module" select="'swriter'"/>
<xsl:variable name="appl">
	<xsl:choose>
		<xsl:when test="$module = 'swriter'"><xsl:value-of select="'WRITER'"/></xsl:when>
		<xsl:when test="$module = 'scalc'"><xsl:value-of select="'CALC'"/></xsl:when>
		<xsl:when test="$module = 'sdraw'"><xsl:value-of select="'DRAW'"/></xsl:when>
		<xsl:when test="$module = 'simpress'"><xsl:value-of select="'IMPRESS'"/></xsl:when>
		<xsl:when test="$module = 'schart'"><xsl:value-of select="'CHART'"/></xsl:when>
		<xsl:when test="$module = 'sbasic'"><xsl:value-of select="'BASIC'"/></xsl:when>
		<xsl:when test="$module = 'smath'"><xsl:value-of select="'MATH'"/></xsl:when>
	</xsl:choose>
</xsl:variable>

<!-- the other parameters given by the help caller -->
<xsl:param name="System" select="'WIN'"/>
<xsl:param name="productname" select="'Office'"/>
<xsl:param name="productversion" select="''"/>
<!-- this is were the images are -->
<xsl:param name="imgrepos" select="''"/>
<xsl:param name="Id" />
<!-- (lame) distinction between OS and Commercial -->
<xsl:param name="distrib">
	<xsl:choose>
		<xsl:when test="starts-with($productname,'OpenOffice')">
			<xsl:value-of select="'OPENSOURCE'"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'COMMERCIAL'"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:param>

<!-- parts of help and image urls -->

 
<xsl:variable name="help_url_prefix" select="'vnd.sun.star.help://'"/>
<xsl:variable name="img_url_prefix" select="concat('vnd.sun.star.pkg://',$imgrepos,'/')"/>
<xsl:variable name="urlpost" select="concat('?Language=',$lang,$am,'System=',$System,$am,'UseDB=no')"/>
<xsl:variable name="urlpre" select="$help_url_prefix" /> 
<xsl:variable name="linkprefix" select="$urlpre"/>
<xsl:variable name="linkpostfix" select="$urlpost"/>

<!-- DEBUG:
<xsl:variable name="help_url_prefix" select="'file:///opt/staroffice8-cwshelp2/help/en'"/>
<xsl:variable name="img_url_prefix" select="''"/>
<xsl:variable name="urlpost" select="''"/>
<xsl:variable name="urlpre" select="$help_url_prefix" /> 
<xsl:variable name="linkprefix" select="$urlpre"/>
<xsl:variable name="linkpostfix" select="$urlpost"/>
//-->

<xsl:variable name="css" select="'default.css'"/>

<!-- images for notes, tips and warnings -->
<xsl:variable name="note_img" select="concat($img_url_prefix,'res/helpimg/note.png')"/>
<xsl:variable name="tip_img" select="concat($img_url_prefix,'res/helpimg/tip.png')"/>
<xsl:variable name="warning_img" select="concat($img_url_prefix,'res/helpimg/warning.png')"/>

<!--
#############
# Templates #
#############
//-->

<!-- Create the document skeleton -->
<xsl:template match="/">
	<xsl:variable name="csslink" select="concat($urlpre,'/',$urlpost)"/>
	<html>
		<head>
			<title><xsl:value-of select="$title"/></title>
			<link href="{$csslink}" rel="Stylesheet" type="text/css" /> <!-- stylesheet link -->
  		<meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
		</head>
		<body lang="{$lang}">
			<!-- DEBUG ME START	
			<xsl:variable name="srcname"><xsl:value-of select="concat('file:///k:/WORKBENCH/helpcontent2/source',$filename)"/></xsl:variable>
			<div class="debug">
				<p class="{/helpdocument/meta/topic/@status}">
				<xsl:if test="/helpdocument/meta/topic[@indexer='exclude']">NOT INDEXED - </xsl:if>
				<a href="{$srcname}"><xsl:value-of select="$filename"/></a></p>
				<p><xsl:value-of select="count(//embed)"/> embedded sections<br/>
				<xsl:value-of select="count(//embedvar)"/> embedded variables<br/>
				<xsl:value-of select="count(//image)"/> images<br/>
				<xsl:value-of select="count(//link)"/> links</p>
			</div>
			DEBUG ME END	
			//-->
			<xsl:apply-templates select="/helpdocument/body"/>
		</body>
	</html>
</xsl:template>

<!-- AHELP -->
<xsl:template match="ahelp">
	<xsl:if test="not(@visibility='hidden')"><span class="avis"><xsl:apply-templates /></span></xsl:if>
</xsl:template>

<!-- ALT -->
<xsl:template match="alt"/>

<!-- BOOKMARK -->
<xsl:template match="bookmark">
	<a name="{@id}"></a>
	<xsl:choose>
		<xsl:when test="starts-with(@branch,'hid')" />
		<xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="bookmark" mode="embedded" />

<!-- BOOKMARK_VALUE -->
<xsl:template match="bookmark_value" />

<!-- BR -->
<xsl:template match="br"><br /></xsl:template>

<!-- CAPTION -->
<xsl:template match="caption" />

<!-- CASE -->
<xsl:template match="case"><xsl:call-template name="insertcase" /></xsl:template>
<xsl:template match="case" mode="embedded">
	<xsl:call-template name="insertcase">
		<xsl:with-param name="embedded" select="'yes'"/>
	</xsl:call-template>
</xsl:template>

<!-- CASEINLINE -->
<xsl:template match="caseinline"><xsl:call-template name="insertcase" /></xsl:template>
<xsl:template match="caseinline" mode="embedded">
	<xsl:call-template name="insertcase">
		<xsl:with-param name="embedded" select="'yes'"/>
	</xsl:call-template>
</xsl:template>

<!-- COMMENT -->
<xsl:template match="comment" />
<xsl:template match="comment" mode="embedded"/>

<!-- CREATED -->
<xsl:template match="created" />

<!-- DEFAULT -->
<xsl:template match="default"><xsl:call-template name="insertdefault" /></xsl:template>
<xsl:template match="default" mode="embedded">
	<xsl:call-template name="insertdefault">
		<xsl:with-param name="embedded" select="'yes'"/>
	</xsl:call-template>
</xsl:template>

<!-- DEFAULTINLINE -->
<xsl:template match="defaultinline"><xsl:call-template name="insertdefault" /></xsl:template>
<xsl:template match="defaultinline" mode="embedded">
	<xsl:call-template name="insertdefault">
		<xsl:with-param name="embedded" select="'yes'"/>
	</xsl:call-template>
</xsl:template>

<!-- EMBED -->
<xsl:template match="embed"><xsl:call-template name="resolveembed"/></xsl:template>
<xsl:template match="embed" mode="embedded"><xsl:call-template name="resolveembed"/></xsl:template>

<!-- EMBEDVAR -->
<xsl:template match="embedvar"><xsl:call-template name="resolveembedvar"/></xsl:template>
<xsl:template match="embedvar" mode="embedded"><xsl:call-template name="resolveembedvar"/></xsl:template>

<!-- EMPH -->
<xsl:template match="emph">
	<span class="emph"><xsl:apply-templates /></span>
</xsl:template>
<xsl:template match="emph" mode="embedded">
	<span class="emph"><xsl:apply-templates /></span>
</xsl:template>

<!-- FILENAME -->
<xsl:template match="filename" />

<!-- HISTORY -->
<xsl:template match="history" />

<!-- IMAGE -->
<xsl:template match="image"><xsl:call-template name="insertimage"/></xsl:template>
<xsl:template match="image" mode="embedded"><xsl:call-template name="insertimage"/></xsl:template>

<!-- ITEM -->
<xsl:template match="item"><span class="{@type}"><xsl:apply-templates /></span></xsl:template>
<xsl:template match="item" mode="embedded"><span class="{@type}"><xsl:apply-templates /></span></xsl:template>

<!-- LASTEDITED -->
<xsl:template match="lastedited" />

<!-- LINK -->
<xsl:template match="link">
	<xsl:choose> <!-- don't insert the heading link to itself -->
		<xsl:when test="(concat('/',@href) = /helpdocument/meta/topic/filename) or (@href = /helpdocument/meta/topic/filename)">
			<xsl:apply-templates />
		</xsl:when>
		<xsl:when test="contains(child::embedvar/@href,'/00/00000004.xhp#wie')"> <!-- special treatment of howtoget links -->
			<xsl:call-template name="insert_howtoget">
				<xsl:with-param name="linkhref" select="@href"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="createlink" /> 
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<xsl:template match="link" mode="embedded">
	<xsl:call-template name="createlink"/>
</xsl:template>

<!-- LIST -->
<xsl:template match="list">
	<xsl:choose>
		<xsl:when test="@type='ordered'">
			<ol>
				<xsl:if test="@startwith">
					<xsl:attribute name="start"><xsl:value-of select="@startwith"/></xsl:attribute>
				</xsl:if>
				<xsl:apply-templates />
			</ol>
		</xsl:when>
		<xsl:otherwise>
			<ul><xsl:apply-templates /></ul>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- LISTITEM -->
<xsl:template match="listitem">
	<li><xsl:apply-templates /></li>
</xsl:template>

<!-- META, SEE HEADER -->
<xsl:template match="meta" />

<!-- OBJECT (UNUSED) -->
<xsl:template match="object" />

<!-- PARAGRAPH -->
<xsl:template match="paragraph">
	<xsl:choose>
		
		<xsl:when test="@role='heading'">
			<xsl:call-template name="insertheading">
				<xsl:with-param name="level" select="@level"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains(' note warning tip ',@role)">
			<xsl:call-template name="insertnote">
				<xsl:with-param name="type" select="@role" />
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains(descendant::embedvar/@href,'/00/00000004.xhp#wie')"> <!-- special treatment of howtoget links -->
			<xsl:apply-templates />
		</xsl:when>		
		
		<xsl:otherwise>
			<xsl:call-template name="insertpara" />
		</xsl:otherwise>
	
	</xsl:choose>
</xsl:template>

<xsl:template match="paragraph" mode="embedded">
		<xsl:choose>
		
		<xsl:when test="@role='heading'">	<!-- increase the level of headings that are embedded -->
		<!-- 
		   The internal sablotron processor does not seem to support the number function.
			 Therefore, we need a workaround for
			 <xsl:variable name="level"><xsl:value-of select="number(@level)+1"/></xsl:variable>
		-->
			<xsl:variable name="newlevel">
				<xsl:choose>
					<xsl:when test="@level='1'"><xsl:value-of select="'2'"/></xsl:when>
					<xsl:when test="@level='2'"><xsl:value-of select="'2'"/></xsl:when>
					<xsl:when test="@level='3'"><xsl:value-of select="'3'"/></xsl:when>
					<xsl:when test="@level='4'"><xsl:value-of select="'4'"/></xsl:when>
					<xsl:when test="@level='5'"><xsl:value-of select="'5'"/></xsl:when>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:call-template name="insertheading">
				<xsl:with-param name="level" select="$newlevel"/>
				<xsl:with-param name="embedded" select="'yes'"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains(' note warning tip ',@role)">
			<xsl:call-template name="insertnote">
				<xsl:with-param name="type" select="@role" />
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains(descendant::embedvar/@href,'/00/00000004.xhp#wie')"> <!-- special treatment of howtoget links -->
			<xsl:apply-templates />
		</xsl:when>		
		
		<xsl:otherwise>
			<xsl:call-template name="insertpara" />
		</xsl:otherwise>
		
	</xsl:choose>
</xsl:template>


<!-- SECTION -->
<xsl:template match="section">
	<a name="{@id}"></a>

		<xsl:choose>
			
			<xsl:when test="@id='relatedtopics'">
				<div class="relatedtopics">
					<xsl:variable name="href"><xsl:value-of select="concat($urlpre,'shared/text/shared/00/00000004.xhp',$urlpost)"/></xsl:variable>
					<xsl:variable name="anchor"><xsl:value-of select="'related'"/></xsl:variable>
					<xsl:variable name="doc" select="document($href)"/>
					<p class="related">
						<xsl:apply-templates select="$doc//variable[@id=$anchor]"/>
					</p>
					<div class="relatedbody">
						<xsl:apply-templates />
					</div>
				</div>
			</xsl:when>
			
			<xsl:when test="@id='howtoget'">
				<xsl:call-template name="insert_howtoget" />
			</xsl:when>
			
			<xsl:otherwise>
						<xsl:apply-templates/>
			</xsl:otherwise>
		
		</xsl:choose>

</xsl:template>


<!-- SECTION -->
<xsl:template match="section" mode="embedded">
	<a name="{@id}"></a>
	<xsl:apply-templates mode="embedded"/>
</xsl:template>

<!-- SORT -->
<xsl:template match="sort" >
	<xsl:apply-templates><xsl:sort select="descendant::paragraph"/></xsl:apply-templates>
</xsl:template>
<xsl:template match="sort" mode="embedded">
	<xsl:apply-templates><xsl:sort select="descendant::paragraph"/></xsl:apply-templates>
</xsl:template>

<!-- SWITCH -->
<xsl:template match="switch"><xsl:apply-templates /></xsl:template>
<xsl:template match="switch" mode="embedded"><xsl:apply-templates /></xsl:template>

<!-- SWITCHINLINE -->
<xsl:template match="switchinline"><xsl:apply-templates /></xsl:template>
<xsl:template match="switchinline" mode="embedded"><xsl:apply-templates mode="embedded"/></xsl:template>

<!-- TABLE -->
<xsl:template match="table"><xsl:call-template name="inserttable"/></xsl:template>
<xsl:template match="table" mode="embedded"><xsl:call-template name="inserttable"/></xsl:template>

<!-- TABLECELL -->
<xsl:template match="tablecell"><td valign="top"><xsl:apply-templates /></td></xsl:template>
<xsl:template match="tablecell" mode="icontable"><td valign="top"><xsl:apply-templates/></td></xsl:template>
<xsl:template match="tablecell" mode="embedded"><td valign="top"><xsl:apply-templates mode="embedded"/></td></xsl:template>

<!-- TABLEROW -->
<xsl:template match="tablerow"><tr><xsl:apply-templates /></tr></xsl:template>
<xsl:template match="tablerow" mode="icontable"><tr><xsl:apply-templates mode="icontable"/></tr></xsl:template>
<xsl:template match="tablerow" mode="embedded"><tr><xsl:apply-templates mode="embedded"/></tr></xsl:template>

<!-- TITLE -->
<xsl:template match="title"/>

<!-- TOPIC -->
<xsl:template match="topic"/>

<!-- VARIABLE -->
<xsl:template match="variable"><a name="{@id}"></a><xsl:apply-templates /></xsl:template>
<xsl:template match="variable" mode="embedded"><a name="{@id}"></a><xsl:apply-templates mode="embedded"/></xsl:template>

<xsl:template match="text()">
	<xsl:call-template name="brand">
		<xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template match="text()" mode="embedded">
	<xsl:call-template name="brand">
		<xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<!-- In case of missing help files -->
<xsl:template match="help-id-missing"><xsl:value-of select="$Id"/></xsl:template>

<!-- 
###################
# NAMED TEMPLATES #
###################
//-->

<!-- Branding -->
<xsl:template name="brand" >
	<xsl:param name="string"/>
	<xsl:choose>
		<xsl:when test="contains($string,$brand1)">
			<xsl:value-of select="substring-before($string,$brand1)"/>
			<xsl:value-of select="$productname"/>
			<xsl:call-template name="brand">
				<xsl:with-param name="string" select="substring-after($string,$brand1)"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="contains($string,$brand2)">
			<xsl:value-of select="substring-before($string,$brand2)"/>
			<xsl:value-of select="$productversion"/>
			<xsl:call-template name="brand">
				<xsl:with-param name="string" select="substring-after($string,$brand2)"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="contains($string,$brand3)">
			<xsl:value-of select="substring-before($string,$brand3)"/>
			<xsl:value-of select="$productname"/>
			<xsl:call-template name="brand">
				<xsl:with-param name="string" select="substring-after($string,$brand3)"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="contains($string,$brand4)">
			<xsl:value-of select="substring-before($string,$brand4)"/>
			<xsl:value-of select="$productversion"/>
			<xsl:call-template name="brand">
				<xsl:with-param name="string" select="substring-after($string,$brand4)"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- Insert Paragraph -->
<xsl:template name="insertpara">
	<xsl:variable name="role">
		<xsl:choose>
			<xsl:when test="ancestor::table">
				<xsl:value-of select="concat(@role,'intable')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@role"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<p class="{$role}"><xsl:apply-templates /></p>
</xsl:template>

<!-- Insert "How to get Link" -->
<xsl:template name="insert_howtoget">
	<xsl:param name="linkhref" />
	<xsl:variable name="archive" select="'shared'"/>
	<xsl:variable name="tmp_href"><xsl:value-of select="concat($urlpre,'shared/text/shared/00/00000004.xhp',$urlpost)"/></xsl:variable>	
	<xsl:variable name="tmp_doc" select="document($tmp_href)"/>
	<table class="howtoget" width="100%" border="1" cellpadding="3" cellspacing="0">
		<tr>
			<td>
				<p class="howtogetheader"><xsl:apply-templates select="$tmp_doc//variable[@id='wie']"/></p>
				<div class="howtogetbody">
				<xsl:choose>
					<xsl:when test="$linkhref = ''"> <!-- new style -->
						<xsl:apply-templates/>
					</xsl:when>
					<xsl:otherwise> <!-- old style -->
						<xsl:variable name="archive1"><xsl:value-of select="concat(substring-before(substring-after($linkhref,'text/'),'/'),'/')"/></xsl:variable>
						<xsl:variable name="href"><xsl:value-of select="concat($urlpre,$archive1,substring-before($linkhref,'#'),$urlpost)"/></xsl:variable>
						<xsl:variable name="anc"><xsl:value-of select="substring-after($linkhref,'#')"/></xsl:variable>
						<xsl:variable name="docum" select="document($href)"/>
						
						<xsl:call-template name="insertembed">
							<xsl:with-param name="doc" select="$docum" />
							<xsl:with-param name="anchor" select="$anc" />
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>				
				</div>
			</td>
		</tr>
	</table>
	<br/>
</xsl:template>

<!-- Create a link -->
<xsl:template name="createlink">
<xsl:variable name="archive"><xsl:value-of select="concat(substring-before(substring-after(@href,'text/'),'/'),'/')"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="contains(@href,'#')">
			<xsl:variable name="anchor"><xsl:value-of select="concat('#',substring-after(@href,'#'))"/></xsl:variable>
			<xsl:variable name="href"><xsl:value-of select="concat($linkprefix,$archive,substring-before(@href,'#'),$linkpostfix,$anchor)"/></xsl:variable>
			<a href="{$href}"><xsl:apply-templates /></a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="href"><xsl:value-of select="concat($linkprefix,$archive,@href,$linkpostfix)"/></xsl:variable>
			<a href="{$href}"><xsl:apply-templates /></a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Insert Note, Warning, or Tip -->
<xsl:template name="insertnote">
	<xsl:param name="type" /> <!-- note, tip, or warning -->
	<xsl:variable name="imgsrc">
		<xsl:choose>
			<xsl:when test="$type='note'"><xsl:value-of select="$note_img"/></xsl:when>
			<xsl:when test="$type='tip'"><xsl:value-of select="$tip_img"/></xsl:when>
			<xsl:when test="$type='warning'"><xsl:value-of select="$warning_img"/></xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="alt">
		<xsl:variable name="href"><xsl:value-of select="concat($urlpre,'shared/',$alttext,$urlpost)"/></xsl:variable>
		<xsl:variable name="anchor"><xsl:value-of select="concat('alt_',$type)"/></xsl:variable>
		<xsl:variable name="doc" select="document($href)"/>
		<xsl:apply-templates select="$doc//variable[@id=$anchor]" mode="embedded"/>
	</xsl:variable>
	<div class="{$type}">
		<table border="0" class="{$type}" cellspacing="0" cellpadding="5">
			<tr>
				<td><img src="{$imgsrc}" alt="{$alt}" title="{$alt}"/></td>
				<td><xsl:apply-templates /></td>
			</tr>
		</table>
	</div>
	<br/>
</xsl:template>

<!-- Insert a heading -->
<xsl:template name="insertheading">
	<xsl:param name="level" />
	<xsl:param name="embedded" />
	<xsl:text disable-output-escaping="yes">&lt;h</xsl:text><xsl:value-of select="$level"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<xsl:choose>
			<xsl:when test="$embedded = 'yes'">
				<xsl:apply-templates mode="embedded"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	<xsl:text disable-output-escaping="yes">&lt;/h</xsl:text><xsl:value-of select="$level"/><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
</xsl:template>

<!-- Evaluate a case or caseinline switch -->
<xsl:template name="insertcase">
	<xsl:param name="embedded" />
	<xsl:choose>
		<xsl:when test="parent::switch[@select='sys'] or parent::switchinline[@select='sys']">
			<xsl:if test="@select = $System">
				<xsl:choose>
					<xsl:when test="$embedded = 'yes'">
						<xsl:apply-templates mode="embedded"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:when>
		<xsl:when test="parent::switch[@select='appl'] or parent::switchinline[@select='appl']">
			<xsl:if test="@select = $appl">
				<xsl:choose>
					<xsl:when test="$embedded = 'yes'">
						<xsl:apply-templates mode="embedded"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:when>
		<xsl:when test="parent::switch[@select='distrib'] or parent::switchinline[@select='distrib']">
			<xsl:if test="@select = $distrib">
				<xsl:choose>
					<xsl:when test="$embedded = 'yes'">
						<xsl:apply-templates mode="embedded"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- Evaluate a default or defaultinline switch -->
<xsl:template name="insertdefault">
	<xsl:param name="embedded" />
	
	<xsl:choose>
		<xsl:when test="parent::switch[@select='sys'] or parent::switchinline[@select='sys']">
			<xsl:if test="not(../child::case[@select=$System]) and not(../child::caseinline[@select=$System])">
				<xsl:choose>
					<xsl:when test="$embedded = 'yes'">
						<xsl:apply-templates mode="embedded"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:when>
		<xsl:when test="parent::switch[@select='appl'] or parent::switchinline[@select='appl']">
			<xsl:if test="not(../child::case[@select=$appl]) and not(../child::caseinline[@select=$appl])">
				<xsl:choose>
					<xsl:when test="$embedded = 'yes'">
						<xsl:apply-templates mode="embedded"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:when>
		<xsl:when test="parent::switch[@select='distrib'] or parent::switchinline[@select='distrib']">
			<xsl:if test="not(../child::case[@select=$distrib]) and not(../child::caseinline[@select=$distrib])">
				<xsl:choose>
					<xsl:when test="$embedded = 'yes'">
						<xsl:apply-templates mode="embedded"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- evaluate embeds -->
<xsl:template name="insertembed">
	<xsl:param name="doc" />
	<xsl:param name="anchor" />
	<!-- different embed targets (also falsely used embed instead embedvar) -->
	<xsl:choose>
		<xsl:when test="$doc//section[@id=$anchor]"> <!-- first test for a section of that name -->
			<xsl:apply-templates select="$doc//section[@id=$anchor]" mode="embedded"/>
		</xsl:when>
		<xsl:when test="$doc//paragraph[@id=$anchor]"> <!-- then test for a para of that name -->
			<p class="embedded">
				<xsl:apply-templates select="$doc//paragraph[@id=$anchor]" mode="embedded"/>
			</p>
		</xsl:when>
		<xsl:when test="$doc//variable[@id=$anchor]"> <!-- then test for a variable of that name -->
			<p class="embedded">
				<xsl:apply-templates select="$doc//variable[@id=$anchor]" mode="embedded"/>
			</p>
		</xsl:when>
		<xsl:otherwise> <!-- then give up -->
			<p class="bug">D'oh! You found a bug (<xsl:value-of select="@href"/> not found).</p> 
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Insert an image -->
<xsl:template name="insertimage">
	<xsl:variable name="src"><xsl:value-of select="concat($img_url_prefix,@src)"/></xsl:variable>
	<xsl:variable name="alt"><xsl:value-of select="./alt"/></xsl:variable>
	<xsl:variable name="width" select="''"/> <!-- Images don't all have the correct size -->
	<xsl:variable name="height" select="''"/><!-- Image don't all have the correct size -->
	<img src="{$src}" alt="{$alt}" title="{$alt}">
		<xsl:if test="not($width='')"><xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute></xsl:if>
		<xsl:if test="not($height='')"><xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute></xsl:if>
	</img>  
</xsl:template>

<!-- Insert a Table -->
<xsl:template name="inserttable">
	<xsl:variable name="imgsrc">	<!-- see if we are in an image table -->
		<xsl:value-of select="tablerow/tablecell[1]/paragraph[1]/image/@src"/>
	</xsl:variable>
	
	<xsl:choose>
		
		<xsl:when test="count(descendant::tablecell)=1">
			<table border="0" class="onecell" cellpadding="0" cellspacing="0">
				<xsl:apply-templates />
		 </table>
		</xsl:when>
		
		<xsl:when test="descendant::tablecell[1]/descendant::image">
			<table border="0" class="icontable" cellpadding="5" cellspacing="0">
				<xsl:apply-templates mode="icontable"/>
		 </table>
		</xsl:when>
		
		<xsl:when test="@class='wide'">
			<table border="1" class="{@class}" cellpadding="0" cellspacing="0" width="100%" >
				<xsl:apply-templates />
		 </table>
		</xsl:when>
		
		<xsl:when test="not(@class='')">
			<table border="1" class="{@class}" cellpadding="0" cellspacing="0" >
				<xsl:apply-templates />
		 </table>
		</xsl:when>
		
		<xsl:otherwise>
			<table border="1" class="border" cellpadding="0" cellspacing="0" >
				<xsl:apply-templates />
		 </table>
		</xsl:otherwise>
	</xsl:choose>
	
	<br/>
</xsl:template>

<xsl:template name="resolveembed">
	<div class="embedded">
		<xsl:variable name="archive"><xsl:value-of select="concat(substring-before(substring-after(@href,'text/'),'/'),'/')"/></xsl:variable>
		<xsl:variable name="href"><xsl:value-of select="concat($urlpre,$archive,substring-before(@href,'#'),$urlpost)"/></xsl:variable>
		<xsl:variable name="anc"><xsl:value-of select="substring-after(@href,'#')"/></xsl:variable>
		<xsl:variable name="docum" select="document($href)"/>
		
		<xsl:call-template name="insertembed">
			<xsl:with-param name="doc" select="$docum" />
			<xsl:with-param name="anchor" select="$anc" />
		</xsl:call-template>

	</div>
</xsl:template>

<xsl:template name="resolveembedvar">
	<xsl:if test="not(@href='text/shared/00/00000004.xhp#wie')"> <!-- special treatment if howtoget links -->
		<xsl:variable name="archive"><xsl:value-of select="concat(substring-before(substring-after(@href,'text/'),'/'),'/')"/></xsl:variable>
		<xsl:variable name="href"><xsl:value-of select="concat($urlpre,$archive,substring-before(@href,'#'),$urlpost)"/></xsl:variable>
		<xsl:variable name="anchor"><xsl:value-of select="substring-after(@href,'#')"/></xsl:variable>
		<xsl:variable name="doc" select="document($href)"/>
		<xsl:choose>
			<xsl:when test="$doc//variable[@id=$anchor]"> <!-- test for a variable of that name -->
				<xsl:apply-templates select="$doc//variable[@id=$anchor]" mode="embedded"/>
			</xsl:when>
			<xsl:otherwise> <!-- or give up -->
				<span class="bug">[<xsl:value-of select="@href"/> not found].</span> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

<!-- Apply -->
<xsl:template name="apply">
	<xsl:param name="embedded" />
	<xsl:choose>
		<xsl:when test="$embedded = 'yes'">
			<xsl:apply-templates mode="embedded"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
