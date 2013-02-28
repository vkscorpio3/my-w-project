<html>
<body style="font-family:verdana">
	<h1 style="color:#e01935; font-family:Arial; font-size:22px; font-weight:normal">
Your order  has been submitted.</h1>
Dear $name,<br>

&#09;Thank you for your recent order. We will notify you by e-mail when your order has shipped, 
<br>at which time your account will be charged. Please save this message for your records.
<br>
<br>
<div>Below is a list of the item(s) in your order. Please review it for accuracy.
<br>These items will be Shipped </div>
<div>
	<tr>
<td colspan="5" style="margin:0; padding-bottom:5px">
<table width="600" cellspacing="0" cellpadding="0" bgcolor="#ffffff" align="left" style="font-family:Arial">
<tbody>
<tr>
<td>
<div style="font-size:12px; font-weight:bold; padding:15px 0 10px 29px; color:#cc0000">
<!-- Start Products -->
Product Order #  $orderId</div>
</td>
</tr>
<tr>
<td colspan="2">
<table width="570" border="0" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td style="padding:0 0 0 29px">

<table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #e5e5e5; font-family:Arial; font-size:12px">
<tbody>
<tr style="background-color:#e5e5e5">
<td width="2%" style="padding:8px 0">&nbsp;</td>
<td width="60%" style="padding:8px 0 8px 5px"><strong>Item Info</strong></td>
<td width="16%" style="padding:8px 0"><strong>Price</strong></td>
<td width="12%" align="left" style="padding:8px 0"><strong>Qty</strong></td>
<td width="15%" align="left" style="padding:8px 0"><strong>Total</strong></td>
<td width="2%" style="padding:8px 0">&nbsp;</td>
</tr>
<!-- Start Product 1  -->
#set( $count = 1 )
#foreach( $product in $products )
<tr>
<td width="2%">&nbsp;</td>
<td style="padding:10px 0px 10px 5px; border-bottom:solid 1px #e5e5e5; font-size:12px; font-weight:bold">
<strong>
<div style="width:150px">$product.productName</div>
</strong></td>
<td valign="top" align="left" style="border-bottom:solid 1px #e5e5e5; padding:10px 0; font-size:12px">
<span style="text-decoration:line-through">$product.listPrice</span></td>
<td valign="top" align="left" style="border-bottom:solid 1px #e5e5e5; padding:10px 0; font-size:12px">
$product.quantity</td>
<td valign="top" align="left" style="border-bottom:solid 1px #e5e5e5; padding:10px 0; font-size:12px; color:#cc0000">
<strong>$product.quantity * $product.listPrice</strong><br>
<!--<strong>You Save:<br>
$3.99</strong>--> </td>
<td width="2%">&nbsp;</td>
</tr>
#set( $count = $count + 1 )
#end
<!-- End Product 1  -->
<!--<tr>
<td width="2%" style="border-top:solid 1px #e5e5e5">&nbsp;</td>
<td colspan="4" style="border-top:solid 1px #e5e5e5; border-bottom:solid 1px #e5e5e5">
<div style="border:solid 0px #ff0000; width:320px; float:left; padding:10px 0px">
<strong>Items arrive in 2-5 business days</strong></div>
<div style="border:solid 0px #ff0000; width:180px; float:left; padding:10px 5px 10px 0px; text-align:right">
<strong>Standard Shipping: FREE</strong></div>
</td>
<td width="2%" style="border-top:solid 1px #e5e5e5">&nbsp;</td>
</tr>
-->
<!-- Start Product 2  -->
<!--<tr>
<td width="2%">&nbsp;</td>
<td style="padding:10px 0px 10px 5px; border-bottom:solid 1px #e5e5e5; font-size:12px; font-weight:bold">
<strong>
<div style="width:150px">Excercise Kennel Pen 42 inch Majestic Pet Products <span style="font-weight:normal">
1.0 ea. </span></div>
</strong></td>
<td valign="top" align="left" style="border-bottom:solid 1px #e5e5e5; padding:10px 0; font-size:12px">
<span style="text-decoration:line-through">$30.00 </span><br>
<span style="color:#cc0000"><strong>2/$25.00 </strong></span></td>
<td valign="top" align="left" style="border-bottom:solid 1px #e5e5e5; padding:10px 0; font-size:12px">
1 </td>
<td valign="top" align="left" style="border-bottom:solid 1px #e5e5e5; padding:10px 0; font-size:12px; color:#cc0000">
<strong>$25.00</strong><br>
<strong>You Save:<br>
$5.00</strong> </td>
<td width="2%">&nbsp;</td>
<td width="2%">&nbsp;</td>
</tr>
--><!-- End Product 2  -->
<!--<tr>
<td width="2%" style="border-top:solid 1px #e5e5e5">&nbsp;</td>
<td colspan="4" style="border-top:solid 1px #e5e5e5; border-bottom:solid 1px #e5e5e5">
<div style="border:solid 0px #ff0000; width:320px; float:left; padding:10px 0px">
<strong>Items arrive in 3-7 business days after processing</strong></div>
<div style="border:solid 0px #ff0000; width:180px; float:left; padding:10px 5px 10px 0px; text-align:right">
<strong>Standard Shipping: FREE</strong></div>
</tr>
-->
<td width="2%" style="border-top:solid 1px #e5e5e5">&nbsp;</td>
</tr>
</tbody>
</table>
</td>
</tr>
</tbody>
</table>
<!-- End Products -->
</td>
</tr>
<tr>
<td style="padding-left:29px">
<table width="541" style="background-color:#d9d9d9">
<tbody>
<tr>
<td width=&quot;90%&quot; style=&quot;padding:5px; text-align:right; font:bold 12px arial&quot;>Item Subtotal:</td>
<td width=&quot;6%&quot; style=&quot;padding:5px; text-align:right; font:bold 12px arial&quot;>$orderTotal</td>
<td width=&quot;5%&quot;>&nbsp;</td>
</tr>
<tr>
<td width=&quot;90%&quot; style=&quot;padding:5px; text-align:right; font:bold 12px arial&quot;>Shipping:</td>
<td width=&quot;6%&quot; style=&quot;padding:5px; text-align:right; font:bold 12px arial&quot;>$shippingFee</td>
<td width=&quot;5%&quot;>&nbsp;</td>
</tr>
<tr>
<td width=&quot;90%&quot; style=&quot;padding:5px; text-align:right; font:bold 12px arial&quot;>Sales Tax:
</td>
<td width=&quot;6%&quot; style=&quot;padding:5px; text-align:right; font:bold 12px arial&quot;>$salesTax </td>
<td width=&quot;5%&quot;>&nbsp;</td>
</tr>
<tr>
<td colspan=&quot;3&quot; align=&quot;right&quot;>
<div style=&quot;border-top:1px solid #666666; width:350px; margin-right:30px&quot;></div>
</td>
</tr>
<tr style=&quot;font-size:18px&quot;>
<td width=&quot;90%&quot; align=&quot;right&quot; style=&quot;padding:10px 3px 10px 10px&quot;>Total: </td>
<td width=&quot;6%&quot; style=&quot;padding:10px; text-align:right; padding-right:0px&quot;>$orderTotal + $salesTax + $shippingFee </td>
<td width=&quot;5%&quot;>&nbsp;</td>
</tr>
</div>
</table>
</body>
<html>

