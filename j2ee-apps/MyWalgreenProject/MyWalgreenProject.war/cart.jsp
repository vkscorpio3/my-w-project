<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ taglib uri="/c" prefix="c"%>

<dsp:page>
	<title>Cart</title>
	<dsp:importbean bean="/atg/commerce/promotion/CouponFormHandler" />
	<dsp:importbean
		bean="/atg/commerce/order/purchase/CartModifierFormHandler" />
	<dsp:importbean
		bean="/atg/commerce/order/purchase/StoreCartFormHandler" />
	<dsp:importbean bean="/atg/formhandler/MyCartModifierFormHandler" />
	<dsp:importbean bean="/atg/commerce/pricing/ItemPricingEngine" />

	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<dsp:importbean bean="/atg/dynamo/droplet/Compare" />

	<table border=1 cellpadding=0 cellspacing=0 align="center">
		<tr bgcolor="#DBDBDB">
			<td colspan=1 height=18><span class=small> 
			<dsp:droplet name="Switch">
				<dsp:param name="value" param="noCrumbs" />
				<dsp:oparam name="false">
				</dsp:oparam>
				<dsp:oparam name="default">
					<dsp:param name="noCrumbs" value="true" />
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b
						style="color: blue">Current Order</b>
				</dsp:oparam>
			</dsp:droplet>
			</td>
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
													<dsp:getvalueof var="fulfillerType" param="CommerceItem.auxiliaryData.catalogRef.fulfillerType"/>
													<dsp:getvalueof var="sddEnabled" param="CommerceItem.auxiliaryData.catalogRef.sddEnabled"/>
													<dsp:getvalueof var="webExclusive" param="CommerceItem.auxiliaryData.catalogRef.webExclusive"/>
													<dsp:getvalueof var="activated" param="CommerceItem.auxiliaryData.catalogRef.activated"/>
													<dsp:getvalueof var="shippingChargeCode" param="CommerceItem.auxiliaryData.catalogRef.shippingChargeCode"/>
													<dsp:getvalueof var="loyaltyEligible" param="CommerceItem.auxiliaryData.catalogRef.loyaltyEligible"/>
													<dsp:getvalueof var="loyaltyRedeemable" param="CommerceItem.auxiliaryData.catalogRef.loyaltyRedeemable"/>
													<br/>
													<dsp:valueof param="CommerceItem.id"></dsp:valueof><br/>
													
													<%-- Ship To You bean="/atg/commerce/order/ShoppingCartModifier.shippingGroup.shippingMethod" --%>
													<c:if test="${webExclusive eq 'Web Only' or webExclusive eq 'Web and Store'}">	
													<dsp:input
														bean="/atg/commerce/order/CommerceItem.shippingMethod"
														value="Ship To You"
														onchange="txtDeliveryOption.value+=this.value"
														name="<%="Delivery"
														+ currentItem
																.toString()%>"
														type="radio" checked="true"/>
													<dsp:valueof value="Ship To You" /><br />
													</c:if>
													
														<%-- Pick Up --%>
													<c:if test="${webExclusive eq 'Store Only' or webExclusive eq 'Web and Store' or webExclusive eq 'Web Pickup and Store'}">
													<dsp:input
														bean="/atg/commerce/order/CommerceItem.shippingMethod"
														value="Pick Up"
														onchange="txtDeliveryOption.value+=this.value"
														name="<%="Delivery"
														+ currentItem
																.toString()%>"
														type="radio" checked="true"/>
													<dsp:valueof value="Pick Up" /><br />
													</c:if>
														<%-- Same Day Delivery --%>
													<c:if test="${(webExclusive eq 'Web and Store' or webExclusive eq 'Web Pickup and Store') and sddEnabled eq 'true'}">
													<dsp:input
														bean="/atg/commerce/order/CommerceItem.shippingMethod"
														value="Same Day Delivery"
														onchange="txtDeliveryOption.value+=this.value"
														name="<%="Delivery"
																	+ currentItem
																			.toString()%>"
														type="radio" checked="true">
													<dsp:setvalue param=""/>
													</dsp:input><dsp:valueof value="Same Day Delivery" /><br />
													</c:if>
													</td>

													<%-- Display editable quantity column --%>
													<td colspan="1"><dsp:param name="prodName"
														param="CommerceItem.auxiliaryData.catalogRef.displayName" />
													<dsp:a href="displayProdSku.jsp">
														<dsp:valueof param="prodName" />
														<dsp:param name="prodId"
															param="CommerceItem.auxiliaryData.catalogRef.id" />
													</dsp:a> <!-- Display Imgage of CommerceItem --> <dsp:getvalueof
														id="imgUrl"
														param="CommerceItem.auxiliaryData.productRef.smallImage.url"
														idtype="java.lang.String">
														<%
															if (null != imgUrl) {
																imgUrl = imgUrl.substring(imgUrl.lastIndexOf("/") + 1);
																imgUrl = imgUrl.substring(imgUrl.indexOf("_") + 1);
															}
														%>
														<dsp:img height="100"
															src="<%="product_images/"
															+ imgUrl%>" />
													</dsp:getvalueof></td>
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
													</dsp:droplet>
													orderDiscountShare:	<dsp:valueof param="CommerceItem.priceInfo.orderDiscountShare"></dsp:valueof><br>
													quantityDiscounted:	<dsp:valueof param="CommerceItem.priceInfo.quantityDiscounted"></dsp:valueof>
													</td>
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
													<td align="center"><dsp:getvalueof
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
										<td colspan="6">
										<table>
											<tr>
												<dsp:getvalueof var="rawSubtotal" vartype="java.lang.Double"
													bean="ShoppingCart.current.priceInfo.rawSubtotal" />
												<td>Raw Subtotal :</td>
												<td align="right"><b style="color: blue"> <dsp:valueof
													converter="currency"
													bean="ShoppingCart.current.priceInfo.rawSubtotal" /></b></td>
												
											</tr>
											<c:if test="${rawSubtotal ge 80}">
													<tr>
														<td>Discount:</td>
														<td align="right"><b style="color: blue"> <dsp:valueof
															converter="currency" value="$20.00" /></b></td>
													</tr>
											</c:if>
											<tr>
												<td>Item Subtotal:</td>
												<td align="right"><b style="color: blue">
												<dsp:droplet name="Compare">
													<dsp:param bean="ShoppingCart.current.priceInfo.amount"
														name="obj1" />
													<dsp:param
														bean="ShoppingCart.current.priceInfo.rawSubtotal"
														name="obj2" />
													 <dsp:oparam name="default">
														<dsp:valueof converter="currency"
															bean="ShoppingCart.current.priceInfo.amount" />
													</dsp:oparam> <dsp:oparam name="equal">
														<dsp:valueof converter="currency"
															bean="ShoppingCart.current.priceInfo.amount" />
													</dsp:oparam> 
												</dsp:droplet> </b>
												</td>
											</tr>
											<tr>
												<dsp:setvalue
													bean="ShoppingCartModifier.order.priceInfo.shipping"
													value="5.99" />
												<td>Shipping Charge:</td>
												<td align="right"><b style="color: blue"> <dsp:valueof
													converter="currency"
													bean="ShoppingCart.current.priceInfo.shipping" /></b> 
												</td>
											</tr>
											<tr>
												<td>Estimated Total:</td>
												<td align="right"><b style="color: blue"> <dsp:valueof
													converter="currency"
													bean="ShoppingCart.current.priceInfo.total" /></b> 
												</td>
											</tr>
											<!--<b	style="color: blue"> 
										<dsp:valueof converter="currency"
											bean="ShoppingCartModifier.order.priceInfo.total" /></b> 
										<br/>-->
											<tr>
												<td colspan="2"><dsp:input
													bean="ShoppingCartModifier.repriceOrder" type="submit"
													value="Reprice Order"></dsp:input>
											<tr>
												<td>
										</table>
										</td>
									</tr>

									<tr align="left">
										<td colspan="7">Promotions<br>
										<dsp:droplet name="/atg/dynamo/droplet/ForEach">
											<dsp:param bean="/atg/userprofiling/Profile.activePromotions"
												name="array" />
											<dsp:oparam name="outputStart">
												<b>You have these promotions:</b>
											</dsp:oparam>
											<dsp:oparam name="output">
												<li><dsp:valueof param="element.promotion.displayName" /></li>
											</dsp:oparam>
											<dsp:oparam name="empty">You have no promotions</dsp:oparam>
										</dsp:droplet> <%--<dsp:include page="common/DisplayActivePromotions.jsp">
										</dsp:include>--%>
										</td>
									</tr>
									<tr align="left">
										<td colspan="7">Coupon<br>

										<b>If you have a coupon, type its code here:</b><br>

										<%
											/* Where to go to on success or failure */
										%> <dsp:input bean="CouponFormHandler.claimCouponSuccessURL"
											value="cart.jsp" type="hidden" /> <dsp:input
											bean="CouponFormHandler.claimCouponErrorURL" value="cart.jsp"
											type="hidden" /> <%
 	/* Get the coupon claim code */
 %> Coupon code: <dsp:input bean="CouponFormHandler.couponClaimCode"
											type="text" /> <dsp:input
											bean="ShoppingCartModifier.repriceOrder" type="hidden"></dsp:input>
										<dsp:input bean="CouponFormHandler.claimCoupon" type="submit"
											value="Claim it" />
									</tr>

								</table>
								<hr color="red" size="5" width="100%">

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
									type="hidden" value="checkout/shippingAndBilling.jsp" />

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
