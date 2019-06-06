package org.webdsl.logging;

import javax.servlet.http.HttpServletRequest;

import utils.AbstractDispatchServletHelper;
import utils.ThreadLocalServlet;

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
        logger.error( addURLSuffix("ERROR " + message), t);
    }

    public static final void error(Object message){
        logger.error( addURLSuffix("ERROR " + message) );
    }

    public static final void error(Throwable t){
        logger.error( addURLSuffix("ERROR "), t);
    }

    public static final void trace(Object message){
        logger.trace(message);
    }

    public static final void fatal(Object message){
        logger.fatal( addURLSuffix( message.toString() ) );
    }

    public static final void fatal(Object message, Throwable t){
        logger.error( addURLSuffix("FATAL " + message), t);
    }

    public static final void fatal(Throwable t){
        logger.error( addURLSuffix("FATAL "), t);
    }
    
    private static String addURLSuffix( String msg ) {
      AbstractDispatchServletHelper dsh = ThreadLocalServlet.get();
      if(dsh != null) {
        HttpServletRequest req = dsh.getRequest();
        if(req != null) {
          return msg + " [" + req.getRequestURL().toString() + "]";
        }
      }
      //else
      return msg;
    }
}
