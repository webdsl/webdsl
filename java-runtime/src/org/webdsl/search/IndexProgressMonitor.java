/*
 * Similar to org.hibernate.search.impl.SimpleIndexingProgressMonitor,
 * except for that it uses direct console to log progress and entity info is added.
 */

package org.webdsl.search;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

import org.hibernate.search.batchindexing.MassIndexerProgressMonitor;


public class IndexProgressMonitor implements MassIndexerProgressMonitor {

	private final AtomicLong documentsDoneCounter = new AtomicLong();
	private final AtomicLong totalCounter = new AtomicLong();
	private volatile long startTime;
	private final int loggingPeriod;
	private final String entity;

	/**
	 * Logs progress of indexing job every <code>loggingPeriod</code>
	 * documents written.
	 * @param loggingPeriod the logging period
	 */
	public IndexProgressMonitor(int loggingPeriod, String entity) {
		this.loggingPeriod = loggingPeriod;
		this.entity = entity;
	}

	public void entitiesLoaded(int size) {
		//not used
	}

	public void documentsAdded(long increment) {
		long current = documentsDoneCounter.addAndGet( increment );
		if ( current == increment ) {
			startTime = System.currentTimeMillis();
		}
		if ( current % getStatusMessagePeriod() == 0 ) {
			printStatusMessage( startTime, totalCounter.get(), current );
		}
	}

	public void documentsBuilt(int number) {
		//not used
	}

	public void addToTotalCount(long count) {
		totalCounter.addAndGet( count );
		System.out.println( "Going to reindex " + count  + " entities" );
	}

	public void indexingCompleted() {
		System.out.println( "Reindexed " + totalCounter.get() + " entities");
	}

	protected int getStatusMessagePeriod() {
		return loggingPeriod;
	}

	protected void printStatusMessage(long starttime, long totalTodoCount, long doneCount) {
		long elapsedMs = System.currentTimeMillis() - starttime ;
		System.out.println( entity + ": " + doneCount + " documents indexed in " + elapsedMs + "ms");
		float estimateSpeed = doneCount * 1000f / elapsedMs;
		float estimatePercentileComplete = doneCount * 100f / totalTodoCount;
		System.out.println( estimateSpeed + " documents/second; progress: " + estimatePercentileComplete + "%" );
	}
}
