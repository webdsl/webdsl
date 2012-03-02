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
import org.apache.log4j.NDC;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.WriterAppender;
import org.apache.log4j.spi.LoggingEvent;

public class NDCAppender extends AppenderSkeleton {
    private Map<String, WriterAppender> appenderMap = new HashMap<String, WriterAppender>();
    private Map<String, StringWriter> writerMap = new HashMap<String, StringWriter>();
    private static NDCAppender instance = null;
    private boolean restoreBind = false;
    private Level restoreBindLevel = null;
    private boolean restoreSQL = false;
    private Level restoreSQLLevel = null;
    private boolean restoreJdbc = false;
    private Level restoreJdbcLevel = null;

    public NDCAppender() {
    	this.layout = new SingleLinePatternLayout("%c|%d{ABSOLUTE}|%m%n");
    	NDCAppender.setInstance(this);
    }

    private synchronized static void setInstance(NDCAppender instance) {
    	if(NDCAppender.instance == null) {
    		NDCAppender.instance = instance;
    	}
    	else {
    		org.apache.log4j.helpers.LogLog.error("Only one NDCAppender allowed");
    	}
    }

    private synchronized static void resetInstance(NDCAppender instance) {
    	if(NDCAppender.instance == instance) {
    		NDCAppender.instance = null;
    	}
    }

    public synchronized static NDCAppender getInstance() {
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
    	if(restoreJdbc) {
    		Logger jdbcLog = LogManager.getLogger(org.hibernate.jdbc.AbstractBatcher.class);
    		if(jdbcLog != null) jdbcLog.setLevel(restoreJdbcLevel);
    		restoreJdbc = false;
    		restoreJdbcLevel = null;
    	}
    }

    public synchronized boolean addNDC(String ndc) {
        if(appenderMap.containsKey(ndc))
        {
            return false;
        }
        StringWriter newWriter = new StringWriter();
        WriterAppender newAppender = new WriterAppender(this.layout, newWriter);

        // If this is the first ndc, then we need to check if log levels are sufficient
        if(appenderMap.isEmpty()) {
        	forceLogLevels();
        }

        appenderMap.put(ndc, newAppender);
        writerMap.put(ndc, newWriter);
        return true;
    }

    public synchronized String getLog() {
        return getLog(NDC.get());
    }
    public synchronized String getLog(String ndc) {
        if(writerMap.containsKey(ndc))
        {
            return writerMap.get(ndc).toString();
        }
        return null;
    }

    public synchronized Iterator<String> ndcIterator() {
        return appenderMap.keySet().iterator();
    }

    public synchronized void removeNDC(String ndc) {
        if(appenderMap.containsKey(ndc))
        {
            appenderMap.get(ndc).close();
            appenderMap.remove(ndc);
            writerMap.remove(ndc);

            // If the last ndc was removed, then we can restore log levels to their original state
            if(appenderMap.isEmpty()) {
            	restoreLogLevels();
            }
        }
    }

    public void append(LoggingEvent event) {
        String ndc = event.getNDC();
        if(appenderMap.containsKey(ndc))
        {
            appenderMap.get(ndc).append(event);
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
        NDCAppender.resetInstance(this);
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
