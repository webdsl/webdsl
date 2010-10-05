package webdsl;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

public class ScheduleRefreshTask extends Task {
    public void execute() throws BuildException {
        System.out.println("dummy task for command-line builds");
    }
}
