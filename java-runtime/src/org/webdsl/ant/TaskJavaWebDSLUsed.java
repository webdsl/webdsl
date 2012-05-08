package org.webdsl.ant;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;

/**
 *  Check for Java build of WebDSL compiler
 * 
 *  Previous inline Javascript implementation:
    <!-- determine if java webdsl is being used -->
    <script language="javascript"> <![CDATA[
      execcommand = project.getProperty("webdslexec");
      if(execcommand.startsWith("java")){
        project.setProperty("using-webdsl-java","true");
        //project.setProperty("webdsl-java-options",execcommand.substring(4,execcommand.length()));
      }
    ]]></script>
 */
public class TaskJavaWebDSLUsed  extends Task {
    
    public void execute() {
        Project project = getProject();
        String execcommand = project.getProperty("webdslexec");
        if(execcommand.startsWith("java")){
          project.setProperty("using-webdsl-java","true");
        }
    }
    
}
