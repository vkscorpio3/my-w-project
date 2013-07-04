<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page import="atg.servlet.*"%>
<dsp:page>

	<dsp:importbean bean="/atg/dynamo/Configuration" />
	<dsp:importbean bean="/atg/formhandler/LoginFormHandler" />
	<head>
	<title>MyWalgreenProject JSP Index Page</title>
	</head>
	<h1>MyWalgreenProject Test JSP Page</h1>

	<dsp:form action="index.jsp">

		<dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
			<dsp:param name="exceptions" bean="LoginFormHandler.formExceptions" />
			<dsp:oparam name="output">
				<b> <dsp:valueof param="message" /> </b>
				<p>
			</dsp:oparam>
		</dsp:droplet>
		
		<dsp:input bean="LoginFormHandler.checked" type="checkbox">Check Me</dsp:input>
		<dsp:input bean="LoginFormHandler.submit" type="submit" />
		<br/>
		<dsp:valueof bean="LoginFormHandler.checked"></dsp:valueof>		
	</dsp:form>
</dsp:page>
<%-- @version $Id: //product/Eclipse/main/plugins/atg.project/templates/index.jsp#1 $$Change: 425088 $--%>
