<%@ page import="atg.servlet.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ page import="atg.servlet.*"%>
<html>
<dsp:page>
	<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty" />
	<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="description" content="" />
	<meta name="keywords" content="" />
	<title>Product Details</title>
	<link href="http://fonts.googleapis.com/css?family=Oswald"
		rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="style.css" />
	<script type="text/javascript" src="jquery-1.7.1.min.js"></script>

	<script type="text/javascript" src="init.js"></script>
	<script type="text/javascript" src="ajax.js"></script>
	<link rel="stylesheet" type="text/css" href="css/overlay.css" />
	<title>Sku Search Result</title>
	</head>
	<body>
	<div id="wrapper">
	<div id="splash"><img src="images/store.jpg" alt="" /></div>
	<dsp:include page="fg/fg_login_information.jsp" /> <dsp:include
		page="fg_search_box.jsp" /> <dsp:include page="fg/fg_menu.jsp" />
	<center>
	<div id="page"><dsp:importbean bean="/atg/droplet/SearchDroplet" />
	<dsp:importbean
		bean="/atg/commerce/order/purchase/CartModifierFormHandler" /> <dsp:droplet
		name="SearchDroplet">
		<dsp:param name="searchProductValue" param="prodId" />
		<dsp:oparam name="output">
			<dsp:droplet name="IsEmpty">
				<dsp:param name="value" param="droplet_skus" />
				<dsp:oparam name="false">
					<h1>Product Details</h1>
					<table border=1 cellpadding=4 cellspacing=10 width=700
						align="center">
						<tr bgcolor=#DBDBDB>
							<td><b style="color: blue">Product ID</b></td>
							<td><b style="color: blue">Product Name</b></td>
							<td><b style="color: blue">Select Sku</b></td>
							<td><b style="color: blue">Sku Details</b></td>
						</tr>
						<dsp:droplet name="/atg/dynamo/droplet/ForEach">
							<tr>
								<dsp:param name="array" param="droplet_skus" />
								<dsp:param value="product" name="elementName" />
								<dsp:oparam name="output">
									<td><dsp:valueof param="product.id" /></td>
									<td><dsp:valueof param="product.displayName" /></td>

									<td><dsp:form>
										<dsp:select bean="CartModifierFormHandler.catalogRefIds">
											<dsp:droplet name="/atg/dynamo/droplet/ForEach">
												<dsp:param param="product.childSKUs" name="array" />
												<dsp:param value="Sku" name="elementName" />
												<dsp:oparam name="output">
													<dsp:getvalueof id="option" param="Sku.repositoryID"
														idtype="java.lang.String">
														<dsp:option value="<%=option%>" />
													</dsp:getvalueof>
													<dsp:valueof param="Sku.displayName" />
												</dsp:oparam>
											</dsp:droplet>
										</dsp:select>
									</dsp:form></td>

									<td><dsp:droplet name="/atg/dynamo/droplet/ForEach">
										<dsp:param name="array" param="product.childSKUs" />
										<dsp:param value="sku" name="elementName" />
										<dsp:oparam name="output">
											<dsp:valueof param="sku.smallImage" />
											<dsp:a href="displayProdSku.jsp">
												<dsp:param name="skuId" param="sku.id" />
											</dsp:a>

											<table border=1 cellpadding=4 cellspacing=5 align="center"
												width="300">
												<tr>
													<td>Sku Id</td>
													<td><dsp:valueof param="sku.id" /></td>
												</tr>
												<tr>
													<td>Name</td>
													<td><dsp:valueof param="sku.displayName" /></td>
												</tr>
												<tr>
													<td>M.R.P</td>
													<td><dsp:valueof param="sku.listPrice" /></td>
												</tr>
												<dsp:droplet name="/atg/dynamo/droplet/Switch">
													<dsp:param name="value" param="sku.onSale" />
													<dsp:oparam name="false">
													</dsp:oparam>
													<dsp:oparam name="true">
														<tr>
															<td>Sale Price</td>
															<td><dsp:valueof param="sku.salePrice" /></td>
														</tr>
													</dsp:oparam>
												</dsp:droplet>

												<dsp:form action="cart.jsp" formid="cart" method="post">
													<tr>
														<td>Quantity</td>
														<td><dsp:input
															bean="CartModifierFormHandler.quantity" size="2"
															value="1" type="text" name="quantity" /></td>
													</tr>
													<tr>
														<td colspan="2" align="center"><dsp:input
															bean="CartModifierFormHandler.ProductId" type="hidden"
															paramvalue="product.displayName" name="prodName" /> <dsp:input
															bean="CartModifierFormHandler.catalogRefIds"
															type="hidden" paramvalue="sku.displayName" name="skuName" />

														<dsp:input bean="CartModifierFormHandler.catalogRefIds"
															type="hidden" paramvalue="sku.listPrice" name="price" />

														<dsp:input bean="CartModifierFormHandler.ProductId"
															type="hidden" paramvalue="product.id" name="prodId" /> <dsp:input
															bean="CartModifierFormHandler.catalogRefIds"
															type="hidden" paramvalue="sku.id" name="skuId" /> <dsp:input
															bean="CartModifierFormHandler.addItemToOrder"
															value="Add to Cart" type="submit" /></td>

													</tr>
												</dsp:form>
											</table>
											<br>
										</dsp:oparam>
									</dsp:droplet></td>
								</dsp:oparam>
							</tr>
						</dsp:droplet>
					</table>
				</dsp:oparam>
				<dsp:oparam name="true">
					<dsp:droplet name="IsEmpty">
						<dsp:param name="value" param="droplet_sku" />
						<dsp:oparam name="false">
							<h1>Product Details</h1>
							<table border=1 cellpadding=4 cellspacing=10 width=700
								align="center">
								<tr bgcolor=#DBDBDB>
									<td><b style="color: blue">Product ID</b></td>
									<td><b style="color: blue">SKU ID</b></td>
									<td><b style="color: blue">SKU Name</b></td>
									<td><b style="color: blue">Price</b></td>
									<td><b style="color: blue">Quantity</b></td>
								</tr>
								<dsp:droplet name="/atg/dynamo/droplet/ForEach">
									<tr>
										<dsp:param name="array" param="droplet_sku" />
										<dsp:param value="sku" name="elementName" />
										<dsp:oparam name="output">
											<td><dsp:droplet name="/atg/dynamo/droplet/ForEach">
												<dsp:param name="array" param="sku.parentProducts" />
												<dsp:param value="parentProd" name="elementName" />
												<dsp:oparam name="output">
													<dsp:valueof param="parentProd.id"></dsp:valueof>
												</dsp:oparam>
											</dsp:droplet></td>
											<td><dsp:valueof param="sku.id" /></td>
											<td><dsp:valueof param="sku.displayName" /></td>
											<td><dsp:valueof  converter="currency" param="sku.listPrice" /></td>
											<td>
											<table border="1">
												<dsp:form action="cart.jsp" formid="cart" method="post">
													<tr>
														<td>Quantity</td>
														<td><dsp:input
															bean="CartModifierFormHandler.quantity" size="2"
															value="1" type="text" name="quantity" /></td>
														<td colspan="2" align="center"><dsp:input
															bean="CartModifierFormHandler.catalogRefIds"
															type="hidden" paramvalue="sku.displayName" name="skuName" />

														<dsp:input bean="CartModifierFormHandler.catalogRefIds"
															type="hidden" paramvalue="sku.listPrice" name="price" />
															
														<dsp:droplet name="/atg/dynamo/droplet/ForEach">
															<dsp:param name="array" param="sku.parentProducts" />
															<dsp:param value="parentProd" name="elementName" />
															<dsp:oparam name="output">
																<dsp:input bean="CartModifierFormHandler.ProductId"
																	type="hidden" paramvalue="parentProd.id" name="prodId" />
															</dsp:oparam>
														</dsp:droplet> 
														<dsp:input bean="CartModifierFormHandler.catalogRefIds"
															type="hidden" paramvalue="sku.id" name="skuId" /> <dsp:input
															bean="CartModifierFormHandler.addItemToOrder"
															value="Add to Cart" type="submit" /></td>
													</tr>
												</dsp:form>
											</table>
											</td>
										</dsp:oparam>
									</tr>
								</dsp:droplet>
							</table>
						</dsp:oparam>
						<dsp:oparam name="true">
							<h1>No Result found with keyword "<dsp:valueof
								bean="/atg/formhandler/SearchFormHandler.searchText" />"</h1>
						</dsp:oparam>
					</dsp:droplet>
				</dsp:oparam>
			</dsp:droplet>

		</dsp:oparam>
	</dsp:droplet></div>
	</center>
	</div>
	<div class="bgCover">&nbsp;</div>
	<div class="overlayBox">
	<div class="overlayContent"><a href="#" class="closeLink">Close</a>
	<dsp:include page="login.jsp" /></div>
	</div>
	<script type="text/javascript" src="javaScript/overlay.js"></script>

	</body>
</dsp:page>
</html>
