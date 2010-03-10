package org.webdsl.ant;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintStream;
import java.io.StringReader;
import java.util.Date;
import java.text.DateFormat;

import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.DefaultLogger;
import org.apache.tools.ant.NoBannerLogger;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.util.DateUtils;
import org.apache.tools.ant.util.StringUtils;
import org.apache.tools.ant.util.FileUtils;

public class WebDSLAntLogger extends NoBannerLogger {
   
    public void messageLogged(BuildEvent event) {
    	
    	
    	//------- NoBannerLogger part, prints only a newline when a task with output is encountered
        if (event.getPriority() > msgOutputLevel
                || null == event.getMessage()
                || "".equals(event.getMessage().trim())) {
                    return;
            }

            synchronized (this) {
                if (null != targetName) {
                    //out.println(StringUtils.LINE_SEP + targetName + ":");
                	out.println("");
                    targetName = null;
                }
            }
        
    	//-------
            
            
        //------- DefaultLogger part with left column removed
    	
        int priority = event.getPriority();
        // Filter out messages based on priority
        if (priority <= msgOutputLevel) {

            StringBuffer message = new StringBuffer();
            if (event.getTask() != null && !emacsMode) {
                // Print out the name of the task if we're in one
                /*
                String name = event.getTask().getTaskName();
                String label = "[" + name + "] ";
                int size = LEFT_COLUMN_SIZE - label.length();
                StringBuffer tmp = new StringBuffer();
                for (int i = 0; i < size; i++) {
                    tmp.append(" ");
                }
                tmp.append(label);
                label = tmp.toString();
                */
                String label="";
                BufferedReader r = null;
                try {
                    r = new BufferedReader(
                            new StringReader(event.getMessage()));
                    String line = r.readLine();
                    boolean first = true;
                    do {
                        if (first) {
                            if (line == null) {
                                message.append(label);
                                break;
                            }
                        } else {
                            message.append(StringUtils.LINE_SEP);
                        }
                        first = false;
                        message.append(label).append(line);
                        line = r.readLine();
                    } while (line != null);
                } catch (IOException e) {
                    // shouldn't be possible
                    message.append(label).append(event.getMessage());
                } finally {
                    if (r != null) {
                        FileUtils.close(r);
                    }
                }

            } else {
                //emacs mode or there is no task
                message.append(event.getMessage());
            }
            Throwable ex = event.getException();
            if (Project.MSG_DEBUG <= msgOutputLevel && ex != null) {
                    message.append(StringUtils.getStackTrace(ex));
            }

            String msg = message.toString();
            if (priority != Project.MSG_ERR) {
                printMessage(msg, out, priority);
            } else {
                printMessage(msg, err, priority);
            }
            log(msg);
        }
    }
    
    
    //disabled ant stacktrace
    public void buildFinished(BuildEvent event) {
        Throwable error = event.getException();
        StringBuffer message = new StringBuffer();
        if (error == null) {
            message.append(StringUtils.LINE_SEP);
            message.append(getBuildSuccessfulMessage());
        } else {
            message.append(StringUtils.LINE_SEP);
            message.append(getBuildFailedMessage());
            //message.append(StringUtils.LINE_SEP);
            //throwableMessage(message, error, Project.MSG_VERBOSE <= msgOutputLevel);
        }
        message.append(StringUtils.LINE_SEP);
        message.append("Total time: ");
        message.append(formatTime(System.currentTimeMillis() - startTime2));

        String msg = message.toString();
        if (error == null) {
            printMessage(msg, out, Project.MSG_VERBOSE);
        } else {
            printMessage(msg, err, Project.MSG_ERR);
        }
        log(msg);
    }
    
    //starttime is private...
    private long startTime2 = System.currentTimeMillis();
    public void buildStarted(BuildEvent event) {
        startTime2 = System.currentTimeMillis();
    }


}
