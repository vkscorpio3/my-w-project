<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

	<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty" />
	<body>
	
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
						
						<dsp:droplet name="ForEach">
							<dsp:param name="array"
								param="ShippingGroup.CommerceItemRelationships" />
							<dsp:param name="elementName" value="CiRelationship" />
							<dsp:oparam name="outputStart">
							<table border="4">
							<!-- To fix the table width -->
							<col width=400>
							<tr align="center"><td colspan="3">Shipped Items Details</td></tr>
							<tr>
								<td width="300px">Product Image</td>
								<td width="300px">Items Name</td>
								<td width="100px">Price</td>
								<td width="10px">Quantity</td>
							</tr>
							</dsp:oparam>
							<dsp:oparam name="output">
								<tr>
								<td>
									<dsp:getvalueof id="imgUrl"
											param="CiRelationship.CommerceItem.auxiliaryData.productRef.smallImage.url"
											idtype="java.lang.String">
											<%
												if (null != imgUrl) {
													imgUrl = imgUrl.substring(imgUrl.lastIndexOf("/") + 1);
													imgUrl = imgUrl.substring(imgUrl.indexOf("_") + 1);
												}
											%>
											<dsp:img height="100"
												src="<%="../product_images/"
														+ imgUrl%>" />
										</dsp:getvalueof>
								</td>
								<td>
								<dsp:a href="../displayProdSku.jsp">
									<i>
									<dsp:valueof
										param="CiRelationship.CommerceItem.auxiliaryData.catalogRef.displayName" /></i>
									<dsp:param name="prodId"
										param="CiRelationship.CommerceItem.auxiliaryData.catalogRef.id" />
								</dsp:a>
								</td>
								<td>
								<dsp:droplet name="Switch">
											<dsp:param name="value" param="CiRelationship.CommerceItem.priceInfo.onSale" />
											<dsp:oparam name="false">
												<dsp:valueof converter="currency"
													param="CiRelationship.CommerceItem.priceInfo.listPrice" />

											</dsp:oparam>
											<dsp:oparam name="true">
												<STRIKE><dsp:valueof
													param="CiRelationship.CommerceItem.priceInfo.listPrice" /></STRIKE>
												<br>
												<dsp:valueof converter="currency"
													param="CiRelationship.CommerceItem.priceInfo.salePrice" />
											</dsp:oparam>
										</dsp:droplet>
								</td>
								<td>
								<dsp:valueof param="CiRelationship.Quantity" />
								</td>
								</tr>
							</dsp:oparam>
							<dsp:oparam name="outputEnd">
								</table>
							</dsp:oparam>
						</dsp:droplet>

					</dsp:oparam>
				</dsp:droplet>

			</dsp:oparam>

			<dsp:oparam name="empty">
No items in the cart!
</dsp:oparam>
		</dsp:droplet>
		
		

	</body>
</dsp:page>