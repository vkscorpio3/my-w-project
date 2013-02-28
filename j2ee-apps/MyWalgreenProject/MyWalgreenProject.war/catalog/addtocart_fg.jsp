<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ page import="atg.servlet.*"%>
<dsp:importbean
	bean="/atg/commerce/order/purchase/CartModifierFormHandler" />
<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
<dsp:page>
	<%
		DynamoHttpServletRequest drequest = ServletUtil
					.getDynamoRequest(request);
	%>
	<head>
	</head>
	<body>
	<dsp:droplet name="/atg/commerce/catalog/ProductLookup">
		<dsp:param name="id" param="Prod" />
		<dsp:param name="elementName" value="Product" />
		<dsp:oparam name="output">
			<dsp:form action="" method="post">
				<table cellspacing=0 cellpadding=0 border=1 bgcolor="#B0C4DE"
			align="center">
					<tr>
						<td>Select SKU</td>
						<td>Quantity</td>
						<td>Add to Cart</td>
					</tr>
					<tr>

						<td><dsp:select bean="CartModifierFormHandler.catalogRefIds">
							<dsp:droplet name="ForEach">
								<dsp:param param="Product.childSKUs" name="array" />
								<dsp:param value="Sku" name="elementName" />
								<dsp:oparam name="output">
									<dsp:getvalueof id="option" param="Sku.repositoryID"
										idtype="java.lang.String">
										<dsp:option value="<%=option%>" />
									</dsp:getvalueof>
									<dsp:valueof param="Sku.displayName" />
								</dsp:oparam>
							</dsp:droplet>
						</dsp:select> </td>
						<td><dsp:input bean="CartModifierFormHandler.ProductId"
							paramvalue="Product.repositoryId" type="hidden" /> <dsp:input
							bean="CartModifierFormHandler.quantity" size="4" value="1"
							type="text" /></td>
						<td><dsp:input bean="CartModifierFormHandler.addItemToOrder"
							value="Add to Cart" type="submit" /> <dsp:input
							bean="CartModifierFormHandler.addItemToOrderSuccessURL"
							value="../cart.jsp" type="hidden" /></td>
					</tr>
				</table>
			</dsp:form>
		</dsp:oparam>
	</dsp:droplet>
	<!--<dsp:droplet name="/atg/dynamo/droplet/Switch">
		<dsp:param bean="/atg/commerce/ShoppingCart.currentEmpty" name="value" />
		<dsp:oparam name="true">
		</dsp:oparam>
		<dsp:oparam name="false">
			<dsp:droplet name="/atg/dynamo/droplet/Switch">
				<dsp:param name="value"
					bean="/atg/commerce/ShoppingCart.current.TotalCommerceItemCount" />
				<dsp:oparam name="1">
					<dsp:valueof
						bean="/atg/commerce/ShoppingCart.current.TotalCommerceItemCount" /> item
        <dsp:valueof converter="currency"
						bean="/atg/commerce/ShoppingCart.current.priceInfo.amount" />
				</dsp:oparam>
				<dsp:oparam name="default">
					<dsp:valueof
						bean="/atg/commerce/ShoppingCart.current.TotalCommerceItemCount" /> items
	<dsp:valueof converter="currency"
						bean="/atg/commerce/ShoppingCart.current.priceInfo.amount" />
				</dsp:oparam>
			</dsp:droplet>
			<dsp:a href="cart.jsp">view your cart</dsp:a>
		</dsp:oparam>
	</dsp:droplet>
	-->
	</body>
</dsp:page>