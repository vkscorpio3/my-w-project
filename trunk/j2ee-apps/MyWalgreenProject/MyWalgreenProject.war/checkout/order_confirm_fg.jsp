<%@ taglib uri="/dspTaglib" prefix="dsp"%>
<dsp:page>

	<dsp:importbean bean="/atg/commerce/order/ShoppingCartModifier" />
	<dsp:importbean bean="/atg/commerce/ShoppingCart" />
	<dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
	<dsp:importbean bean="/atg/dynamo/droplet/Switch" />
	<dsp:importbean bean="/atg/dynamo/droplet/IsEmpty" />
	<dsp:importbean bean="/atg/dynamo/droplet/IsNull" />
	<dsp:importbean bean="/atg/commerce/util/PlaceLookup" />
	<title>Review Order</title>
	<head>
	<style>
div.leftNav1 {
	position: absolute;
	left: 50px;
	top: 100px;
	width: 700px
}
div.rightNav1 {
	position: absolute;
	left: 800px;
	top: 10px;
	width: 400px
}

div.rightNav2 {
	position: absolute;
	left: 800px;
	top: 150px;
	width: 400px
}
div.rightNav3 {
	position: absolute;
	left: 800px;
	top: 340px;
	width: 400px
}
</style>
	</head>

	<p><dsp:form action="">
		<dsp:input bean="ShoppingCartModifier.orderId"
			beanvalue="ShoppingCart.current.Id" type="hidden" />
		<div class="leftNav1">
			<dsp:include page="prod_display_fg.jsp"/>
		</div>
		<div>
		<dsp:input bean="ShoppingCartModifier.moveToOrderCommitSuccessURL"
			value="../checkout/order_summary.jsp" type="hidden" /> <!-- Location to go to on order error -->
		<dsp:input bean="ShoppingCartModifier.moveToOrderCommitErrorURL"
			type="hidden" value="order_confirm.jsp" /> <!-- Go to this URL if user's session expired while he pondered this page -->
		<dsp:input bean="ShoppingCartModifier.sessionExpirationURL"
			type="hidden" value="../../common/SessionExpired.jsp" /> <dsp:input
			bean="ShoppingCartModifier.MoveToOrderCommit" type="submit"
			value="Place my order" />
		
		</div>
		<div class="rightNav1">
			<dsp:include page="item_price_fg.jsp"/>
			
		</div>
		<div class="rightNav2">
			<dsp:include page="shipping_fg.jsp"/>
		</div>
		<div class="rightNav3"><dsp:include page="billing_fg.jsp"/></div>
		<p>&nbsp;<br>
	</dsp:form>
	
</dsp:page>
