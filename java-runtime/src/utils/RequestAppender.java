package utils;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.log4j.AppenderSkeleton;
import org.apache.log4j.Level;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.apache.log4j.spi.LoggingEvent;

public class RequestAppender extends AppenderSkeleton {
	private Map<String, HibernateLog> logMap = new HashMap<String, HibernateLog>();
	private static RequestAppender instance = null;
    private boolean restoreBind = false;
    private Level restoreBindLevel = null;
    private boolean restoreStat = false;
    private Level restoreStatLevel = null;
    private boolean restoreLoader = false;
    private Level restoreLoaderLevel = null;
    private boolean restoreSQL = false;
    private Level restoreSQLLevel = null;
    private boolean restoreJdbc = false;
    private Level restoreJdbcLevel = null;

    public RequestAppender() {
    	RequestAppender.setInstance(this);
    }

    private synchronized static void setInstance(RequestAppender instance) {
    	if(RequestAppender.instance == null) {
    		RequestAppender.instance = instance;
    	}
    	else {
    		org.apache.log4j.helpers.LogLog.error("Only one RequestAppender allowed");
    	}
    }

    private synchronized static void resetInstance(RequestAppender instance) {
    	if(RequestAppender.instance == instance) {
    		RequestAppender.instance = null;
    	}
    }

    public synchronized static RequestAppender getInstance() {
    	return instance;
    }

    public void activateOptions() {
    }

    public boolean requiresLayout() {
        return false;
    }

    // We use log4j to get the loggers instead of slf4j, because slf4j has no way of changing the log level
    // Log levels can be null, which means inherit from parent logger
    private synchronized void forceLogLevels() {
    	Logger bindLog = LogManager.getLogger(org.hibernate.type.descriptor.sql.BasicBinder.class);
    	if(bindLog != null && !bindLog.isTraceEnabled()) {
    		restoreBindLevel = bindLog.getLevel();
    		restoreBind = true;
    		bindLog.setLevel(Level.TRACE);
    	}
    	Logger sqlLog = LogManager.getLogger("org.hibernate.SQL");
    	if(sqlLog != null && !sqlLog.isDebugEnabled()) {
    		restoreSQLLevel = sqlLog.getLevel();
    		restoreSQL = true;
    		sqlLog.setLevel(Level.DEBUG);
    	}
    	Logger statLog = LogManager.getLogger(org.hibernate.stat.StatisticsImpl.class);
    	if(statLog != null && !statLog.isInfoEnabled()) {
    		restoreStatLevel = statLog.getLevel();
    		restoreStat = true;
    		statLog.setLevel(Level.INFO);
    	}
    	Logger loaderLog = LogManager.getLogger(org.hibernate.loader.Loader.class);
    	if(loaderLog != null && !loaderLog.isTraceEnabled()) { // Trace for hydrated objects, Debug for result row
    		restoreLoaderLevel = loaderLog.getLevel();
    		restoreLoader = true;
    		loaderLog.setLevel(Level.TRACE);
    	}
    	Logger jdbcLog = LogManager.getLogger(org.hibernate.jdbc.AbstractBatcher.class);
    	if(jdbcLog != null && !jdbcLog.isDebugEnabled()) {
    		restoreJdbcLevel = jdbcLog.getLevel();
    		restoreJdbc = true;
    		jdbcLog.setLevel(Level.DEBUG);
    	}
    }

    // We also restore null levels, because null means inherit from parent logger
    private synchronized void restoreLogLevels() {
    	if(restoreBind) {
    		Logger bindLog = LogManager.getLogger(org.hibernate.type.descriptor.sql.BasicBinder.class);
    		if(bindLog != null) bindLog.setLevel(restoreBindLevel);
    		restoreBind = false;
    		restoreBindLevel = null;
    	}
    	if(restoreSQL) {
    		Logger sqlLog = LogManager.getLogger("org.hibernate.SQL");
    		if(sqlLog != null) sqlLog.setLevel(restoreSQLLevel);
    		restoreSQL = false;
    		restoreSQLLevel = null;
    	}
    	if(restoreStat) {
    		Logger statLog = LogManager.getLogger(org.hibernate.stat.StatisticsImpl.class);
    		if(statLog != null) statLog.setLevel(restoreStatLevel);
    		restoreStat = false;
    		restoreStatLevel = null;
    	}
    	if(restoreLoader) {
    		Logger loaderLog = LogManager.getLogger(org.hibernate.loader.Loader.class);
    		if(loaderLog != null) loaderLog.setLevel(restoreLoaderLevel);
    		restoreLoader = false;
    		restoreLoaderLevel = null;
    	}
    	if(restoreJdbc) {
    		Logger jdbcLog = LogManager.getLogger(org.hibernate.jdbc.AbstractBatcher.class);
    		if(jdbcLog != null) jdbcLog.setLevel(restoreJdbcLevel);
    		restoreJdbc = false;
    		restoreJdbcLevel = null;
    	}
    }

    public synchronized boolean addRequest(String rle) {
        if(logMap.containsKey(rle))
        {
            return false;
        }
        HibernateLog log = new HibernateLog();

        // If this is the first request, then we need to check if log levels are sufficient
        if(logMap.isEmpty()) {
        	forceLogLevels();
        }

        logMap.put(rle, log);
        return true;
    }

    public synchronized HibernateLog getLog() {
        return getLog((String)org.apache.log4j.MDC.get("request"));
    }
    public synchronized HibernateLog getLog(String rle) {
        if(logMap.containsKey(rle))
        {
            return logMap.get(rle);
        }
        return null;
    }

    public synchronized Iterator<String> requestIterator() {
        return logMap.keySet().iterator();
    }

    public synchronized void removeRequest(String rle) {
        if(logMap.containsKey(rle))
        {
        	logMap.remove(rle);

            // If the last request was removed, then we can restore log levels to their original state
            if(logMap.isEmpty()) {
            	restoreLogLevels();
            }
        }
    }

    public void append(LoggingEvent event) {
        String rle = (String)event.getMDC("request");
        if(logMap.containsKey(rle))
        {
        	logMap.get(rle).append(event);
        }
    }

    public synchronized void close() {
        if (this.closed) {
            return;
        }

        this.closed = true;

        logMap.clear();
        restoreLogLevels();
        RequestAppender.resetInstance(this);
    }

}
