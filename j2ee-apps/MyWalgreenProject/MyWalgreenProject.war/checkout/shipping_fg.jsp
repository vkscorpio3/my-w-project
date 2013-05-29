<%@ taglib uri="/dspTaglib" prefix="dsp"%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%><html>
<dsp:page>
	<title>Shipping Option and Address</title>
	<dsp:importbean bean="/atg/userprofiling/Profile" />
	<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier" />
	<dsp:setvalue bean="Profile.currentLocation" value="shopping_cart" />
	<dsp:importbean bean="/atg/dynamo/droplet/ErrorMessageForEach" />
	<body>
	<table border="4" style='table-layout:fixed;'>
	<!-- To fix the table width -->
	<col width=400>
		<tr align="center">
			<td>Shipping Information</td>
		</tr>
		<dsp:droplet name="ForEach">
			<dsp:param bean="ShoppingCartModifier.Order.ShippingGroups"
				name="array" />
			<dsp:param name="elementName" value="ShippingGroup" />
			<dsp:param name="indexName" value="shippingGroupIndex" />
			<dsp:oparam name="output">
				<dsp:droplet name="IsEmpty">
					<dsp:param name="value"
						param="ShippingGroup.CommerceItemRelationships" />
					<dsp:oparam name="false">
						<dsp:droplet name="Switch">
							<dsp:param name="value"
								param="ShippingGroup.shippingGroupClassType" />
							<dsp:oparam name="hardgoodShippingGroup">
								<tr>
									<td><b style="color: red;">Address:</b><br/>
										<dsp:valueof param="ShippingGroup.shippingAddress.address1" /><br/> 
										<dsp:valueof param="ShippingGroup.shippingAddress.state" />, 
										<dsp:valueof param="ShippingGroup.shippingAddress.city" />-
										<dsp:valueof param="ShippingGroup.shippingAddress.postalCode" /><br/> 
										Country :<dsp:getvalueof param="ShippingGroup.shippingAddress.country" id="country" idtype="String">
		    							<% country=country.toUpperCase(); %>
		    							<dsp:valueof value="<%=country %>" />
		    							</dsp:getvalueof> 
										<!-- End the default shipping information -->
									</td>
								</tr>
								<tr>
									<td><b style="color: red;">Shipping method:</b> <dsp:valueof
										param="ShippingGroup.shippingMethod" /></td>
								</tr>
							</dsp:oparam>
							<!-- End print out info for hardgood shipping group -->

							<dsp:oparam name="electronicShippingGroup">
								<b>Email to:</b>
								<br>
								<dsp:valueof param="ShippingGroup.emailAddress" />
							</dsp:oparam>
						</dsp:droplet>

					</dsp:oparam>
				</dsp:droplet>

			</dsp:oparam>

			<dsp:oparam name="empty">
No items in the cart!
</dsp:oparam>

		</dsp:droplet>

	</table>
	<dsp:a href="shippingAndBilling.jsp">Edit Shipping and Billing Info</dsp:a>
	</body>
</dsp:page>