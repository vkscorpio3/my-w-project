<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page import="atg.servlet.*"%>
<html>
<dsp:page>
	<head>
	<title>Sku Search Result</title>
	</head>
	<body>
	<dsp:form>
		<dsp:droplet name="/atg/dynamo/droplet/ForEach">
			<dsp:param param="element.childSKUs" name="array" />
			<dsp:param value="Sku" name="elementName" />
			<dsp:oparam name="output">
				<dsp:getvalueof id="option" param="Sku.repositoryID"
					idtype="java.lang.String">
					<dsp:option value="<%=option%>" />
				</dsp:getvalueof>
				<dsp:valueof param="Sku.displayName" />
			</dsp:oparam>
		</dsp:droplet>
	</dsp:form>
	</body>
</dsp:page>
</html>
