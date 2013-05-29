<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/commerce/order/purchase/CartModifierFormHandler"/>
<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<title>My Profile</title>
<link rel="stylesheet" type="text/css" href="../css/pageDesign.css" />
<dsp:page>
<dsp:importbean bean="/atg/userprofiling/B2CProfileFormHandler" />
<h1 align="center">I'm <b> <dsp:valueof bean="Profile.firstName"/> <dsp:valueof bean="Profile.lastName"/> </b></h1>
<hr color="red"/>
<center>
<dsp:a href="../cart.jsp" >Cart( <dsp:valueof bean="/atg/commerce/ShoppingCart.current.TotalCommerceItemCount"></dsp:valueof> )</dsp:a>
&nbsp;<dsp:a href="../home.jsp">Back to Search</dsp:a>
&nbsp;<dsp:a href="order_history.jsp">My Oders</dsp:a></center>
<hr color="red"/>
<head>
<script src="../jquery-1.7.1.min.js"></script>
<script src="../javaScript/jqueryMyProfileEdit.js"></script>	
</head>
	<p>
	<font color="RED"> 
	<dsp:droplet
		name="/atg/dynamo/droplet/Switch">
		<dsp:param bean="CartModifierFormHandler.formError" name="value" />
		<dsp:oparam name="true">
			<span class=registrationerror> <span class=help>Cart
			Error !:</span> <dsp:droplet name="ErrorMessageForEach">
				<ul>
					<dsp:param bean="CartModifierFormHandler.formExceptions"
						name="exceptions" />
					<dsp:oparam name="output">
						<LI><dsp:valueof param="message" />
					</dsp:oparam>
				</ul>
			</dsp:droplet> </span>
		</dsp:oparam>
	</dsp:droplet> 
	</font>
	</p>
	<dsp:form action="../home.jsp" method="POST">
		<dsp:input bean="B2CProfileFormHandler.updateSuccessURL" type="hidden"
			value='<%=request.getContextPath()
							+ "/profile/my_profile.jsp"%>' />
		
		<dsp:droplet name="/atg/dynamo/droplet/Switch">
			<dsp:param bean="Profile.transient" name="value" />
			<dsp:oparam name="true">
				<dsp:droplet name="/atg/dynamo/droplet/Redirect">
					<dsp:param value="/index.jsp" name="url" />
				</dsp:droplet>
			</dsp:oparam>
			<dsp:oparam name="false">
				<table align="center" border="2" width="700" bgcolor="#B0C4DE">
					<tr>
						<td align="center" colspan="2" style="color: blue; font-size: 24"><b><label>My
						Personal Info</label></td>
					</tr>
					<tr>
						<td>First Name :</td>
						<td id="tdFirstName"><dsp:valueof bean="Profile.firstName" /></td>
						<dsp:input bean="B2CProfileFormHandler.value.firstName"
							id="hiddenFirstName" type="hidden" />
					</tr>
					<tr>
						<td>Middle Name :</td>
						<td id="tdMiddleName"><dsp:valueof bean="Profile.middleName" /></td>
						<dsp:input bean="B2CProfileFormHandler.value.middleName"
							id="hiddenMiddleName" type="hidden" />
					</tr>
					<tr>
						<td>Last Name :</td>
						<td id="tdLastName"><dsp:valueof bean="Profile.lastName" /></td>
						<dsp:input bean="B2CProfileFormHandler.value.lastName"
							id="hiddenLastName" type="hidden" />
					</tr>
					<tr>
						<td>Email :</td>
						<td id="tdEmail"><dsp:valueof bean="Profile.email" /></td>
						<dsp:input bean="B2CProfileFormHandler.value.email"
							id="hiddenEmail" type="hidden" />
					</tr>
					<tr>
						<td>Telephone :</td>
						<td id="tdTelephone"><dsp:valueof
							bean="Profile.daytimeTelephoneNumber" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.daytimeTelephoneNumber"
							id="hiddenTelephone" type="hidden" />
					</tr>
					<tr>
						<td colspan="2" align="right"><input type="button"
							id="btnPersonalInfoEdit" value="Edit" /> <dsp:input
							bean="B2CProfileFormHandler.update" type="submit"
							id="btnPersonalInfoSave" value="Save" /></td>
					</tr>
				</table>
				<br />
				<table align="center" border="2" width="700" bgcolor="#F1D4DC">
					<tr>
					</tr>
					<tr>
						<td align="center" colspan="2" style="color: blue; font-size: 24"><b>My
						Billing Address</td>
					</tr>
					<tr>
						<td>Street Address :</td>
						<td id="tdBillAddress""><dsp:valueof
							bean="Profile.billingAddress.address1" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.billingAddress.address1"
							id="hiddenBillAddress" type="hidden" />
					</tr>
					<tr>
						<td>City :</td>
						<td id="tdBillCity"><dsp:valueof
							bean="Profile.billingAddress.city" /></td>
						<dsp:input bean="B2CProfileFormHandler.value.billingAddress.city"
							id="hiddenBillCity" type="hidden" />
					</tr>
					<tr>
						<td>State :</td>
						<td id="tdBillState"><dsp:valueof
							bean="Profile.billingAddress.state" /></td>
						<dsp:input bean="B2CProfileFormHandler.value.billingAddress.state"
							id="hiddenBillState" type="hidden" />
					</tr>
					<tr>
						<td>Postal Code :</td>
						<td id="tdBillZip"><dsp:valueof
							bean="Profile.billingAddress.postalCode" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.billingAddress.postalCode"
							id="hiddenBillZip" type="hidden" />
					</tr>
					<tr>
						<td>Country :</td>
						<td id="tdBillCountry"><dsp:valueof
							bean="Profile.billingAddress.country" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.billingAddress.country"
							id="hiddenBillCountry" type="hidden" />
					</tr>
					<tr>
						<td>Telephone :</td>
						<td id="tdBillPhone"><dsp:valueof
							bean="Profile.billingAddress.phoneNumber" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.billingAddress.phoneNumber"
							id="hiddenBillPhone" type="hidden" />
					</tr>
					<tr>
						<td colspan="2" align="right"><input type="button"
							id="btnBillingInfoEdit" value="Edit" /> <dsp:input
							bean="B2CProfileFormHandler.update" type="submit"
							id="btnBillingInfoSave" value="Save" /></td>
					</tr>
				</table>
				<br />
				<table align="center" border="2" width="700" bgcolor="yellowgreen">
					<tr>
						<td align="center" colspan="2" style="color: blue; font-size: 24"><b>My
						Shipping Address</td>
					</tr>
					<tr>
						<td>Street Address :</td>
						<td id="tdShipAddress"><dsp:valueof
							bean="Profile.shippingAddress.address1" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.shippingAddress.address1"
							id="hiddenShipAddress" type="hidden" />
					</tr>
					<tr>
						<td>City :</td>
						<td id="tdShipCity"><dsp:valueof
							bean="Profile.shippingAddress.city" /></td>
						<dsp:input bean="B2CProfileFormHandler.value.shippingAddress.city"
							id="hiddenShipCity" type="hidden" />
					</tr>
					<tr>
						<td>State :</td>
						<td id="tdShipState"><dsp:valueof
							bean="Profile.shippingAddress.state" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.shippingAddress.state"
							id="hiddenShipState" type="hidden" />
					</tr>
					<tr>
						<td>Postal Code :</td>
						<td id="tdShipZip"><dsp:valueof
							bean="Profile.shippingAddress.postalCode" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.shippingAddress.postalCode"
							id="hiddenShipZip" type="hidden" />
					</tr>
					<tr>
						<td>Country :</td>
						<td id="tdShipCountry"><dsp:valueof
							bean="Profile.shippingAddress.country" /></td>
						<dsp:input
							bean="B2CProfileFormHandler.value.shippingAddress.country"
							id="hiddenShipCountry" type="hidden" />
					</tr>
					<tr>
						<td colspan="2" align="right"><input type="button"
							id="btnShippingInfoEdit" value="Edit" /> <dsp:input
							bean="B2CProfileFormHandler.update" type="submit"
							id="btnShippingInfoSave" value="Save" /></td>
					</tr>
				</table>
			</dsp:oparam>
		</dsp:droplet>
	</dsp:form>
</dsp:page>