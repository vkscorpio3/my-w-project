<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

	<DECLAREPARAM NAME="pagetitle" CLASS="java.lang.String"
		DESCRIPTION="The text to display as page title.  If not set, then
              defaults to Streb Auto Supply"
		OPTIONAL>

	<HTML>

	<HEAD>
	<TITLE>Motorprise - <dsp:valueof param="pagetitle" /></TITLE>
	<LINK REL=STYLESHEET TYPE="text/css"
		HREF="<%=request.getContextPath()%>/en/common/Style.css"
		TITLE="B2B Demo Stylesheet">
	</HEAD>

	<BODY>
</dsp:page>
<%-- @version $Id: //product/B2BCommerce/version/9.0/release/MotorpriseJSP/j2ee-apps/motorprise/web-app/en/common/HeadBody.jsp#1 $$Change: 508164 $--%>
