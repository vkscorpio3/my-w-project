package commerce.order;

import java.util.List;

import atg.commerce.order.OrderImpl;

public class MyOrderImpl extends OrderImpl {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1553502727603994008L;

	/* (non-Javadoc)
	 * @see atg.commerce.order.OrderImpl#getCommerceItems()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<MyCommerceItem> getCommerceItems() {
		// TODO Auto-generated method stub
		List<MyCommerceItem> list= (List<MyCommerceItem>)super.getCommerceItems();
		return list;
	}
	
	
}
