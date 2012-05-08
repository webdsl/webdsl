package org.webdsl.ant;

import java.util.UUID;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;

/**
 *  Get a new UUID and put it into "build-id" property
 * 
 *  Previous inline Javascript implementation:
    <script language="javascript">
      <![CDATA[
        importClass(java.util.UUID);
        var id = UUID.randomUUID();
        project.setProperty("build-id",id.toString());
      ]]>
    </script>
 */
public class TaskGenerateUuid  extends Task {
    public void execute() {
        Project project = Project.getProject(this);
        UUID id = UUID.randomUUID();
        project.setProperty("build-id",id.toString());
    }
}
