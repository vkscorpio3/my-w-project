package com.processor;

import atg.nucleus.logging.ApplicationLoggingImpl;
import atg.service.pipeline.PipelineProcessor;
import atg.service.pipeline.PipelineResult;

public class ProcSplitPaymentGroup extends ApplicationLoggingImpl implements PipelineProcessor{
	private int SUCCESS=1;
	private int[] retCodes={SUCCESS};
	public int[] getRetCodes() {
		return retCodes;
	}

	public int runProcess(Object arg0, PipelineResult arg1) throws Exception {
		return SUCCESS;
	}

}
