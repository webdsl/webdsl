package org.webdsl.ant;

import java.util.regex.Pattern;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Echo;
/**
 *  Tokenize buildoptions
 * 
 *  Previous inline Javascript implementation:
    <!-- tokenize the buildoptions -->
    <script language="javascript"> <![CDATA[
      importClass(java.util.regex.Pattern);
      importClass(java.util.regex.Matcher);
    
      buildoptions = project.getProperty("buildoptions");
    
      p = Pattern.compile("\\s");
      commands = p.split(buildoptions);
      
      for(i=0; i<commands.length; i++){
        project.setProperty("command"+i,commands[i])
        echo = project.createTask("echo");
        echo.setMessage("command"+i+": "+commands[i]);
        echo.perform(); 	
      }
      
      project.setProperty("numberofcommands",commands.length)
    ]]></script>
 */
public class TaskBuildOptions  extends Task {
    public void execute() {
        Project project = Project.getProject(this);
        String buildoptions = project.getProperty("buildoptions");
        Pattern p = Pattern.compile("\\s");
        String[] commands = p.split(buildoptions);
        for(int i=0; i<commands.length; i++){
            project.setProperty("command"+i,commands[i]);
            Echo echo = (Echo) project.createTask("echo");
            echo.setMessage("command"+i+": "+commands[i]);
            echo.perform(); 	
        }
        project.setProperty("numberofcommands",""+commands.length);
    }
}
