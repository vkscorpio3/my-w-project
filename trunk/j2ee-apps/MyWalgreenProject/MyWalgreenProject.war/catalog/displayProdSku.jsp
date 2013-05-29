<%@ page import="atg.servlet.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page import="atg.servlet.*"%>
<html>
<dsp:page>
<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty"/>
	<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	<title>Product</title>
	<link href="http://fonts.googleapis.com/css?family=Oswald"
		rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="../style.css" />
	<script type="text/javascript" src="../jquery-1.7.1.min.js"></script>

	<script type="text/javascript" src="../init.js"></script>
	<script type="text/javascript" src="../jquery.dropotron-1.0.js"></script>
	<script type="text/javascript" src="../ajax.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/overlay.css" />
	<title>Sku Search Result</title>
	</head>
	<body>
	<div id="wrapper">
	<div id="splash"><img src="../images/store.jpg" alt="" /></div>
	<dsp:include page="../fg/fg_login_information.jsp"/>
	<dsp:include page="../fg_search_box.jsp"/> 
	<dsp:include
		page="../fg/fg_menu.jsp"/>
	<center>
	<div id="page">
	</div>
	</center>
	</div>
	<div class="bgCover">&nbsp;</div>
	<div class="overlayBox">
	<div class="overlayContent"><a href="#" class="closeLink">Close</a>
	<dsp:include page="../login.jsp"/></div>
	</div>
	<script type="text/javascript" src="../javaScript/overlay.js"></script>

	</body>
</dsp:page>
</html>
