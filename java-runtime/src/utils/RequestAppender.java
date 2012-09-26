package utils;

import java.io.StringWriter;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;
import org.apache.log4j.AppenderSkeleton;
import org.apache.log4j.helpers.PatternConverter;
import org.apache.log4j.helpers.PatternParser;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.LogManager;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.WriterAppender;
import org.apache.log4j.spi.LoggingEvent;

public class RequestAppender extends AppenderSkeleton {
	private Map<String, WriterAppender> appenderMap = new HashMap<String, WriterAppender>();
	private Map<String, StringWriter> writerMap = new HashMap<String, StringWriter>();
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
    	this.layout = new SingleLinePatternLayout("%c|%d{ABSOLUTE}|%X{template}|%m%n");
    	RequestAppender.setInstance(this);
    }

    private synchronized static void setInstance(RequestAppender instance) {
    	if(RequestAppender.instance == null) {
    		RequestAppender.instance = instance;
    	}
    	else {
    		org.apache.log4j.helpers.LogLog.error("Only one NDCAppender allowed");
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
        if(appenderMap.containsKey(rle))
        {
            return false;
        }
        StringWriter newWriter = new StringWriter();
        WriterAppender newAppender = new WriterAppender(this.layout, newWriter);

        // If this is the first request, then we need to check if log levels are sufficient
        if(appenderMap.isEmpty()) {
        	forceLogLevels();
        }

        appenderMap.put(rle, newAppender);
        writerMap.put(rle, newWriter);
        return true;
    }

    public synchronized String getLog() {
        return getLog((String)org.apache.log4j.MDC.get("request"));
    }
    public synchronized String getLog(String rle) {
        if(writerMap.containsKey(rle))
        {
            return writerMap.get(rle).toString();
        }
        return null;
    }

    public synchronized Iterator<String> ndcIterator() {
        return appenderMap.keySet().iterator();
    }

    public synchronized void removeRequest(String rle) {
        if(appenderMap.containsKey(rle))
        {
            appenderMap.get(rle).close();
            appenderMap.remove(rle);
            writerMap.remove(rle);

            // If the last request was removed, then we can restore log levels to their original state
            if(appenderMap.isEmpty()) {
            	restoreLogLevels();
            }
        }
    }

    public void append(LoggingEvent event) {
        String rle = (String)event.getMDC("request");
        if(appenderMap.containsKey(rle))
        {
            appenderMap.get(rle).append(event);
        }
    }

    public synchronized void close() {
        if (this.closed) {
            return;
        }

        this.closed = true;

        Iterator<String> i = appenderMap.keySet().iterator();
        while(i.hasNext()) {
            String ndc = i.next();
            appenderMap.get(ndc).close();
        }
        appenderMap.clear();
        writerMap.clear();
        restoreLogLevels();
        RequestAppender.resetInstance(this);
    }
    
    class SingleLineMessagePatternConverter extends PatternConverter {
    	public SingleLineMessagePatternConverter() {
    	}

		@Override
		protected String convert(LoggingEvent loggingEvent) {
			String msg = loggingEvent.getRenderedMessage();
			if(msg == null) return "";
    		return msg.replaceAll("\r", "\\r").replaceAll("\n", "\\n");
		}
    }

    class SimpleLinePatternParser extends PatternParser {
		public SimpleLinePatternParser(String pattern) {
			super(pattern);
		}

		protected void finalizeConverter(char c) {
			if(c == 'm') {
				addConverter(new SingleLineMessagePatternConverter());
			}
			else {
				super.finalizeConverter(c);
			}

		}
    }

    class SingleLinePatternLayout extends PatternLayout {
    	public SingleLinePatternLayout() {
    		super();
    	}

    	public SingleLinePatternLayout(String pattern) {
    		super(pattern);
    	}

    	protected PatternParser createPatternParser(String pattern) {
  		  return (PatternParser) new SimpleLinePatternParser(pattern);
  	  	}
    }
}
