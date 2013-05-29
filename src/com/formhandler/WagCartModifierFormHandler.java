/**
 * 
 */
package com.formhandler;

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.ServletException;

import atg.commerce.order.purchase.CartModifierFormHandler;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

/**
 * @author Tuhin
 *
 */
public class WagCartModifierFormHandler extends CartModifierFormHandler {

	/* (non-Javadoc)
	 * @see atg.commerce.order.purchase.CartModifierFormHandler#handleMoveToPurchaseInfoByCommerceId(atg.servlet.DynamoHttpServletRequest, atg.servlet.DynamoHttpServletResponse)
	 */
	@Override
	public boolean handleMoveToPurchaseInfoByCommerceId(
			DynamoHttpServletRequest arg0, DynamoHttpServletResponse arg1)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		return super.handleMoveToPurchaseInfoByCommerceId(arg0, arg1);
	}
	public static void main(String[] args) {
		java.util.Date date= new java.util.Date();
		 System.out.println(new Timestamp(date.getTime()));
		 
	}
	
	

}
