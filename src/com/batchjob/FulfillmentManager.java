package com.batchjob;

import java.util.List;

import com.bean.SKUBean;
import com.tool.SearchDBManager;
import com.tool.SkuSetupTool;

import atg.commerce.CommerceException;
import atg.commerce.order.Order;
import atg.commerce.order.OrderManager;
import atg.nucleus.GenericService;
import atg.nucleus.ServiceException;
import atg.repository.MutableRepository;
import atg.repository.MutableRepositoryItem;
import atg.repository.Repository;
import atg.repository.RepositoryException;
import atg.repository.RepositoryItem;
import atg.repository.RepositoryView;
import atg.repository.rql.RqlStatement;
import atg.service.scheduler.Schedulable;
import atg.service.scheduler.Schedule;
import atg.service.scheduler.ScheduledJob;
import atg.service.scheduler.Scheduler;

/**
 * @author Tuhin Chandra
 * 
 */
public class FulfillmentManager extends GenericService implements Schedulable {

	private static final String PAYMENT_GROUP_STATE_SETTLED = "SETTLED";
	private static final String ORDER_STATE_SUBMITTED = "SUBMITTED";
	private static final String ORDER_STATE_PROCESSING = "PROCESSING";
	private static final String SHIPPING_GROUP_STATE_PROCESSING = "DC_PROCESSING";
	private static final String SHIPPING_GROUP_STATE_FAILED = "FAILED";
	private Repository orderRepository;
	private RepositoryView repositoryView;
	RepositoryItem[] repositoryItem;
	SearchDBManager searchDBManager;
	SkuSetupTool skuSetUpTool;
	OrderManager orderManager;
	int count = 0;
	// Scheduler property
	Scheduler scheduler;
	// Schedule property
	Schedule schedule;
	// Start method
	int jobId;

	/**
	 * 
	 * @param skuId
	 * @return
	 * @throws RepositoryException
	 */
	public RepositoryItem[] getOrdersThatHaveStateAsSubmittedOrProcessing(
			String orderState) throws RepositoryException {
		repositoryView = getOrderRepository().getView("order");
		Object[] param = { orderState };
		RqlStatement rqlStatement = null;
		rqlStatement = RqlStatement.parseRqlStatement("state=?0");
		repositoryItem = rqlStatement.executeQuery(repositoryView, param);
		Order order = null;
		for (RepositoryItem item : repositoryItem) {
			try {
				order = orderManager.loadOrder((String) item.getRepositoryId());
				logDebug("XXXFulfillmentManager:order Id: " + order.getId());
			} catch (CommerceException e) {
				logError("Exception Thown at " + getClass().getName()
						+ ".getOrdersThatHaveStateAsSubmittedOrProcessing()", e);
			}
		}
		return repositoryItem;
	}

	public RepositoryItem[] getShippingGroupIdFromOrder(String orderId)
			throws RepositoryException {
		repositoryView = getOrderRepository().getView("shippingGroup");
		Object[] param = { orderId };
		RqlStatement rqlStatement = null;
		rqlStatement = RqlStatement.parseRqlStatement("order=?0");

		repositoryItem = rqlStatement.executeQuery(repositoryView, param);
		return repositoryItem;
	}

	public RepositoryItem[] getPaymentGroupIdFromOrder(String orderId)
			throws RepositoryException {
		repositoryView = getOrderRepository().getView("paymentGroup");
		Object[] param = { orderId };
		RqlStatement rqlStatement = null;
		rqlStatement = RqlStatement.parseRqlStatement("order=?0");

		repositoryItem = rqlStatement.executeQuery(repositoryView, param);
		return repositoryItem;
	}

	public void doJob() {
//		populateSKUDetails();
		processOrders();
	}

	public void populateSKUDetails() {
		try {
			RepositoryItem[] skus = searchDBManager.getSkuDetails("ALL");
			for (RepositoryItem sku : skus) {
				String skuId = String.valueOf(sku.getRepositoryId());
				Integer intPartOfskuId = Integer.parseInt(skuId.substring(skuId
						.lastIndexOf("u") + 1, skuId.length()));
				logDebug("[SKU_ID]"+skuId+":isUpdated ? "+skuSetUpTool
						.updateSKUPropertyAddedManually(sku, getRandomizedSKUBean(
								skuId, intPartOfskuId)));

			}
		} catch (RepositoryException e) {
			logError("Exception While Retieving SKU ", e);
		}
	}

	/**
	 * SkuID is the integer part of sku i.e if sku is sku12345 then skuId is
	 * 1234
	 * 
	 * @param sku
	 * @param skuId
	 * @return
	 */
	private SKUBean getRandomizedSKUBean(String sku, Integer skuId) {
		SKUBean skuBean = new SKUBean();
		skuBean.setSkuId(sku);
		if (skuId % 100 == 0) {
			skuBean.setActivated("false");
		} else {
			skuBean.setActivated("true");
		}
		switch (skuId % 16) {
		case 0:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web and Store");
			skuBean.setFulfillerType("DC");
			skuBean.setShippingChargeCode("Free");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("true");
			break;
		case 1:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web Pickup and Store");
			skuBean.setFulfillerType("PSC");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 2:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web and Store");
			skuBean.setFulfillerType("Electronics");
			skuBean.setShippingChargeCode("Free");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("true");
			break;
		case 3:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web Pickup and Store");
			skuBean.setFulfillerType("CH");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 4:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web Pickup and Store");
			skuBean.setFulfillerType("DC");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 5:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web and Store");
			skuBean.setFulfillerType("PSC");
			skuBean.setShippingChargeCode("Free");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("true");
			break;
		case 6:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web Pickup and Store");
			skuBean.setFulfillerType("Electronics");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 7:
			skuBean.setSddEnabled("true");
			skuBean.setWebExclusive("Web and Store");
			skuBean.setFulfillerType("CH");
			skuBean.setShippingChargeCode("Free");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("true");
			break;
		case 8:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Store Only");
			skuBean.setFulfillerType("DC");
			skuBean.setShippingChargeCode("Free");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("true");
			break;
		case 9:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Store Only");
			skuBean.setFulfillerType("PSC");
			skuBean.setShippingChargeCode("Free");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 10:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Store Only");
			skuBean.setFulfillerType("Electronics");
			skuBean.setShippingChargeCode("Free");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("true");
			break;
		case 11:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Store Only");
			skuBean.setFulfillerType("CH");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 12:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Web Only");
			skuBean.setFulfillerType("DC");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 13:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Web Only");
			skuBean.setFulfillerType("PSC");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("false");
			break;
		case 14:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Web Only");
			skuBean.setFulfillerType("Electronics");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("true");
			skuBean.setLoyaltyRedeemable("true");
			break;
		case 15:
			skuBean.setSddEnabled("false");
			skuBean.setWebExclusive("Web Only");
			skuBean.setFulfillerType("CH");
			skuBean.setShippingChargeCode("Standard");
			skuBean.setLoyaltyEligible("false");
			skuBean.setLoyaltyRedeemable("true");
			break;
		}
		return skuBean;

	}

	@SuppressWarnings("unchecked")
	private void processOrders() {
		try {
			RepositoryItem[] orders = getOrdersThatHaveStateAsSubmittedOrProcessing(ORDER_STATE_SUBMITTED);
			if (null != orders) {
				for (RepositoryItem repoItem : orders) {
					logDebug("[SUBMITTED] Orders:" + repoItem.getRepositoryId());
					updateOrderStateToProcessing(repoItem.getRepositoryId());
					for (RepositoryItem item : getShippingGroupIdFromOrder(repoItem
							.getRepositoryId())) {
						updateShippingGroupStateToProcessing(item
								.getRepositoryId());
					}
					for (RepositoryItem item : getPaymentGroupIdFromOrder(repoItem
							.getRepositoryId())) {
						updatePaymentGroupStateToAuthorized(item
								.getRepositoryId());
					}

				}
			}
			orders = getOrdersThatHaveStateAsSubmittedOrProcessing(ORDER_STATE_PROCESSING);
			if (null != orders) {
				logDebug(++count + "[COUNT]");
				for (RepositoryItem repoItem : orders) {
					logDebug("[PROCESSED] Orders:" + repoItem.getRepositoryId());
					logDebug("[PROCESSED] Orders:"
							+ ((RepositoryItem) repoItem
									.getPropertyValue("priceInfo"))
									.getRepositoryId());

					List<RepositoryItem> listCommerceItem = (List<RepositoryItem>) repoItem
							.getPropertyValue("commerceItems");
					for (RepositoryItem cItem : listCommerceItem) {
						logDebug("[Commerce Item Id]" + cItem.getRepositoryId());
						logDebug("[SKU ID]"
								+ cItem.getPropertyValue("catalogRefId"));
						logDebug("[productId]"
								+ cItem.getPropertyValue("productId"));
						logDebug("[quantity]"
								+ cItem.getPropertyValue("quantity"));
						logDebug("[Price]"
								+ ((RepositoryItem) cItem
										.getPropertyValue("priceInfo"))
										.getPropertyValue("listPrice"));
					}
					logDebug("[PROCESSED] Orders:"
							+ ((RepositoryItem) repoItem
									.getPropertyValue("priceInfo"))
									.getPropertyValue("amount"));

					/*
					 * for (RepositoryItem item :
					 * getShippingGroupIdFromOrder(repoItem .getRepositoryId()))
					 * { updateShippingGroupStateToProcessing(item
					 * .getRepositoryId()); } for (RepositoryItem item :
					 * getPaymentGroupIdFromOrder(repoItem .getRepositoryId()))
					 * { updatePaymentGroupStateToAuthorized(item
					 * .getRepositoryId()); }
					 */

					/*
					 * item.setCommerceItemId(repoItem.getPropertyValue(
					 * "commerceItemId").toString());
					 * item.setPrice(Double.parseDouble(repoItem
					 * .getPropertyValue("listPrice").toString()));
					 */

				}
			}
		} catch (RepositoryException e) {
			logError("[ERROR]FulfillmentManager:processOrders()   :" + e);

		}
	}

	private void updateOrderStateToProcessing(String orderId) {
		try {
			MutableRepository mutableRepository = (MutableRepository) getOrderRepository();
			MutableRepositoryItem mutableUser = mutableRepository
					.getItemForUpdate(orderId, "order");
			mutableUser.setPropertyValue("state", ORDER_STATE_PROCESSING);
			mutableRepository.updateItem(mutableUser);
			logDebug("FOr Order #" + orderId + " - New State="
					+ ORDER_STATE_PROCESSING);
		} catch (Exception e) {
			logError("[ERROR]updateOrderStateToProcessing():" + e);
		}
	}

	private void updateShippingGroupStateToProcessing(String shippingGroupId) {
		try {
			MutableRepository mutableRepository = (MutableRepository) getOrderRepository();
			MutableRepositoryItem mutableShippingGroup = mutableRepository
					.getItemForUpdate(shippingGroupId, "shippingGroup");
			try {
				mutableShippingGroup.setPropertyValue("state",
						SHIPPING_GROUP_STATE_PROCESSING);
			} catch (Exception e) {
				mutableShippingGroup.setPropertyValue("state",
						SHIPPING_GROUP_STATE_FAILED);
			}

			mutableRepository.updateItem(mutableShippingGroup);
			logDebug("FOr Shipping Group Id #" + shippingGroupId
					+ " - New Shipping Group State="
					+ SHIPPING_GROUP_STATE_PROCESSING);
		} catch (Exception e) {
			logError("[ERROR]updateShippingGroupStateToProcessing():" + e);
		}
	}

	private void updatePaymentGroupStateToAuthorized(String paymentGroupId) {
		try {
			MutableRepository mutableRepository = (MutableRepository) getOrderRepository();
			MutableRepositoryItem mutableShippingGroup = mutableRepository
					.getItemForUpdate(paymentGroupId, "paymentGroup");
			mutableShippingGroup.setPropertyValue("state",
					PAYMENT_GROUP_STATE_SETTLED);
			mutableRepository.updateItem(mutableShippingGroup);
			logDebug("For Payment Group Id #" + paymentGroupId
					+ " - New Shipping Group State="
					+ PAYMENT_GROUP_STATE_SETTLED);
		} catch (Exception e) {
			logError("[ERROR]updatePaymentGroupStateToAuthorized():" + e);
		}
	}

	public Scheduler getScheduler() {
		return scheduler;
	}

	public void setScheduler(Scheduler scheduler) {
		this.scheduler = scheduler;
	}

	public Schedule getSchedule() {
		return schedule;
	}

	public void setSchedule(Schedule schedule) {
		this.schedule = schedule;
	}

	// Schedulable method
	public void performScheduledTask(Scheduler scheduler, ScheduledJob job) {
		doJob();
	}

	@Override
	public void doStartService() throws ServiceException {
		ScheduledJob job = new ScheduledJob("Fulfillment Manager",
				"Do Fulfillment of Orders", getAbsoluteName(), getSchedule(),
				this, ScheduledJob.SCHEDULER_THREAD);
		jobId = getScheduler().addScheduledJob(job);
	}

	// Stop method
	@Override
	public void doStopService() throws ServiceException {
		getScheduler().removeScheduledJob(jobId);
	}

	public Repository getOrderRepository() {
		return orderRepository;
	}

	public void setOrderRepository(Repository orderRepository) {
		this.orderRepository = orderRepository;
	}

	/**
	 * @return the searchDBManager
	 */
	public SearchDBManager getSearchDBManager() {
		return searchDBManager;
	}

	/**
	 * @param searchDBManager
	 *            the searchDBManager to set
	 */
	public void setSearchDBManager(SearchDBManager searchDBManager) {
		this.searchDBManager = searchDBManager;
	}

	/**
	 * @return the skuSetUpTool
	 */
	public SkuSetupTool getSkuSetUpTool() {
		return skuSetUpTool;
	}

	/**
	 * @param skuSetUpTool
	 *            the skuSetUpTool to set
	 */
	public void setSkuSetUpTool(SkuSetupTool skuSetUpTool) {
		this.skuSetUpTool = skuSetUpTool;
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
