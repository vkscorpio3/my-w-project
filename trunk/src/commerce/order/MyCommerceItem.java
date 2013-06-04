package commerce.order;

import atg.commerce.order.CommerceItemImpl;

public class MyCommerceItem extends CommerceItemImpl {
	private static final long serialVersionUID = 3394058537799976752L;
	/**
	 * @return the shippingMethod
	 */
	public String getShippingMethod() {
		return String.valueOf(getPropertyValue("shippingMethod"));
	}
	/**
	 * @param shippingMethod the shippingMethod to set
	 */
	public void setShippingMethod(String shippingMethod) {
		setPropertyValue("shippingMethod", shippingMethod);
	}
	
}
