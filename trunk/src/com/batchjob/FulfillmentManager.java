package com.batchjob;

import java.util.List;

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
		processOrders();
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
}
