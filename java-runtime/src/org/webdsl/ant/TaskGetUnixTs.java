package org.webdsl.ant;

import java.util.Date; 

import org.apache.tools.ant.Project; 
import org.apache.tools.ant.Task; 


/**
 *  Get a new Timestamp and put it into "timestamp.unix" property
 * 
 *  Previous inline Javascript implementation:
 * <taskdef name="get-unix-ts" language="javascript"/>
 *   <![CDATA[
 *     var ts = Math.round(new Date().getTime()/1000.0);
 *     self.getProject().setProperty('timestamp.unix', ts);
 *     ]]>
 *   </taskdef> 
 */
public class TaskGetUnixTs  extends Task {  
    public void execute() {
        Project project = getProject();
        long time = new Date().getTime() / 1000; 
        project.setProperty("timestamp.unix",time + "");
    } 
}  