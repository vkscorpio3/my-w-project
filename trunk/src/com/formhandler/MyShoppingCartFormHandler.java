/**
 * 
 */
package com.formhandler;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;

import atg.commerce.CommerceException;
import atg.commerce.order.ShoppingCartFormHandler;
import atg.service.pipeline.RunProcessException;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

/**
 * @author Tuhin
 * 
 */
public class MyShoppingCartFormHandler extends ShoppingCartFormHandler {

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * atg.commerce.order.ShoppingCartFormHandler#handleMoveToConfirmation(atg
	 * .servlet.DynamoHttpServletRequest, atg.servlet.DynamoHttpServletResponse)
	 */
	@Override
	public boolean handleMoveToConfirmation(DynamoHttpServletRequest req,
			DynamoHttpServletResponse res) throws ServletException,
			IOException {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("orderId", String.valueOf(req.getAttribute("order_id")));

		try {
			getPipelineManager().runProcess("moveToConfirmation", map);
		} catch (RunProcessException e) {
			try {
				throw new CommerceException(e);
			} catch (CommerceException e1) {
				e1.printStackTrace();
			}
		}
		return super.handleMoveToConfirmation(req, res);
	}

}
