<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>
	<dsp:droplet name="/atg/droplet/GroupItemsDroplet">
			<dsp:param name="order" bean="/atg/commerce/ShoppingCart.last" />
			
			<dsp:oparam name="output">
				<dsp:droplet name="/atg/dynamo/droplet/ForEach">
					<dsp:param name="array" param="itemGroups" />
					<dsp:param name="elementName" value="commerceItem" />
					<dsp:param name="indexName" value="index" />
					<dsp:oparam name="outputStart">
						<table border="2">
						<col width=400>
						<tr align="center"><td colspan="4">Ordered Items Details</td></tr>
							<tr>
								<td width="300px">Product Image</td>
								<td width="300px">Item Name</td>
								<td width="100px">Price</td>
								<td width="10px">Quantity</td>
							</tr>
					</dsp:oparam>
					<dsp:oparam name="output">

						<tr align=left>
							<tr>
								<td>
									<dsp:getvalueof id="imgUrl"
											param="commerceItem.auxiliaryData.productRef.smallImage.url"
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
										param="commerceItem.auxiliaryData.catalogRef.displayName" /></i>
									<dsp:param name="prodId"
										param="commerceItem.auxiliaryData.catalogRef.id" />
								</dsp:a>
							<td><dsp:valueof
								param="commerceItem.priceInfo.rawTotalPrice" /></td>
							<td><dsp:valueof param="commerceItem.quantity" /></td>
							

						</tr>
					</dsp:oparam>
					
				</dsp:droplet>
			</dsp:oparam>
			<dsp:oparam name="outputEnd">
						</table>
					</dsp:oparam>
		</dsp:droplet>
</dsp:page>