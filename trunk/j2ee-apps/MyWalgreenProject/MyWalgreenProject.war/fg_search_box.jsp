<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<dsp:page>
<dsp:importbean bean="/atg/formhandler/SearchFormHandler" />
<body>
	<dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
		<dsp:param name="exceptions" bean="SearchFormHandler.formExceptions" />
		<dsp:oparam name="output">
			<b> <dsp:valueof param="message" /> </b>
			<p>
		</dsp:oparam>
	</dsp:droplet>

<div>
	<form action="" method="post">
	<div id="search"><dsp:form>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<dsp:input type="text" bean="/atg/formhandler/SearchFormHandler.searchText"
			value="Enter Product Name" name="search" size="32" maxlength="64"
			onclick="this.value=''" />
		<dsp:input type="submit" value="Search"
			bean="SearchFormHandler.submit" />

	</dsp:form></div>
	</form>
	</div>
</body>
</dsp:page>
</html>