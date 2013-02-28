<%@ taglib uri="/dspTaglib" prefix="dsp" %>
<dsp:importbean bean="/atg/userprofiling/Profile"/>
<dsp:importbean bean="/atg/commerce/order/purchase/CartModifierFormHandler"/>
<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier"/>
<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach"/>
<title>My Profile</title>
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
	
</head>
	<p><font color="RED"> <dsp:droplet
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
	</dsp:droplet> </font></p>
	<dsp:form action="../home.jsp" method="POST">
	<dsp:input bean="B2CProfileFormHandler.updateSuccessURL" type="hidden" value='<%=request.getContextPath() + "/profile/my_profile.jsp"%>'/>
	<script>
	$(document).ready(function() {
		$("#btnPersonalInfoSave").hide();
		$("#btnBillingInfoSave").hide();
		$("#btnShippingInfoSave").hide();
		$("#btnPersonalInfoEdit").click(function() {
			$("#btnPersonalInfoSave").show();
			$(this).hide();
			$("#tdFirstName").replaceWith(function() {
				return "<input type=\"text\" id=\"FirstName\" value=\""
				+ $(this).
				html() + "\" />";
			});
			$("#tdLastName").replaceWith(function() {
				return "<input type=\"text\" id=\"LastName\" value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdMiddleName").replaceWith(function() {
				return "<input type=\"text\" id=\"MiddleName\"  value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdEmail").replaceWith(function() {
				return "<input type=\"text\" id=\"Email\"  value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdTelephone").replaceWith(function() {
				return "<input type=\"text\" id=\"Telephone\"  value=\""
						+ $(this).html() + "\" />";
			});
		});

		$("#btnPersonalInfoSave").click(function() {
			$("#btnPersonalInfoEdit").show();
			$(this).hide();
			$("#hiddenFirstName").val($("#FirstName").val());
			$("#hiddenLastName").val($("#LastName").val());
			$("#hiddenMiddleName").val($("#MiddleName").val());
			$("#hiddenEmail").val($("#Email").val());
			$("#hiddenTelephone").val($("#Telephone").val());
			
		});
			

		$("#btnBillingInfoEdit").click(function() {
			$("#btnBillingInfoSave").show();
			$(this).hide();
			$("#tdBillAddress").replaceWith(function() {
				return "<input type=\"text\" id=\"BillAddress\" value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdBillCity").replaceWith(function() {
				return "<input type=\"text\" id=\"BillCity\"   value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdBillState").replaceWith(function() {
				return "<input type=\"text\" id=\"BillState\"   value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdBillZip").replaceWith(function() {
				return "<input type=\"text\" id=\"BillZip\"   value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdBillCountry").replaceWith(function() {
				return "<input type=\"text\" id=\"BillCountry\"   value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdBillPhone").replaceWith(function() {
				return "<input type=\"text\" id=\"BillPhone\"   value=\""
						+ $(this).html() + "\" />";
			});
		});

		$("#btnBillingInfoSave").click(function() {
			$("#btnBillingInfoEdit").show();
			$(this).hide();
			$("#hiddenBillAddress").val($("#BillAddress").val());
			$("#hiddenBillCity").val($("#BillCity").val());
			$("#hiddenBillState").val($("#BillState").val());
			$("#hiddenBillZip").val($("#BillZip").val());
			$("#hiddenBillCountry").val($("#BillCountry").val());
			$("#hiddenBillPhone").val($("#BillPhone").val());
			
		});
		
		$("#btnShippingInfoEdit").click(function() {
			$("#btnShippingInfoSave").show();
			$(this).hide();
			$("#tdShipAddress").replaceWith(function() {
				return "<input type=\"text\" id=\"ShipAddress\" value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdShipCity").replaceWith(function() {
				return "<input type=\"text\" id=\"ShipCity\" value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdShipState").replaceWith(function() {
				return "<input type=\"text\" id=\"ShipState\" value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdShipZip").replaceWith(function() {
				return "<input type=\"text\" id=\"ShipZip\" value=\""
						+ $(this).html() + "\" />";
			});
			$("#tdShipCountry").replaceWith(function() {
				return "<input type=\"text\" id=\"ShipCountry\" value=\""
						+ $(this).html() + "\" />";
			});
		});

		$("#btnShippingInfoSave").click(function() {
			$("#btnShippingInfoEdit").show();
			$(this).hide();
			$("#hiddenShipAddress").val($("#ShipAddress").val());
			$("#hiddenShipCity").val($("#ShipCity").val());
			$("#hiddenShipState").val($("#ShipState").val());
			$("#hiddenShipZip").val($("#ShipZip").val());
			$("#hiddenShipCountry").val($("#ShipCountry").val());
			$("#hiddenShipPhone").val($("#BillPhone").val());
			
		});
	});
	</script>
	<dsp:droplet name="/atg/dynamo/droplet/Switch">
    <dsp:param bean="Profile.transient" name="value"/>
    <dsp:oparam name="true">
     <dsp:droplet name="/atg/dynamo/droplet/Redirect">
          <dsp:param value="/index.jsp" name="url"/>
        </dsp:droplet>
    </dsp:oparam>
    <dsp:oparam name="false">
	 <table align="center" border="2" width="700" bgcolor="#B0C4DE">
	 <tr><td align="center" colspan="2" style="color: blue; font-size: 24"><b><label>My Personal Info</label></td></tr>
	 <tr>
		 <td>First Name :</td>
		 <td id="tdFirstName"><dsp:valueof bean="Profile.firstName"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.firstName" id="hiddenFirstName" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Middle Name :</td>
		 <td id="tdMiddleName"><dsp:valueof bean="Profile.middleName"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.middleName" id="hiddenMiddleName" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Last Name :</td>
		 <td id="tdLastName"><dsp:valueof bean="Profile.lastName"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.lastName" id="hiddenLastName" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Email :</td>
		 <td id="tdEmail"><dsp:valueof bean="Profile.email"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.email" id="hiddenEmail" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Telephone :</td>
		 <td id="tdTelephone"><dsp:valueof bean="Profile.daytimeTelephoneNumber"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.daytimeTelephoneNumber" id="hiddenTelephone" type="hidden"/>
	 </tr>
	 <tr>
	 	<td colspan="2" align="right">
	 	<input type="button" id="btnPersonalInfoEdit" value="Edit"/>
   		<dsp:input bean="B2CProfileFormHandler.update" type="submit" id="btnPersonalInfoSave" value="Save"/>
	 	</td>
	 </tr>
	 </table>
	 <br/>
	 <table align="center" border="2" width="700" bgcolor="#F1D4DC">
	 <tr>
	 </tr>
	  <tr><td  align="center" colspan="2" style="color: blue; font-size: 24"><b>My Billing Address</td></tr>
	 <tr>
		 <td>Street Address :</td>
		 <td id="tdBillAddress"">
		 <dsp:valueof bean="Profile.billingAddress.address1"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.billingAddress.address1" id="hiddenBillAddress" type="hidden"/>
	 </tr>
	 <tr>
		 <td>City :</td>
		 <td id="tdBillCity"><dsp:valueof bean="Profile.billingAddress.city"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.billingAddress.city" id="hiddenBillCity" type="hidden"/>
	 </tr>
	 <tr>
		 <td>State :</td>
		 <td id="tdBillState"><dsp:valueof bean="Profile.billingAddress.state"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.billingAddress.state" id="hiddenBillState" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Postal Code :</td>
		 <td id="tdBillZip"><dsp:valueof bean="Profile.billingAddress.postalCode"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.billingAddress.postalCode" id="hiddenBillZip" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Country :</td>
		 <td id="tdBillCountry"><dsp:valueof bean="Profile.billingAddress.country"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.billingAddress.country" id="hiddenBillCountry" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Telephone :</td>
		 <td id="tdBillPhone"><dsp:valueof bean="Profile.billingAddress.phoneNumber"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.billingAddress.phoneNumber" id="hiddenBillPhone" type="hidden"/>
	 </tr>
	  <tr>
	 	<td colspan="2" align="right">
	 	<input type="button" id="btnBillingInfoEdit" value="Edit"/>
	 	<dsp:input bean="B2CProfileFormHandler.update" type="submit" id="btnBillingInfoSave" value="Save"/>
	 	</td>
	 </tr>
	 </table>
	 <br/>
	 <table align="center" border="2" width="700" bgcolor="yellowgreen">
	 <tr><td  align="center" colspan="2" style="color: blue; font-size: 24"><b>My Shipping Address</td></tr>
	<tr>
		 <td>Street Address :</td>
		 <td id="tdShipAddress">
		 <dsp:valueof bean="Profile.shippingAddress.address1"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.shippingAddress.address1" id="hiddenShipAddress" type="hidden"/>
	 </tr>
	 <tr>
		 <td>City :</td>
		 <td id="tdShipCity"><dsp:valueof bean="Profile.shippingAddress.city"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.shippingAddress.city" id="hiddenShipCity" type="hidden"/>
	 </tr>
	 <tr>
		 <td>State :</td>
		 <td id="tdShipState"><dsp:valueof bean="Profile.shippingAddress.state"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.shippingAddress.state" id="hiddenShipState" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Postal Code :</td>
		 <td id="tdShipZip"><dsp:valueof bean="Profile.shippingAddress.postalCode"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.shippingAddress.postalCode" id="hiddenShipZip" type="hidden"/>
	 </tr>
	 <tr>
		 <td>Country :</td>
		 <td id="tdShipCountry"><dsp:valueof bean="Profile.shippingAddress.country"/></td>
		 <dsp:input bean="B2CProfileFormHandler.value.shippingAddress.country" id="hiddenShipCountry" type="hidden"/>
	 </tr>
	  <tr>
	 	<td colspan="2" align="right"><input type="button" id="btnShippingInfoEdit" value="Edit"/>
	 	<dsp:input bean="B2CProfileFormHandler.update" type="submit" id="btnShippingInfoSave" value="Save"/>
	 	</td>
	 </tr>
	 </table>
    </dsp:oparam>
  </dsp:droplet>
  </dsp:form>
</dsp:page>