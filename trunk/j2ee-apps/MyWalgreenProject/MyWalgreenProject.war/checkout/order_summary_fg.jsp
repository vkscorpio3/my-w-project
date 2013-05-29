<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@page import="atg.servlet.DynamoHttpServletRequest"%>
<%@page import="atg.servlet.ServletUtil"%>
<%@page import="com.tool.SearchDBManager"%>

<%@page import="com.tool.EmailSenderManager"%>
<%@page import="com.bean.OrderBean"%>
<%@page import="com.helper.HtmlEmailSender"%><dsp:importbean
	bean="/atg/droplet/GroupItemsDroplet" />
<dsp:page>
<dsp:importbean bean="atg/tool/SearchDBManager" />
<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
<dsp:importbean bean="atg/droplet/HtmlEmailSenderDroplet" />
	<title>Review Order</title>
	<head>
	<style>
div.leftNav1 {
	position: absolute;
	left: 50px;
	top: 200px;
	width: 700px
}
div.rightNav1 {
	position: absolute;
	left: 800px;
	top: 10px;
	width: 400px
}

div.rightNav2 {
	position: absolute;
	left: 800px;
	top: 150px;
	width: 400px
}
div.rightNav3 {
	position: absolute;
	left: 800px;
	top: 340px;
	width: 400px
}
</style>
	</head>
	
	<p><dsp:form action="">
		<div class="leftNav1">
			<dsp:include page="prod_display_fg.jsp"/>
		</div>
		<div class="rightNav1">
			<dsp:include page="item_price_fg.jsp"/>
			
		</div>
		<div class="rightNav2">
			<dsp:include page="shipping_fg.jsp"/>
		</div>
		<div class="rightNav3"><dsp:include page="billing_fg.jsp"/></div>
		<p>&nbsp;<br>
	</dsp:form>
</dsp:page>
