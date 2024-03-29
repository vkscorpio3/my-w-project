<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

	<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty" />
	<dsp:importbean bean="/atg/commerce/order/purchase/PaymentGroupDroplet" />
	<dsp:importbean
		bean="/atg/commerce/order/purchase/PaymentGroupFormHandler" />
	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<dsp:importbean bean="/atg/userprofiling/Profile" />
	<dsp:importbean bean="/atg/commerce/order/purchase/RepriceOrderDroplet" />

	<%--
Reprice the Order total so that we can assign PaymentGroups to any CommerceIdentifier.
--%>
	<dsp:droplet name="RepriceOrderDroplet">
		<dsp:param name="pricingOp" value="ORDER_TOTAL" />
	</dsp:droplet>

	<%--
The PaymentGroupDroplet is used here to initialize the user's CreditCard PaymentGroups,
and an OrderPaymentInfo object to associate a PaymentGroup with the Order.
--%>
	<dsp:droplet name="PaymentGroupDroplet">
		<dsp:param name="clear" param="init" />
		<dsp:param name="paymentGroupTypes" value="creditCard" />
		<dsp:param name="initPaymentGroups" param="init" />
		<dsp:param name="initOrderPayment" param="init" />
		<dsp:oparam name="output">

			<table border=0 cellpadding=0 cellspacing=0 width=800>
				<tr>
					<td colspan=3></td>
				</tr>

				<tr bgcolor="#DBDBDB">
					<%
						/* put breadcrumbs here */
					%>
					<td colspan=3 height=18><span class=small> &nbsp; <dsp:a
						href="../cart.jsp">Current Order</dsp:a> &gt; <dsp:a
						href="shipping.jsp">Shipping</dsp:a> &gt; Billing &nbsp;</span></td>
				</tr>

				<tr>
					<td width=55><dsp:img src="../images/d.gif" hspace="27" /></td>
					<td valign="top" width=745><dsp:form action="billing.jsp"
						method="post">
						<table border=0 cellpadding=4 width=80%>
							<tr>
								<td><dsp:img src="../images/d.gif" /></td>
							</tr>
							<tr>
								<td colspan=2><span class="big">Billing</span></td>
							</tr>
							<tr>
								<td><dsp:img src="../images/d.gif" /></td>
							</tr>
							<tr valign=top>
								<td align=right width=25%><span class=smallb>Payment
								method</span></td>
								<td><dsp:droplet name="ForEach">
									<dsp:param name="array" param="paymentGroups" />
									<dsp:oparam name="output">
										<dsp:setvalue bean="PaymentGroupFormHandler.ListId"
											paramvalue="order.id" />
										<%--
                We only expect this to have 1 element at [0], but we put this in a ForEach to be safe
                --%>
										<dsp:droplet name="ForEach">
											<dsp:param bean="PaymentGroupFormHandler.CurrentList"
												name="array" />
											<dsp:oparam name="output">
												<dsp:input bean="PaymentGroupFormHandler.ListId"
													beanvalue="PaymentGroupFormHandler.ListId"
													priority="<%=(int) 9%>" type="hidden" />
												<dsp:input
													bean="PaymentGroupFormHandler.CurrentList[param:index].paymentMethod"
													paramvalue="key" type="radio" />
												<dsp:valueof param="key" />
												<br>
											</dsp:oparam>
										</dsp:droplet>
									</dsp:oparam>
								</dsp:droplet></td>
							</tr>

							<tr>
								<td><dsp:img src="../images/d.gif" /></td>
							</tr>

							<dsp:droplet name="ForEach">
								<dsp:param name="array" param="paymentGroups" />
								<dsp:oparam name="output">
									<dsp:droplet name="Switch">
										<dsp:param name="value" param="count" />
										<dsp:oparam name="2">
											<tr valign=top>
												<td align=right><span class=smallb>Multiple
												payment methods</span></td>
												<td><span class=smallb> <dsp:a
													href="payment_methods.jsp?link=split_payment_order.jsp">Split order by dollar amount</dsp:a><br>
												<dsp:a href="payment_methods.jsp?link=split_payment.jsp">Split order by line item</dsp:a><br>
												</span></td>
											</tr>
										</dsp:oparam>
									</dsp:droplet>
								</dsp:oparam>
							</dsp:droplet>

							<tr>
								<td></td>
								<td colspan=2><br>
								<dsp:input
									bean="PaymentGroupFormHandler.applyPaymentGroupsSuccessURL"
									type="hidden" value="IsEmptyCostCenters.jsp?link=billing.jsp" />
								<dsp:input
									bean="PaymentGroupFormHandler.applyPaymentGroupsErrorURL"
									type="hidden" value="billing.jsp?init=true" /> <dsp:input
									bean="PaymentGroupFormHandler.applyPaymentGroups" type="submit"
									value="Continue" /></td>
							</tr>
						</table>
					</dsp:form></td>
				</tr>
			</table>

		</dsp:oparam>
	</dsp:droplet>
</dsp:page>
<%-- @version $Id: //product/B2BCommerce/version/9.0/release/MotorpriseJSP/j2ee-apps/motorprise/web-app/en/checkout/billing_cc.jsp#1 $$Change: 508164 $--%>
