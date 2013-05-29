/**
 * 
 */
package com.webservices;

import atg.nucleus.GenericService;

/**
 * @author Tuhin
 * 
 */
public class MyWebService extends GenericService {
	public boolean isCreditCardValid(String creditCardNumber) {
		if (null != creditCardNumber) {
			if (creditCardNumber.length() == 16) {
				try {
					if (Long.parseLong(creditCardNumber) > 0) {
						return true;
					}
				} catch (Exception e) {
					return false;
				}

			}
		}
		return false;

	}
}
