package utils;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.ThreadContext;
import org.apache.logging.log4j.core.Appender;
import org.apache.logging.log4j.core.Core;
import org.apache.logging.log4j.core.Filter;
import org.apache.logging.log4j.core.Layout;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.LoggerContext;
import org.apache.logging.log4j.core.appender.AbstractAppender;
import org.apache.logging.log4j.core.config.Configuration;
import org.apache.logging.log4j.core.config.LoggerConfig;
import org.apache.logging.log4j.core.config.Property;
import org.apache.logging.log4j.core.config.plugins.Plugin;
import org.apache.logging.log4j.core.config.plugins.PluginAttribute;
import org.apache.logging.log4j.core.config.plugins.PluginElement;
import org.apache.logging.log4j.core.config.plugins.PluginFactory;
import org.apache.logging.log4j.core.layout.PatternLayout;
import org.apache.logging.log4j.status.StatusLogger;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

@Plugin(
		name = "RequestAppender",
		category = Core.CATEGORY_NAME,
		elementType = Appender.ELEMENT_TYPE
)
public class RequestAppender extends AbstractAppender {
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

	protected RequestAppender(
			final String name,
			final Filter filter,
			final Layout<? extends Serializable> layout,
			final boolean ignoreExceptions,
			final Property[] properties
	) {
	  
		super(name, filter, layout, ignoreExceptions, properties);
		RequestAppender.setInstance(this);
	}

  // Your custom appender needs to declare a factory method
  // annotated with `@PluginFactory`. Log4j will parse the configuration
  // and call this factory method to construct an appender instance with
  // the configured attributes.
  @PluginFactory
  public static RequestAppender createAppender(
          @PluginAttribute("name") String name,
          @PluginElement("Layout") Layout<? extends Serializable> layout,
          @PluginElement("Filter") final Filter filter){
      if (name == null) {
          LOGGER.error("No name provided for RequestAppender");
          return null;
      }
      if (layout == null) {
          layout = PatternLayout.createDefaultLayout();
      }
      return new RequestAppender(name, filter, layout, true, new Property[0]);
  }
	

	private synchronized static void setInstance(RequestAppender instance) {
		if(RequestAppender.instance == null) {
			RequestAppender.instance = instance;
		}
		else {
			StatusLogger.getLogger().error("Only one RequestAppender allowed");
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
		LoggerContext ctx = (LoggerContext) LogManager.getContext(false);
		Configuration config = ctx.getConfiguration();
		Logger bindLog = LogManager.getLogger(org.hibernate.type.descriptor.sql.BasicBinder.class);
		if(bindLog != null && !bindLog.isTraceEnabled()) {
			restoreBindLevel = bindLog.getLevel();
			restoreBind = true;
			setLoggerLevel(config, bindLog.getName(), Level.TRACE);
		}
		Logger sqlLog = LogManager.getLogger("org.hibernate.SQL");
		if(sqlLog != null && !sqlLog.isDebugEnabled()) {
			restoreSQLLevel = sqlLog.getLevel();
			restoreSQL = true;
			setLoggerLevel(config, sqlLog.getName(), Level.DEBUG);
		}
		Logger statLog = LogManager.getLogger(org.hibernate.stat.StatisticsImpl.class);
		if(statLog != null && !statLog.isInfoEnabled()) {
			restoreStatLevel = statLog.getLevel();
			restoreStat = true;
			setLoggerLevel(config, statLog.getName(), Level.INFO);
		}
		Logger loaderLog = LogManager.getLogger(org.hibernate.loader.Loader.class);
		if(loaderLog != null && !loaderLog.isTraceEnabled()) { // Trace for hydrated objects, Debug for result row
			restoreLoaderLevel = loaderLog.getLevel();
			restoreLoader = true;
			setLoggerLevel(config, loaderLog.getName(), Level.TRACE);
		}
		Logger jdbcLog = LogManager.getLogger(org.hibernate.jdbc.AbstractBatcher.class);
		if(jdbcLog != null && !jdbcLog.isDebugEnabled()) {
			restoreJdbcLevel = jdbcLog.getLevel();
			restoreJdbc = true;
			setLoggerLevel(config, jdbcLog.getName(), Level.DEBUG);
		}
		ctx.updateLoggers();
	}

	// We also restore null levels, because null means inherit from parent logger
	private synchronized void restoreLogLevels() {
		LoggerContext ctx = (LoggerContext) LogManager.getContext(false);
		Configuration config = ctx.getConfiguration();
		if(restoreBind) {
			setLoggerLevel(config, org.hibernate.type.descriptor.sql.BasicBinder.class, restoreBindLevel);
			restoreBind = false;
			restoreBindLevel = null;
		}
		if(restoreSQL) {
			setLoggerLevel(config, "org.hibernate.SQL", restoreSQLLevel);
			restoreSQL = false;
			restoreSQLLevel = null;
		}
		if(restoreStat) {
			setLoggerLevel(config, org.hibernate.stat.StatisticsImpl.class, restoreStatLevel);
			restoreStat = false;
			restoreStatLevel = null;
		}
		if(restoreLoader) {
			setLoggerLevel(config, org.hibernate.loader.Loader.class, restoreLoaderLevel);
			restoreLoader = false;
			restoreLoaderLevel = null;
		}
		if(restoreJdbc) {
			setLoggerLevel(config, org.hibernate.jdbc.AbstractBatcher.class, restoreJdbcLevel);
			restoreJdbc = false;
			restoreJdbcLevel = null;
		}
		ctx.updateLoggers();
	}

	private void setLoggerLevel(final Configuration config, final Class<?> clazz, final Level level) {
		setLoggerLevel(config, getLoggerName(clazz), level);
	}
	private void setLoggerLevel(final Configuration config, final String logger, final Level level) {
		LoggerConfig loggerConfig = config.getLoggerConfig(logger);
		if (loggerConfig != null) loggerConfig.setLevel(level);
	}
	private String getLoggerName(final Class<?> clazz) {
		final String canonicalName = clazz.getCanonicalName();
		return canonicalName != null ? canonicalName : clazz.getName();
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
		return getLog(ThreadContext.get("request"));
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

	@Override
	public void append(LogEvent event) {
		String rle = event.getContextData().getValue("request");
		if(logMap.containsKey(rle))
		{
			logMap.get(rle).append(event);
		}
	}
	
  @Override
  public void stop() {
    super.stop();
    logMap.clear();
    restoreLogLevels();
    RequestAppender.resetInstance(this);
  }
}
