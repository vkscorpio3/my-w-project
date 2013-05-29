<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

	<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<body>
	<table border="4" style='table-layout:fixed;'>
	<!-- To fix the table width -->
	<col width=400>
	<thead align="center">
	<dsp:droplet name="ForEach">
		<dsp:param bean="ShoppingCartModifier.order.paymentGroups"
			name="array" />
		<dsp:param name="elementName" value="paymentGroup" />
		<dsp:oparam name="output">
			<dsp:droplet name="Switch">
				<dsp:param name="value" param="paymentGroup.paymentMethod" />
				<dsp:oparam name="creditCard">
					<tr><td>
					<b style="color: gray;">Billing Address</b>
					</td></tr>
					<tr><td>
					<dsp:valueof param="paymentGroup.billingAddress.address1" />,
					<dsp:valueof param="paymentGroup.billingAddress.address2" /><br/>
		            <dsp:valueof param="paymentGroup.billingAddress.city" />,
		   	 		<dsp:valueof param="paymentGroup.billingAddress.state" />-
		    		<dsp:valueof param="paymentGroup.billingAddress.postalCode" /><br/>
		    		<dsp:getvalueof param="paymentGroup.billingAddress.country" id="country" idtype="String">
		    		<% country=country.toUpperCase(); %>
		    		Country :<dsp:valueof value="<%=country %>" />
		    		</dsp:getvalueof>
		    		</td></tr>
					<tr><td>
					<b style="color: gray;">Credit Card</b>
					</td></tr>
					<tr><td>
					Card Type :<dsp:valueof param="paymentGroup.creditCardType" /> <br/>
           			Card No.:  <dsp:valueof converter="creditcard"
						param="paymentGroup.creditCardNumber" /><br/>
           			Exp. Date: <dsp:valueof converter="creditcard"
						param="paymentGroup.expirationMonth" />/
            <dsp:valueof param="paymentGroup.expirationYear" />
					</td></tr>
				</dsp:oparam>
				<dsp:oparam name="giftCertificate">
            Gift Certificate: <dsp:valueof
						param="paymentGroup.giftCertificateNumber" />
					<BR>
				</dsp:oparam>
			</dsp:droplet>
			<!-- End Switch on type of payment group -->

		</dsp:oparam>
		<dsp:oparam name="empty">
          No payment
        </dsp:oparam>
	</dsp:droplet>
	<!-- End ForEach on payment groups -->
	</table>
	</body>
</dsp:page>