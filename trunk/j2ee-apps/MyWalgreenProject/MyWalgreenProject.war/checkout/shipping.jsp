<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<html>
<dsp:page>
	<title>Shipping Option and Address</title>
	<dsp:importbean bean="/atg/userprofiling/Profile" />
	<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty" />
	<dsp:importbean bean="/atg/dynamo/droplet/IsNull" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier" />
	<dsp:setvalue bean="Profile.currentLocation" value="shopping_cart" />
	<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach" />
	<head>
	<script src="../jquery-1.7.1.min.js"></script>
	
	<style type="text/css">
.text-label {
	color: buttonshadow;
	font-weight: bold;
}
</style>
	<script type="text/javascript">
	function changeToShipAddress() {
		document.forms["form1"]["billingFirstName"].value = document.forms["form1"]["shipFirstName"].value;
		document.forms["form1"]["billingLastName"].value = document.forms["form1"]["shipLastName"].value;
		document.forms["form1"]["billingAddress1"].value = document.forms["form1"]["shipAddress1"].value;
		document.forms["form1"]["billingPhone"].value = document.forms["form1"]["shipPhone"].value;
		document.forms["form1"]["billingZip"].value = document.forms["form1"]["shipZip"].value;
		document.forms["form1"]["billingCity"].value = document.forms["form1"]["shipCity"].value;
		document.forms["form1"]["billingState"].value = document.forms["form1"]["shipState"].value;
		document.forms["form1"]["billingCountry"].value = document.forms["form1"]["shipCountry"].value;
	}
</script>
	</head>
	<h1 align="center">Shipping and Payment</h1>
	<dsp:droplet name="ErrorMessageForEach">
		<dsp:param bean="ShoppingCartModifier.formExceptions"
			name="exceptions" />
		<dsp:oparam name="output">
			<center>
			<li><b><STRIKE></STRIKE><dsp:valueof param="message" /></b></li>
			</center>
		</dsp:oparam>
	</dsp:droplet>
	<dsp:form name="form1" action="order_confirm.jsp" method="post">
		<table cellspacing=0 cellpadding=0 border=1 bgcolor="#B0C4DE"
			align="center">

			<tr>
				<td><b style="color: blue">Personal Information</b></td>
				<td>
				<table border=1 cellpadding=4 cellspacing=10 width=700
					align="center">
					<tr>
						<td>First Name</td>
						<td>Middle Name</td>
						<td>Last Name</td>
					</tr>
					<tr>
						<td><dsp:input title="Enter First Name"
							bean="ShoppingCartModifier.profile.shippingAddress.firstName" type="text"
							onclick="this.value=''" />
						</td>
						<td><dsp:input title="Enter Middle Name"
							bean="ShoppingCartModifier.profile.shippingAddress.middleName" type="text"
							default="Middle Name"
							onclick="this.value=''" /></td>
						<td><dsp:input title="Enter Last Name"
							bean="ShoppingCartModifier.profile.shippingAddress.lastName" type="text"
							default="Last Name"
							onclick="this.value=''" /></td>
					</tr>
				</table>
				</td>
			</tr>

			<tr>
				<td><b style="color: blue">Shipping Address</b></td>
				<td>
				<table border=1 cellpadding=4 cellspacing=10 width=700
					align="center">
					<tr>
						<td align="center" colspan="2">First Name</td>
						<td><dsp:input title="Enter First Name"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.firstName"
							beanvalue="Profile.shippingAddress.firstName" type="text"
							id="shipFirstName" /></td>
						<td align="center" colspan="2">Last Name</td>
						<td><dsp:input title="Enter Lat Name"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.lastName"
							beanvalue="Profile.shippingAddress.lastName" type="text"
							id="shipLastName" /></td>
					</tr>
					<tr>
						<td align="center" colspan="2">Street Address</td>
						<td><dsp:input title="Enter Street Address"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.address1"
							beanvalue="Profile.shippingAddress.address1" type="text"
							id="shipAddress1" /></td>
						<td align="center" colspan="2">Contact No.</td>
						<td><dsp:input title="Enter Contact No."
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.phoneNumber"
							beanvalue="Profile.shippingAddress.phoneNumber" type="text"
							id="shipPhone" /></td>
					</tr>
					<tr>
						<td align="center" colspan="2">Zip Code</td>
						<td><dsp:input title="Enter Zip Code"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.postalCode"
							beanvalue="Profile.shippingAddress.postalCode" type="text"
							id="shipZip" /></td>
						<td align="center" colspan="2">City</td>
						<td><dsp:input title="Enter City"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.city"
							beanvalue="Profile.shippingAddress.city" type="text"
							id="shipCity" /></td>
					</tr>
					<tr>
						<td align="center" colspan="2">State</td>
						<td><dsp:select title="Choose State"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.state"
							id="shipState" onchange="txtState.value=this.value">
							<%
								atg.servlet.DynamoHttpServletRequest dynamoRequest = atg.servlet.ServletUtil
													.getDynamoRequest(request);
							%>

							<%-- Generate an empty option tag for no selection --%>
							<dsp:option value="" />
							<%-- Iterate over the list of known destinations and generate an option tag for each --%>

							<dsp:droplet name="/atg/dynamo/droplet/ForEach">
								<dsp:param name="array"
									bean="/atg/commerce/util/StateList.places" />
								<dsp:param name="elementName" value="state" />
								<dsp:oparam name="output">
									<dsp:option
										value='<%=dynamoRequest
												.getParameter("state.code")%>' />
									<%=dynamoRequest
														.getParameter("state.displayName")%>
								</dsp:oparam>
							</dsp:droplet>
						</dsp:select> <dsp:input title="Enter State"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.state"
							beanvalue="Profile.shippingAddress.state" type="text"
							id="txtState" /></td>
						<td align="center" colspan="2">Country</td>
						<td><dsp:input title="Enter Country"
							bean="ShoppingCartModifier.shippingGroup.shippingAddress.country"
							beanvalue="Profile.shippingAddress.country" type="text"
							id="shipCountry" converter="" /></td>
					</tr>
				</table>
				</td>
			</tr>

			<tr>
				<td><b style="color: blue">Billing Address</b><br>
				<input type="radio" name="sameAsShipping"
					onclick=changeToShipAddress();>Same As Shipping Address</input><br />
				<b style="color: red">(Refresh the page to load <br />
				original Billing Address)</b></td>
				<td>
				<table border=1 cellpadding=4 cellspacing=10 width=700
					align="center">
					<tr>
						<td align="center" colspan="2">First Name</td>
						<td><dsp:input title="Enter First Name"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.firstName"
							beanvalue="Profile.billingAddress.firstName" type="text"
							id="billingFirstName" /></td>
						<td align="center" colspan="2">Last Name</td>
						<td><dsp:input title="Enter Last Name"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.lastName"
							beanvalue="Profile.billingAddress.lastName" type="text"
							id="billingLastName" /></td>
					</tr>
					<tr>
						<td align="center" colspan="2">Street Address</td>
						<td><dsp:input title="Enter Street Address"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.address1"
							beanvalue="Profile.billingAddress.address1" type="text"
							id="billingAddress1" /></td>
						<td align="center" colspan="2">Contact No.</td>
						<td><dsp:input title="Enter Contact No."
							bean="ShoppingCartModifier.paymentGroup.billingAddress.phoneNumber"
							beanvalue="Profile.billingAddress.phoneNumber" type="text"
							id="billingPhone" /></td>
					</tr>
					<tr>
						<td align="center" colspan="2">Zip Code</td>
						<td><dsp:input title="Enter Zip Code"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.postalCode"
							beanvalue="Profile.billingAddress.postalCode" type="text"
							id="billingZip" /></td>
						<td align="center" colspan="2">City</td>
						<td><dsp:input title="Enter City"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.city"
							beanvalue="Profile.billingAddress.city" type="text"
							id="billingCity" /></td>
					</tr>
					<tr>
						<td align="center" colspan="2">State</td>
						<td><dsp:select title="Choose State"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.state"
							id="billingState" onchange="txtBillingState.value=this.value">
							<%
								atg.servlet.DynamoHttpServletRequest dynamoRequest = atg.servlet.ServletUtil
													.getDynamoRequest(request);
							%>

							<%-- Generate an empty option tag for no selection --%>
							<dsp:option value="" />

							<%-- Iterate over the list of known destinations and generate an option tag for each --%>

							<dsp:droplet name="/atg/dynamo/droplet/ForEach">
								<dsp:param name="array"
									bean="/atg/commerce/util/StateList.places" />
								<dsp:param name="elementName" value="state" />
								<dsp:oparam name="output">
									<dsp:option
										value='<%=dynamoRequest
												.getParameter("state.code")%>' />
									<%=dynamoRequest
														.getParameter("state.displayName")%>
								</dsp:oparam>
							</dsp:droplet>
						</dsp:select> <dsp:input title="Enter State"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.state"
							beanvalue="Profile.billingAddress.state" type="text"
							id="txtBillingState" /></td>
						<td align="center" colspan="2">Country</td>
						<td><dsp:input title="Enter Country"
							bean="ShoppingCartModifier.paymentGroup.billingAddress.country"
							beanvalue="Profile.billingAddress.country" type="text"
							id="billingCountry" /></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td><b style="color: blue">Credit Card</b></td>
				<td>
				<table border=1 cellpadding=4 cellspacing=10 width=700
					align="center">
					<tr>
						<td>Card Type</td>
						<td><dsp:select
							bean="ShoppingCartModifier.paymentGroup.creditCardType"
							required="<%=true%>">
							<dsp:option value="Visa" />Visa
											<dsp:option value="MasterCard" />Master Card
											<dsp:option value="AmericanExpress" />American Express
											<dsp:option value="Discover" />Discover
							</dsp:select></td>
					</tr>
					<tr>
						<td>Credit Card Number</td>
						<td><dsp:input
							bean="ShoppingCartModifier.paymentGroup.creditCardNumber"
							maxlength="16" size="20" type="text" value="4111111111111111" /></td>
					</tr>
					<tr>
						<td>Expiration Date</td>
						<td>Month: <dsp:select
							bean="ShoppingCartModifier.paymentGroup.expirationMonth">
							<dsp:option value="1" />January
										<dsp:option value="2" />February
										<dsp:option value="3" />March
										<dsp:option value="4" />April
										<dsp:option value="5" />May
										<dsp:option value="6" />June
										<dsp:option value="7" />July
										<dsp:option value="8" />August
										<dsp:option value="9" />September
										<dsp:option value="10" />October
										<dsp:option value="11" />November
										<dsp:option value="12" />December
									</dsp:select> Year: <dsp:select
							bean="ShoppingCartModifier.paymentGroup.expirationYear">
							<dsp:option value="2013" />2013
										<dsp:option value="2014" selected="true"/>2014
										<dsp:option value="2015" />2015
										<dsp:option value="2016" />2016
										<dsp:option value="2017" />2017
										<dsp:option value="2018" />2018
										<dsp:option value="2026" />2026
									</dsp:select></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><dsp:input
					bean="ShoppingCartModifier.moveToConfirmationSuccessURL"
					type="hidden" value="order_confirm.jsp" /> <!-- Set the Location to go to if there are error on this form.  We stay on this page and then -->
				<!-- just display the error messages.                                                          -->
				<dsp:input bean="ShoppingCartModifier.moveToConfirmationErrorURL"
					type="hidden" value="shipping.jsp" /> <!-- Go to this URL if user's session expired while he pondered this page -->
				<dsp:input bean="ShoppingCartModifier.sessionExpirationURL"
					type="hidden" value="home.jsp" /> <dsp:input
					bean="ShoppingCartModifier.moveToConfirmation" type="submit"
					value="   Continue   " /></td>
			</tr>
		</table>
	</dsp:form>
</dsp:page>
</html>