package com.processor;

import java.util.HashMap;
import java.util.List;

import atg.commerce.order.CommerceItem;
import atg.commerce.order.OrderImpl;
import atg.commerce.order.ShippingGroup;
import atg.nucleus.logging.ApplicationLoggingImpl;
import atg.service.pipeline.PipelineProcessor;
import atg.service.pipeline.PipelineResult;



public class ProcSplitShippingGroup extends ApplicationLoggingImpl implements PipelineProcessor{
	private int SUCCESS=1;
	private int[] retCodes={SUCCESS};
	public int[] getRetCodes() {
		return retCodes;
	}

	@SuppressWarnings("unchecked")
	public int runProcess(Object map, PipelineResult pResult) throws Exception {
		HashMap<String, Object> hashMap=(HashMap<String, Object>)map;
		OrderImpl order=(OrderImpl)hashMap.get("Order");
		List<CommerceItem> listCommereceItem=(List<CommerceItem>)order.getCommerceItems();
		for(CommerceItem cItem:listCommereceItem){
			logDebug("commerceItem:"+cItem.getId());
			logDebug("Quantity:"+cItem.getQuantity());
		}
		List<ShippingGroup> sgList=order.getShippingGroups();
		for(ShippingGroup sg:sgList){
			logDebug("SG:"+sg.getId()+"  Method:"+sg.getShippingMethod());
		}
		logDebug(""+order.getId());
		return SUCCESS;
	}

}
