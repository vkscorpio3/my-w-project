package com.bean;

import java.util.List;

public class OrderBean {
	String orderId;
	String orderTotal;
	List<Products> orderMap;
	/**
	 * @return the orderId
	 */
	public String getOrderId() {
		return orderId;
	}
	/**
	 * @param orderId the orderId to set
	 */
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	/**
	 * @return the orderTotal
	 */
	public String getOrderTotal() {
		return orderTotal;
	}
	/**
	 * @param orderTotal the orderTotal to set
	 */
	public void setOrderTotal(String orderTotal) {
		this.orderTotal = orderTotal;
	}
	/**
	 * @return the orderMap
	 */
	public List<Products> getOrderMap() {
		return orderMap;
	}
	/**
	 * @param orderMap the orderMap to set
	 */
	public void setOrderMap(List<Products> orderMap) {
		this.orderMap = orderMap;
	}
}
