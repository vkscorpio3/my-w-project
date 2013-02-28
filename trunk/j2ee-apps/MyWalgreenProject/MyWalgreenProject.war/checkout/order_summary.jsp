<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@page import="atg.servlet.DynamoHttpServletRequest"%>
<%@page import="atg.servlet.ServletUtil"%>
<%@page import="com.tool.SearchDBManager"%>

<%@page import="com.tool.EmailSenderManager"%>
<%@page import="com.bean.OrderBean"%>
<%@page import="com.helper.HtmlEmailSender"%><dsp:importbean
	bean="/atg/droplet/GroupItemsDroplet" />
<dsp:importbean bean="atg/tool/SearchDBManager" />
<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
<dsp:importbean bean="/atg/droplet/HtmlEmailSenderDroplet" />

<dsp:page>
	<br>
	<dsp:a href="../home.jsp">Catalog</dsp:a>
&nbsp<dsp:a href="../profile/my_profile.jsp">Profile</dsp:a>
&nbsp<dsp:a href="../cart.jsp">Cart( <dsp:valueof
			bean="/atg/commerce/ShoppingCart.current.TotalCommerceItemCount"></dsp:valueof> )</dsp:a>
	<br>
	<hr size=0>
	<br>
	<br>
	<br>
	<br>
	<b>Your Order has been submitted . Order No. #<dsp:valueof
		bean="/atg/commerce/ShoppingCart.last.id"></dsp:valueof></b>
	<br>
	<br>

	<table>
		<tr align=left>

			<td><b>Product Name</b></td>
			<td><b>Qty</b></td>
			<td><b>Price</b></td>
		</tr>

		<dsp:droplet name="GroupItemsDroplet">
			<dsp:param name="order" bean="/atg/commerce/ShoppingCart.last" />
			<dsp:oparam name="output">
				<dsp:droplet name="ForEach">
					<dsp:param name="array" param="itemGroups" />
					<dsp:param name="elementName" value="commerceItem" />
					<dsp:param name="indexName" value="index" />
					<dsp:oparam name="outputStart">
						<tr>
							<td colspan=3>
							<hr size=0>
							</td>
						</tr>
					</dsp:oparam>
					<dsp:oparam name="output">

						<tr align=left>
							<td><dsp:valueof
								param="commerceItem.auxiliaryData.catalogRef.displayName" /></td>
							<td><dsp:valueof param="commerceItem.quantity" /></td>
							<td><dsp:valueof
								param="commerceItem.priceInfo.rawTotalPrice" /></td>

						</tr>
					</dsp:oparam>
				</dsp:droplet>

			</dsp:oparam>
		</dsp:droplet>

	</table>

	<table>
		<tr>
			<td colspan=5>
			<hr size=0>
			</td>
		</tr>
		<tr valign=top>
			<td colspan=2></td>
			<td align=right>order subtotal</td>
			<td></td>
			<td align=right><dsp:valueof converter="currency"
				bean="/atg/commerce/ShoppingCart.last.priceInfo.amount" /></td>
		</tr>
		<tr valign=top>
			<td colspan=2></td>
			<td align=right>sales tax</td>
			<td></td>
			<td align=right><dsp:valueof converter="currency"
				bean="/atg/commerce/ShoppingCart.last.priceInfo.tax" /></td>
		</tr>
		<tr valign=top>
			<td colspan=2></td>
			<td align=right>shipping</td>
			<td></td>
			<td align=right><dsp:valueof converter="currency"
				bean="/atg/commerce/ShoppingCart.last.priceInfo.shipping" /></td>
		</tr>
		<tr>
			<td colspan=5>
			<hr size=0>
			</td>
		</tr>
		<tr valign=top>
			<td colspan=2></td>
			<td align=right>order total including discounts</td>
			<td></td>
			<td align=right><b><dsp:valueof converter="currency"
				bean="/atg/commerce/ShoppingCart.last.priceInfo.total" /></b></td>
		</tr>

	</table>
	<dsp:droplet name="HtmlEmailSenderDroplet">
		<dsp:param name="orderId" bean="/atg/commerce/ShoppingCart.last.id"/>
	</dsp:droplet>
</dsp:page>