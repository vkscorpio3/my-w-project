<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
<dsp:importbean bean="/atg/droplet/HtmlEmailSenderDroplet" />
<dsp:page>
<head>
<title>Thank you for shopping with us</title>
<link rel="stylesheet" type="text/css" href="../css/pageDesign.css" />
</head>

	<br>
	<dsp:a href="../home.jsp">Catalog</dsp:a>
&nbsp<dsp:a href="../profile/my_profile.jsp">Profile</dsp:a>
&nbsp<dsp:a href="../cart.jsp">Cart( <dsp:valueof
			bean="/atg/commerce/ShoppingCart.current.TotalCommerceItemCount"></dsp:valueof> )</dsp:a>
	
	<div class="leftNav1">
		<dsp:include page="items_order_summary.jsp"></dsp:include>			
	</div>
	<div class="rightNav1">
		Your Order has been submitted . Order No. #
		<b><dsp:valueof
		bean="/atg/commerce/ShoppingCart.last.id"></dsp:valueof></b>
		<dsp:droplet name="HtmlEmailSenderDroplet">
			<dsp:param name="orderId" bean="/atg/commerce/ShoppingCart.last.id" />
		</dsp:droplet>			
	</div>
	<div class="rightNav2">
		<dsp:include page="ordered_item_price_fg.jsp"></dsp:include>			
	</div>
</dsp:page>
