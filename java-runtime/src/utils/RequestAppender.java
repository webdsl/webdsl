package utils;

import java.io.StringWriter;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;
import org.apache.log4j.AppenderSkeleton;
import org.apache.log4j.helpers.PatternConverter;
import org.apache.log4j.helpers.PatternParser;
import org.apache.log4j.Logger;
import org.apache.log4j.NDC;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.WriterAppender;
import org.apache.log4j.spi.LoggingEvent;

public class RequestAppender extends AppenderSkeleton {
    protected Map<String, WriterAppender> appenderMap = new HashMap<String, WriterAppender>();
    protected Map<String, StringWriter> writerMap = new HashMap<String, StringWriter>();
    protected static Map<String, RequestAppender> namedMap = new HashMap<String, RequestAppender>();

    public RequestAppender() {
    	this.layout = new SingleLinePatternLayout("%c|%d{ABSOLUTE}|%X{template}|%m%n");
    }

    public void activateOptions() {
        if(this.name != null)
        {
            RequestAppender.putNamed(this);
        }
    }

    public boolean requiresLayout() {
        return false;
    }


    public static RequestAppender getFromLogger(String name) {
        Logger logger = Logger.getLogger(name);
        if(logger == null) return null;
        Enumeration appenderEnum = logger.getAllAppenders();
        while(appenderEnum.hasMoreElements()) {
            Object appender = appenderEnum.nextElement();
            if (appender instanceof RequestAppender) {
                return (RequestAppender)appender;
            }
        }
        return null;
    }

    protected synchronized static void putNamed(RequestAppender appender) {
        if(namedMap.containsKey(appender.name)) return;
        namedMap.put(appender.name, appender);
    }

    protected synchronized static void removeNamed(String name) {
        namedMap.remove(name);
    }

    public synchronized static RequestAppender getNamed(String name) {
        return namedMap.get(name);
    }

    public synchronized boolean addRequest(String rle) {
        if(appenderMap.containsKey(rle))
        {
            return false;
        }
        StringWriter newWriter = new StringWriter();
        WriterAppender newAppender = new WriterAppender(this.layout, newWriter);
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

        if(this.name != null)
        {
            RequestAppender.removeNamed(this.name);
        }

        Iterator<String> i = appenderMap.keySet().iterator();
        while(i.hasNext()) {
            String ndc = i.next();
            appenderMap.get(ndc).close();
        }
        appenderMap.clear();
        writerMap.clear();
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
