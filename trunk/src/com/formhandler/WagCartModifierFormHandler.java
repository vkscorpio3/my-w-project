/**
 * 
 */
package com.formhandler;

import java.io.IOException;

import javax.servlet.ServletException;

import atg.commerce.order.purchase.CartModifierFormHandler;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

/**
 * @author Tuhin
 * 
 */
public class WagCartModifierFormHandler extends CartModifierFormHandler {

	@Override
	public boolean handleMoveToPurchaseInfoByCommerceId(
			DynamoHttpServletRequest req, DynamoHttpServletResponse resp)
			throws ServletException, IOException {
		return super.handleMoveToPurchaseInfoByCommerceId(req, resp);
	}
}
