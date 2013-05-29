<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<dsp:page>
	<dsp:importbean bean="/atg/userprofiling/Profile" />
	<dsp:importbean bean="/atg/userprofiling/ProfileFormHandler" />
	<dsp:importbean bean="/atg/dynamo/Configuration" />
	<dsp:importbean bean="/atg/formhandler/SearchFormHandler" />
	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Insert title here</title>
	</head>
	<body>
	<h5 align="right">
	<div><dsp:a
		href="javascript:ajaxpage('profile/registration.jsp', 'page');">New User?</dsp:a>
	&nbsp;&nbsp;&nbsp;&nbsp; <dsp:droplet
		name="/atg/dynamo/droplet/IsEmpty">
		<dsp:param name="value" bean="Profile.Login" />
		<dsp:oparam name="false">
			<!--<dsp:a
		href="javascript:ajaxpage('login.jsp', 'page');"> Sign Out</dsp:a>-->
			<a href="#" class="launchLink">Sign Out</a>
		</dsp:oparam>
		<dsp:oparam name="true">
			<!--<dsp:a
		href="javascript:ajaxpage('login.jsp', 'page');"> Sign In</dsp:a>-->
			<a href="#" class="launchLink">Sign In</a>
		</dsp:oparam>
	</dsp:droplet> &nbsp;&nbsp;&nbsp;&nbsp; 
	<dsp:a href="../checkout/shippingAndBilling.jsp"><dsp:img src="../photo/cart.jpg" height="50" width="50"/></dsp:a>&nbsp;&nbsp;&nbsp;&nbsp; 
	<!--<dsp:a title="1st Step to place an order"
		href="javascript:ajaxpage('checkout/shipping_fg1.jsp', 'page');">Checkout
	</dsp:a> 
	--><!--<a href="javascript:ajaxpage('cart.jsp', 'page');">Cart</a> -->
	<dsp:a href="../cart.jsp"><dsp:img src="../photo/e-commerce.jpg" height="40" width="50"/></dsp:a>
	<dsp:droplet
		name="Switch">
		<dsp:param bean="ShoppingCart.current.TotalCommerceItemCount"
			name="value" />
		<dsp:oparam name="0">
			<dsp:valueof value="(empty)" />
		</dsp:oparam>
		<dsp:oparam name="default">
			<dsp:valueof value="(" />
			<dsp:valueof bean="ShoppingCart.current.TotalCommerceItemCount" />
			<dsp:valueof value=")" />
		</dsp:oparam>
	</dsp:droplet> <br />
	Welcome &nbsp; <dsp:droplet name="/atg/dynamo/droplet/IsEmpty">
		<dsp:param name="value" bean="Profile.Login" />
		<dsp:oparam name="false">
			<dsp:a href="../profile/my_profile.jsp" title="My Profile">
				<dsp:valueof bean="/atg/userprofiling/Profile.firstName" />&nbsp;&nbsp;
							<dsp:valueof bean="/atg/userprofiling/Profile.lastName" />
			</dsp:a>&nbsp;&nbsp;
			Last Activity:&nbsp;<dsp:valueof date="MMMM d, yyyy"
				bean="Profile.lastActivity" />
		</dsp:oparam>
		<dsp:oparam name="true">
			<dsp:valueof value="Guest" />
		</dsp:oparam>
	</dsp:droplet> &nbsp;&nbsp;&nbsp;</div>
	<hr size="4" color="blue" />
	</h5>
	</body>
</dsp:page>
</html>