<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>
	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<body>
	<table border="2">
		<col width=400>
		<tr><td colspan="2"><b style="color: gray;">Price Info</b></td></tr>
		<tr valign=top>
			<td align=center>Order Subtotal</td>
			<td align=center><dsp:valueof converter="currency"
				bean="ShoppingCart.last.priceInfo.amount" /></td>
		</tr>
		<tr valign=top>
			<td align=center>Sales tax</td>
			<td align=center><dsp:valueof converter="currency"
				bean="ShoppingCart.last.priceInfo.tax" /></td>
		</tr>
		<tr valign=top>
			<td align=center>Shipping</td>
			<td align=center><dsp:valueof converter="currency"
				bean="ShoppingCart.last.priceInfo.shipping" /></td>
		</tr>
		<tr valign=top>
			<td align=center>Order Total</td>
			<td align=center><b><dsp:valueof converter="currency"
				bean="ShoppingCart.last.priceInfo.total" /></b></td>
		</tr>
	</table>
	</body>
</dsp:page>