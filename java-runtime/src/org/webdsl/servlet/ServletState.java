package org.webdsl.servlet;

/**
 * This class will hold state information of the web application servlet 
 */
public class ServletState {

	private static boolean initialized = false;
	private static boolean inScheduledTask = false;
	private static String runningTask = "";
	private static boolean isServletDestroying = false;
	
	public static synchronized void setInitialized( boolean isInitialized ){
		initialized = isInitialized;
	}
	
	public static synchronized void servletDestroyStarted(){
		isServletDestroying = true;
	}
	
	//Currently only 1 recurring task runs at the time
	public static synchronized void scheduledTaskStarted( String taskName ){
		runningTask = taskName;
		inScheduledTask = true;
	}
	
	public static synchronized void scheduledTaskEnded(){		
		inScheduledTask = false;
	}
		
	public static synchronized boolean inScheduledTask( ){
		return inScheduledTask;
	}
	
	public static synchronized String scheduledTaskName( ){
		return runningTask;
	}
	
	public static synchronized boolean isServletDestroying( ){
		return isServletDestroying;
	}

}
