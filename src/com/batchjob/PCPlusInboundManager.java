package com.batchjob;

import atg.adapter.gsa.query.Builder;
import atg.nucleus.GenericService;
import atg.nucleus.ServiceException;
import atg.repository.Repository;
import atg.repository.RepositoryException;
import atg.repository.RepositoryItem;
import atg.repository.RepositoryView;
import atg.service.scheduler.Schedulable;
import atg.service.scheduler.Schedule;
import atg.service.scheduler.ScheduledJob;
import atg.service.scheduler.Scheduler;

public class PCPlusInboundManager extends GenericService implements Schedulable {

	private static final String ORDER_STATE_PROCESSING = "PROCESSING";
	private static final String SHIPPING_GROUP_STATE_PROCESSING = "DC_PROCESSING";

	private Repository orderRepository;
	private RepositoryView repositoryView;
	RepositoryItem[] repositoryItem;
	// Scheduler property
	Scheduler scheduler;
	// Schedule property
	Schedule schedule;
	// Start method
	int jobId;

	public void doJob() {
		processOrders();
	}

	private void processOrders() {
		try {
			RepositoryItem[] orders = getOrders(ORDER_STATE_PROCESSING,SHIPPING_GROUP_STATE_PROCESSING);
			if (null != orders) {
				for(RepositoryItem repoItem:orders){
					logDebug("Order Id:"+repoItem.getRepositoryId());
				}
			}
		} catch (RepositoryException e) {
			logError("[ERROR]PCPlusInboundManager:processOrders()   :" + e);

		}
	}

	private RepositoryItem[] getOrders(String orderState,String shipGroupState)
			throws RepositoryException {
		repositoryView = getOrderRepository().getView("order");
		Object[] param = { orderState,shipGroupState};
		Builder builder = (Builder)repositoryView.getQueryBuilder();
		String str = "SELECT * FROM dcspp_order WHERE state=? AND order_id in" +
				"(select order_ref from dcspp_ship_group where " +
				"state=?)";
		repositoryItem =
			repositoryView.executeQuery (builder.createSqlPassthroughQuery(str, param));

		return repositoryItem;
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
		ScheduledJob job = new ScheduledJob("PCPlusInboundManager",
				"Send Orders to PC+", getAbsoluteName(), getSchedule(), this,
				ScheduledJob.SCHEDULER_THREAD);
		jobId = getScheduler().addScheduledJob(job);
	}

	// Stop method
	@Override
	public void doStopService() throws ServiceException {
		getScheduler().removeScheduledJob(jobId);
	}

	/**
	 * @return the orderRepository
	 */
	public Repository getOrderRepository() {
		return orderRepository;
	}

	/**
	 * @param orderRepository
	 *            the orderRepository to set
	 */
	public void setOrderRepository(Repository orderRepository) {
		this.orderRepository = orderRepository;
	}

	/**
	 * @return the repositoryView
	 */
	public RepositoryView getRepositoryView() {
		return repositoryView;
	}

	/**
	 * @param repositoryView
	 *            the repositoryView to set
	 */
	public void setRepositoryView(RepositoryView repositoryView) {
		this.repositoryView = repositoryView;
	}

	/**
	 * @return the repositoryItem
	 */
	public RepositoryItem[] getRepositoryItem() {
		return repositoryItem;
	}

	/**
	 * @param repositoryItem
	 *            the repositoryItem to set
	 */
	public void setRepositoryItem(RepositoryItem[] repositoryItem) {
		this.repositoryItem = repositoryItem;
	}

}
