<%@ taglib uri="/dspTaglib" prefix="dsp"%>

<dsp:page>
	<title>Cart</title>
	<dsp:importbean
		bean="/atg/commerce/order/purchase/CartModifierFormHandler" />
	<dsp:importbean
		bean="/atg/commerce/order/purchase/StoreCartFormHandler" />
	<dsp:importbean bean="/atg/formhandler/MyCartModifierFormHandler" />
	<dsp:importbean bean="/atg/commerce/pricing/ItemPricingEngine" />

	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<dsp:importbean bean="/atg/dynamo/droplet/Compare" />

	<table border=1 cellpadding=0 cellspacing=0 align="center">
		<tr bgcolor="#DBDBDB">
			<td colspan=1 height=18><span class=small> <dsp:droplet
				name="Switch">
				<dsp:param name="value" param="noCrumbs" />
				<dsp:oparam name="false">
				</dsp:oparam>
				<dsp:oparam name="default">
					<dsp:param name="noCrumbs" value="true" />
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b
						style="color: blue">Current Order</b>
				</dsp:oparam>
			</dsp:droplet></td>
		</tr>


		<tr valign=top>
			<td valign="top" width=600><%-- put errors here --%> <%-- this table just for indent --%>
			<table border=0 bordercolor="red" cellpadding=4>
				<tr>
					<td><dsp:droplet name="Switch">
						<dsp:param bean="ShoppingCart.current.CommerceItemCount"
							name="value" />
						<dsp:oparam name="0">
            There are no items in your current order.
          				</dsp:oparam>
						<dsp:oparam name="default">
							<dsp:form action="cart.jsp" name="testForm" method="post">
								<table border=1 bordercolor="blue" cellpadding=4 cellspacing=1>
									<tr bgcolor="lime">
										<td align=center colspan="1"><span class=smallbw>Delivery
										Method</span></td>
										
										<td align=center colspan=1><span class=smallbw>Name</span></td>
										<td align=center colspan=1><span class=smallbw>Qty</span></td>
										<td align=center colspan=1><span class=smallbw>Rate</span></td>
										<td align=center colspan=1><span class=smallbw>TOTAL</span></td>
										<td align=center colspan=1><b><span class=smallbw>Remove</span><b></td>
									</tr>
									<tr>
									</tr>
									<dsp:param name="count" value="1" />
									<%-- get the real shopping cart items --%>
									<tr>
										<td><input id="txtDeliveryOption" value="" type="text" /></td>
									</tr>
									<dsp:droplet name="ForEach">
										<dsp:param name="array"
											bean="ShoppingCart.current.CommerceItems" />
										<dsp:param name="elementName" value="CommerceItem" />
										<dsp:oparam name="output">
											<dsp:getvalueof id="currentItem" param="CommerceItem.id">
												<tr valign=top>

													<%-- Display part number, product name/link, inventory info columns --%>

													<td colspan="1">
													
													<dsp:input
														bean="/atg/commerce/order/ShoppingCartModifier.shippingGroup.shippingMethod"
														value="Ship To You"
														onchange="txtDeliveryOption.value+=this.value"
														name="<%="Delivery"
													+ currentItem.toString()%>"
														type="radio" checked="true">
													</dsp:input><dsp:valueof value="Ship To You" /><br />
													<dsp:input
														bean="/atg/commerce/order/ShoppingCartModifier.shippingGroup.shippingMethod"
														value="Pick Up"
														onchange="txtDeliveryOption.value+=this.value"
														name="<%="Delivery"
													+ currentItem.toString()%>"
														type="radio">
													</dsp:input><dsp:valueof value="Pick Up" /><br />
													<dsp:input
														bean="/atg/commerce/order/ShoppingCartModifier.shippingGroup.shippingMethod"
														value="Local Delivery"
														onchange="txtDeliveryOption.value+=this.value"
														name="<%="Delivery"
													+ currentItem.toString()%>"
														type="radio">
													</dsp:input><dsp:valueof value="Local Delivery" /><br />
													</td>
													
													<%-- Display editable quantity column --%>
													<td colspan="1"><dsp:param name="prodName"
														param="CommerceItem.auxiliaryData.catalogRef.displayName" />
													<dsp:a href="displayProdSku.jsp">
														<dsp:valueof param="prodName" />
														<dsp:param name="prodId"
															param="CommerceItem.auxiliaryData.catalogRef.id" />
													</dsp:a></td>
													<td><input type="text" size="3"
														name="<dsp:valueof param='CommerceItem.id'/>"
														value="<dsp:valueof param='CommerceItem.quantity'/>" /></td>

													<%-- display Sale Price/List Price --%>
													<td><dsp:droplet name="Switch">
														<dsp:param name="value"
															param="CommerceItem.priceInfo.onSale" />
														<dsp:oparam name="false">
															<dsp:valueof converter="currency"
																param="CommerceItem.priceInfo.listPrice" />

														</dsp:oparam>
														<dsp:oparam name="true">
															<STRIKE><dsp:valueof
																param="CommerceItem.priceInfo.listPrice" /></STRIKE>
															<br>
															<dsp:valueof converter="currency"
																param="CommerceItem.priceInfo.salePrice" />
														</dsp:oparam>
													</dsp:droplet></td>
													<!-- TOTAL Price -->
													<td><dsp:droplet name="Switch">
														<dsp:param name="value"
															param="CommerceItem.priceInfo.onSale" />
														<dsp:oparam name="false">
															<dsp:valueof converter="currency"
																param="CommerceItem.priceInfo.rawTotalPrice" />

														</dsp:oparam>
														<dsp:oparam name="true">
															<STRIKE><dsp:valueof
																param="CommerceItem.priceInfo.rawTotalPrice" /></STRIKE>
															<br>
															<dsp:valueof converter="currency"
																param="CommerceItem.priceInfo.amount" />
														</dsp:oparam>
													</dsp:droplet></td>
													<%-- Display "remove" checkbox column --%>
													<td align=middle><dsp:getvalueof
														vartype="java.lang.Object" var="CommerceItemIds"
														param="CommerceItem.id" /> <dsp:getvalueof
														id="commerceItemId" param="CommerceItem.id">

														<dsp:input type="checkbox"
															bean="CartModifierFormHandler.removalCommerceIds"
															value="<%=commerceItemId%>" />


													</dsp:getvalueof></td>
												</tr>
											</dsp:getvalueof>
										</dsp:oparam>

									</dsp:droplet>
									<%-- end ForEach over shipping groups --%>
									<tr align="right">
										<td colspan="6">Item Subtotal: &nbsp;<dsp:droplet
											name="Compare">
											<dsp:param bean="ShoppingCart.current.priceInfo.amount"
												name="obj1" />
											<dsp:param bean="ShoppingCart.current.priceInfo.rawSubtotal"
												name="obj2" />
											<b style="color: blue"> <dsp:oparam name="default">
												<dsp:valueof converter="currency"
													bean="ShoppingCart.current.priceInfo.amount" />
											</dsp:oparam> <dsp:oparam name="equal">
												<dsp:valueof converter="currency"
													bean="ShoppingCart.current.priceInfo.amount" />
											</dsp:oparam> </b>
										</dsp:droplet> <br />
										Estimated Shipping Charge: &nbsp;<b style="color: blue"><dsp:valueof
											converter="currency" value="$5.00" /></b></td>
									</tr>
									<tr align="left">
										<td>Coupon:<input type="text" /><input type="submit" /></td>
									</tr>
								</table>
								<hr color="red" size="5" width=100%>

								<center><%-- Update Order button: --%> <dsp:input
									bean="CartModifierFormHandler.setOrderByCommerceId"
									type="submit" value="Update" /> <%-- Remove Selected Items Link: --%>
								<dsp:a href="cart.jsp"
									bean="CartModifierFormHandler.setOrderByCommerceId" value="">
									<dsp:valueof value="Remove All"></dsp:valueof>
								</dsp:a> <%-- GoTo this URL if user pushes RECALCULATE button and there are no errors: --%>
								<dsp:input bean="CartModifierFormHandler.setOrderSuccessURL"
									type="hidden" value="cart.jsp" /> <%
 	/* stay here */
 %> <%--
					              		GoTo this URL if user pushes RECALCULATE button and there are errors:
					            --%> <dsp:input
									bean="CartModifierFormHandler.setOrderErrorURL" type="hidden"
									value="cart.jsp" /> <%
 	/* stay here */
 %> <%-- CHECKOUT Order button: --%> &nbsp; &nbsp; <dsp:input
									bean="CartModifierFormHandler.moveToPurchaseInfoByCommerceId"
									type="submit" value="Checkout" /> <dsp:a href="home.jsp">
									<dsp:valueof value="Back to Search" />
								</dsp:a></center>
								<dsp:param name="fromHomePage" value="false" />
								<%-- If Order is Successful --%>
								<dsp:input
									bean="CartModifierFormHandler.moveToPurchaseInfoSuccessURL"
									type="hidden" value="checkout/shipping.jsp" />

								<%-- move on to shipping --%>

								<dsp:input
									bean="CartModifierFormHandler.moveToPurchaseInfoErrorURL"
									type="hidden" value="cart.jsp" />
							</dsp:form>
						</dsp:oparam>

					</dsp:droplet></td>
				</tr>
				<tr>
					<td></td>
				</tr>
			</table>
			<%-- end indent table --%></td>
		</tr>
	</table>
</dsp:page>
<%-- @version $Id: //product/B2BCommerce/version/9.0/release/MotorpriseJSP/j2ee-apps/motorprise/web-app/en/checkout/cart.jsp#1 $$Change: 508164 $--%>
