package utils;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;
import java.util.ArrayList;
import java.util.List;

import javax.management.InstanceNotFoundException;
import javax.management.MBeanRegistrationException;
import javax.management.MBeanServer;
import javax.management.MalformedObjectNameException;
import javax.management.ObjectName;

import com.browseengine.bobo.jmx.JMXUtil;

public class ThreadManager {
	
	static Thread[] getAllDaemonThreads( ) {
	    final Thread[] allThreads = getAllThreads( );
	    final Thread[] daemons = new Thread[allThreads.length];
	    int nDaemon = 0;
	    for ( Thread thread : allThreads )
	        if ( thread.isDaemon( ) )
	            daemons[nDaemon++] = thread; 
	    return java.util.Arrays.copyOf( daemons, nDaemon );
	}
	
	static Thread[] getAllThreads( ) {
	    final ThreadGroup root = getRootThreadGroup( );
	    final ThreadMXBean thbean = ManagementFactory.getThreadMXBean( );
	    int nAlloc = thbean.getThreadCount( );
	    int n = 0;
	    Thread[] threads;
	    do {
	        nAlloc *= 2;
	        threads = new Thread[ nAlloc ];
	        n = root.enumerate( threads, true );
	    } while ( n == nAlloc );
	    return java.util.Arrays.copyOf( threads, n );
	}
	
	static ThreadGroup rootThreadGroup = null;
	 
	static ThreadGroup getRootThreadGroup( ) {
	    if ( rootThreadGroup != null )
	        return rootThreadGroup;
	    ThreadGroup tg = Thread.currentThread( ).getThreadGroup( );
	    ThreadGroup ptg;
	    while ( (ptg = tg.getParent( )) != null )
	        tg = ptg;
	    return tg;
	}
	
	public static void tryFindAndKillBobobrowseDaemonThread(){
		String threadNameStart= "Thread";
		String classNamePartInStackTrace = "browseengine.bobo";
		Thread[] daemonThreads = getAllDaemonThreads();
		List<Thread> boboThreads = new ArrayList<Thread>();
		for (Thread thread : daemonThreads) {
			if(thread.getName().startsWith( threadNameStart )){
				for (StackTraceElement stackTraceElement : thread.getStackTrace()) {
					if(stackTraceElement.getClassName().contains( classNamePartInStackTrace )){
						boboThreads.add(thread);
					}
				}
			}		
		}
		
		for (Thread thread : boboThreads) {
			org.webdsl.logging.Logger.info("cleanup: stopping bobo-browse thread to prevent permgen leak between deploys: " + thread.getName());
			thread.stop();
		}
		ObjectName mbeanName;
		try {
			MBeanServer mbs = java.lang.management.ManagementFactory.getPlatformMBeanServer();
			String[] mbeans = {"SortCollectorImpl-MemoryManager-Float", "SortCollectorImpl-MemoryManager-Int","DefaultFacetCountCollector-MemoryManager"};
			for (String nameStr : mbeans) {
				mbeanName = new ObjectName(JMXUtil.JMX_DOMAIN, "name",
				          nameStr);
				org.webdsl.logging.Logger.info("Unregistering mbean: " + nameStr);
				if( mbs.isRegistered(mbeanName) ){
					mbs.unregisterMBean(mbeanName);
				}
			}
			
			
		} catch (MalformedObjectNameException e) {
			// TODO Auto-generated catch block
			org.webdsl.logging.Logger.error( e );
		} catch (NullPointerException e) {
			// TODO Auto-generated catch block
			org.webdsl.logging.Logger.error( e );
		} catch (MBeanRegistrationException e) {
			// TODO Auto-generated catch block
			org.webdsl.logging.Logger.error( e );
		} catch (InstanceNotFoundException e) {
			// TODO Auto-generated catch block
			org.webdsl.logging.Logger.error( e );
		}
		
		
		
	}
	
	public static void printDaemonThreads(){
		Thread[] daemonThreads = getAllDaemonThreads();
		for (Thread thread : daemonThreads) {
			org.webdsl.logging.Logger.info("*****Daemon thread: " + thread + " Thread Class: " + thread.getStackTrace());
			StackTraceElement[] stackElems = thread.getStackTrace();
			StringBuilder sb = new StringBuilder();
			
			for (StackTraceElement stackTraceElement : stackElems) {
				sb.append(" - [").append(stackTraceElement.getClassName()).append("#").append(stackTraceElement.getMethodName()).append("]");
			}
			org.webdsl.logging.Logger.info( sb );
		}
	}
}
