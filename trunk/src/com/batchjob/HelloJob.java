package com.batchjob;

import atg.nucleus.*;
import atg.service.scheduler.*;

public class HelloJob extends GenericService implements Schedulable {
	public HelloJob() {
	}

	// Scheduler property
	Scheduler scheduler;

	public Scheduler getScheduler() {
		return scheduler;
	}

	public void setScheduler(Scheduler scheduler) {
		this.scheduler = scheduler;
	}

	// Schedule property
	Schedule schedule;

	public Schedule getSchedule() {
		return schedule;
	}

	public void setSchedule(Schedule schedule) {
		this.schedule = schedule;
	}

	// Schedulable method
	public void performScheduledTask(Scheduler scheduler, ScheduledJob job) {
		System.out.println("Hello");
	}

	// Start method
	int jobId;

	public void doStartService() throws ServiceException {
		ScheduledJob job = new ScheduledJob("hello", "Prints Hello",
				getAbsoluteName(), getSchedule(), this,
				ScheduledJob.SCHEDULER_THREAD);
		jobId = getScheduler().addScheduledJob(job);
	}

	// Stop method
	public void doStopService() throws ServiceException {
		getScheduler().removeScheduledJob(jobId);
	}
}