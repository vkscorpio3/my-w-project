package com.processor;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import atg.commerce.order.Order;
import atg.commerce.order.OrderManager;
import atg.commerce.order.ShippingGroup;
import atg.commerce.order.ShippingGroupManager;
import atg.nucleus.logging.ApplicationLoggingImpl;
import atg.service.pipeline.PipelineProcessor;
import atg.service.pipeline.PipelineResult;

import commerce.order.MyCommerceItem;



public class ProcSplitShippingGroup extends ApplicationLoggingImpl implements PipelineProcessor{
	OrderManager orderManager;
	private int SUCCESS=1;
	
	private int[] retCodes={SUCCESS};
	public int[] getRetCodes() {
		return retCodes;
	}

	@SuppressWarnings("unchecked")
	public int runProcess(Object map, PipelineResult pResult) throws Exception {
		HashMap<String, Object> hashMap=(HashMap<String, Object>)map;
		Order order=(Order)hashMap.get("Order");
		List<MyCommerceItem> listCommereceItem=(List<MyCommerceItem>)order.getCommerceItems();
		Set<String> shipMethodSet=new HashSet<String>();
		for(MyCommerceItem cItem:listCommereceItem){
			shipMethodSet.add(String.valueOf(cItem.getShippingMethod()));
		}
		//Get Default Shipping Group
		List<ShippingGroup> sgList=order.getShippingGroups();
		ShippingGroup defaultShippingGroup=null;
		for(ShippingGroup sg:sgList){
			defaultShippingGroup=sg;
			break;
		}
		logDebug("No. Of RelationShip:"+defaultShippingGroup.getCommerceItemRelationshipCount());
		for(String shipMethod:shipMethodSet){
			// Create the ShippingGroup
			ShippingGroupManager sgManager=orderManager.getShippingGroupManager();
			ShippingGroup shippingGroup = sgManager.createShippingGroup();
			shippingGroup.setShippingMethod(shipMethod);
			// Add the ShippingGroup to the Order
			sgManager.addShippingGroupToOrder(order, shippingGroup);
		}
		
		return SUCCESS;
	}

	/**
	 * @return the orderManager
	 */
	public OrderManager getOrderManager() {
		return orderManager;
	}

	/**
	 * @param orderManager the orderManager to set
	 */
	public void setOrderManager(OrderManager orderManager) {
		this.orderManager = orderManager;
	}

}
