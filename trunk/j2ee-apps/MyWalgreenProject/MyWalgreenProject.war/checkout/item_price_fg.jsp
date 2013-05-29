<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>
	<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier" />
<body>
<table border="2">
<col width=400>
	<tr><td colspan="2"><b style="color: gray;">Price Info</b></td></tr>
	<tr valign=top>
		<td align=center>Order Subtotal</td>
		<td align=center><dsp:valueof converter="currency"
			bean="ShoppingCartModifier.order.priceInfo.amount" /></td>
	</tr>
	<tr valign=top>
		<td align=center>Sales tax</td>
		<td align=center><dsp:valueof converter="currency"
			bean="ShoppingCartModifier.order.priceInfo.tax" /></td>
	</tr>
	<tr valign=top>
		<td align=center>Shipping</td>
		<td align=center><dsp:valueof converter="currency"
			bean="ShoppingCartModifier.order.priceInfo.shipping" /></td>
	</tr>
	<tr valign=top>
		<td align=center>Order Total</td>
		<td align=center><b><dsp:valueof converter="currency"
			bean="ShoppingCartModifier.order.priceInfo.total" /></b></td>
	</tr>	
</table>
</body>
</dsp:page>