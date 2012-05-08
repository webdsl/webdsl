package org.webdsl.ant;

import java.io.File;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;

/**
 *  Get timestamp of application.ini
 * 
 *  Previous inline Javascript implementation:
    <script language="javascript">
      <![CDATA[
        importClass(java.io.File);
        var currentdir = project.getProperty("currentdir");
        var f = new File(currentdir+"/application.ini");
        var datetime = f.lastModified();
        project.setProperty("current.application.ini.timestamp",datetime.toString());
      ]]>
    </script>
 */
public class TaskApplicationIniTimestamp  extends Task {
    public void execute() {
        Project project = Project.getProject(this);
        String currentdir = project.getProperty("currentdir");
        File f = new File(currentdir+"/application.ini");
        Long datetime = f.lastModified();
        project.setProperty("current.application.ini.timestamp",datetime.toString());
    }
}
