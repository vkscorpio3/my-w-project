<%@ taglib uri="/dspTaglib" prefix="dsp"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%><html>
<dsp:page>
	<title>Order Review</title>
	<head>
	<script src="../jquery-1.7.1.min.js"></script>

	<style type="text/css">
.text-label {
	color: buttonshadow;
	font-weight: bold;
}
html, body, .full-height {
    height: 100%;
}

body {
    margin: 0; // <-- to avoid unnecessary scrollbars.
}
</style>
	</head>
	<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="description" content="" />
	<meta name="keywords" content="" />


	<link href="http://fonts.googleapis.com/css?family=Oswald"
		rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../style.css" />

	<script type="text/javascript" src="../jquery-1.7.1.min.js"></script>

	<script type="text/javascript" src="../init.js"></script>
	<script type="text/javascript" src="../ajax.js"></script>
	
	<link rel="stylesheet" type="text/css" href="../css/overlay.css" />
	</head>
	<body>
	<div id="wrapper">
		<dsp:include page="../fg/fg_login_information.jsp"/>
		<div id="page">
			<center><dsp:include page="order_confirm_fg.jsp"/></center>
		</div>
	</div>
	<dsp:include page="../fg/fg_footer.jsp"/>
	<div class="bgCover">&nbsp;</div>
	<div class="overlayBox">
	<div class="overlayContent"><a href="#" class="closeLink">Close</a>
	<dsp:include page="../login.jsp"/></div>
	</div>
	<script type="text/javascript" src="../javaScript/overlay.js"></script>
	</body>
	
</dsp:page>
</html>