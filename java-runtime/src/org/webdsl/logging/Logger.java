package org.webdsl.logging;

public class Logger {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(org.webdsl.logging.Logger.class);

    public static final void info(Object message){
        logger.info(message);
    }

    public static final void warn(Object message){
        logger.warn("WARN  " + message);
    }

    public static final void debug(Object message){
        logger.debug(message);
    }

    public static final void error(Object message, Throwable t){
        logger.error("ERROR " + message, t);
    }

    public static final void error(Object message){
        logger.error("ERROR " + message);
    }

    public static final void error(Throwable t){
        logger.error("ERROR ", t);
    }

    public static final void trace(Object message){
        logger.trace(message);
    }

    public static final void fatal(Object message){
        logger.fatal(message);
    }

    public static final void fatal(Object message, Throwable t){
        logger.error("FATAL " + message, t);
    }

    public static final void fatal(Throwable t){
        logger.error("FATAL ", t);
    }
}
