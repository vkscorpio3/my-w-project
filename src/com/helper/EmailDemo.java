package com.helper;

import java.io.StringWriter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;


import com.bean.OrderBean;
import com.bean.Products;

public class EmailDemo {
	
	public String generateVelocityTemplate(OrderBean order)
	throws Exception {
		/*
		 * first, get and initialize an engine
		 */
		VelocityEngine velocityEngine=new VelocityEngine();
		velocityEngine.init();

		/*
		 * organize our data
		 */
		List<Products> orderedProducts = order.getOrderMap();
		System.out.println(orderedProducts.size());
		Map<String, String> map = null ;
		List<Map<String, String>> products = new ArrayList<Map<String, String>>();
		for (Products product : orderedProducts) {
			map = new HashMap<String, String>();
			map.put("commerceItemId", product.getCommerceItemId());
			map.put("skuId", product.getSkuId());
			map.put("productId", product.getProductId());
			map.put("productName", product.getProductName());
			map.put("quantity", product.getQuantity());
			map.put("listPrice", product.getListPrice());
			map.put("salePrice", product.getSalePrice());
			products.add(map);
		}
		String orderTotal = order.getOrderTotal();
		/*
		 * add that list to a VelocityContext
		 */
		String shippingFee="0";
		if(Integer.parseInt(orderTotal)<25){
			shippingFee="5";
		}
		VelocityContext context=new VelocityContext();
		context.put("orderId", order.getOrderId());
		context.put("products", products);
		context.put("orderTotal", Integer.parseInt(orderTotal));
		context.put("shippingFee", shippingFee);
		context.put("salesTax", 3.15);

		/*
		 * get the Template
		 */

		Template t =null;// velocityEngine.getTemplate("./email/orderPlaced.vm");
		t = velocityEngine.getTemplate("./email/hello.vm");

		/*
		 * now render the template into a Writer, here a StringWriter
		 */

		StringWriter writer = new StringWriter();

		t.merge(context, writer);
		System.out.println(writer.toString());
		
		/*
		 * use the output in the body of your emails
		 */
		return writer.toString();
	}
}