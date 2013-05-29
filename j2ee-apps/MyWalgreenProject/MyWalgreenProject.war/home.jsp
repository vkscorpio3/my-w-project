<%@ page buffer="1kb" import="atg.servlet.*"%>
<%@ page buffer="1kb" language="java"
	contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<dsp:page>
	<dsp:importbean bean="/atg/formhandler/SearchFormHandler" />
	<dsp:droplet name="/atg/dynamo/droplet/ErrorMessageForEach">
		<dsp:param name="exceptions" bean="SearchFormHandler.formExceptions" />
		<dsp:oparam name="output">
			<b><dsp:valueof param="message" /> </b>
		</dsp:oparam>
	</dsp:droplet>

	<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="description" content="" />
	<meta name="keywords" content="" />

	<title>Buy from home || get at your doorstep</title>

	<link href="http://fonts.googleapis.com/css?family=Oswald"
		rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="style.css" />

	<script type="text/javascript" src="jquery-1.7.1.min.js"></script>

	<script type="text/javascript" src="init.js"></script>
	<script type="text/javascript" src="ajax.js"></script>

	<link rel="stylesheet" type="text/css" href="css/overlay.css" />
	</head>
	<body>
	<div id="wrapper">
	<div id="splash"><img src="images/store.jpg" alt="" /></div>
	<dsp:include page="fg/fg_login_information.jsp" /> <dsp:include
		page="fg_search_box.jsp" /> <dsp:include page="fg/fg_menu.jsp" />

	<div id="page"><dsp:include page="./fg/fg_page.jsp" /></div>
	</div>
	<dsp:include page="fg/fg_footer.jsp" />
	<div class="bgCover">&nbsp;</div>
	<div class="overlayBox">
	<div class="overlayContent"><a href="#" class="closeLink">Close</a>
	<dsp:include page="login.jsp" /></div>
	</div>
	<script type="text/javascript" src="javaScript/overlay.js"></script>
	</body>
</dsp:page>
</html>
