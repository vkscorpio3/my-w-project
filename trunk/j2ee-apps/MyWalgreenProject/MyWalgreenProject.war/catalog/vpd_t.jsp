<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ page import="atg.servlet.*"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<dsp:importbean
	bean="/atg/commerce/order/purchase/CartModifierFormHandler" />
<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
<dsp:page>
	<body>
	<center>
	<dsp:droplet name="/atg/commerce/catalog/ProductLookup">
		<dsp:param name="id" param="ID" />
		<dsp:param name="elementName" value="Product" />
		<dsp:oparam name="output">
			<dsp:valueof param="Product.longDescription" />
			<dsp:form action="" method="post">
				<dsp:input bean="CartModifierFormHandler.ProductId"
					paramvalue="Product.repositoryId" type="hidden" />
				<br>
			</dsp:form>

			<dsp:droplet name="/atg/commerce/inventory/InventoryLookup">
				<dsp:param param="Product.childSKUs[0].id" name="itemId" />
				<dsp:param value="true" name="useCache" />
				<dsp:oparam name="output">
									<b>Product Name:</b>
									<dsp:valueof param="Product.displayName" />
										<br>
									<b>Price:</b>
									$<dsp:valueof param="Product.childSKUs[0].listPrice" />
										<br>
									<b>Availability:</b>
									<dsp:valueof param="inventoryInfo.availabilityStatusMsg" />
										<br>
									<b>Inventory Status(qty):</b>
									<dsp:valueof param="inventoryInfo.stockLevel" />
										<br>
				</dsp:oparam>
			</dsp:droplet>
		</dsp:oparam>
	</dsp:droplet>
	</center>
	<dsp:include page="addtocart_fg.jsp">
		<dsp:param name="Prod" param="ID" />
	</dsp:include>
	</body>
</dsp:page>