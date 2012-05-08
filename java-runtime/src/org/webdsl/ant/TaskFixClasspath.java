package org.webdsl.ant;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Echo;

/**
 *  Update .classpath in Eclipse project
 * 
 *  Previous inline Javascript implementation:
    <script language="javascript">
      <![CDATA[
        importClass(java.io.File);
        importClass(java.io.BufferedReader);
        importClass(java.io.FileReader);
        importClass(java.io.BufferedWriter);
        importClass(java.io.FileWriter);
        importClass(java.lang.StringBuffer);

        // Access to Ant-Properties by their names
        var currentdir = project.getProperty("currentdir");
        var generatedir = project.getProperty("generate-dir");
        var webcontentdir = project.getProperty("webcontentdir");

      classpathFile = new StringBuffer();
      classpathFile.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
      classpathFile.append("<classpath>\n");
      classpathFile.append("\t<classpathentry kind=\"src\" path=\".servletapp/src-template\"/>\n");
      classpathFile.append("\t<classpathentry kind=\"src\" path=\".servletapp/src-generated\"/>\n");
      classpathFile.append("\t<classpathentry kind=\"src\" path=\"nativejava\"/>\n");
      classpathFile.append("\t<classpathentry kind=\"con\" path=\"org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.6\"/>\n");
      classpathFile.append("\t<classpathentry kind=\"con\" path=\"org.eclipse.jst.j2ee.internal.web.container\"/>\n");
      classpathFile.append("\t<classpathentry kind=\"con\" path=\"org.eclipse.jst.j2ee.internal.module.container\"/>\n");
      classpathFile.append("\t<classpathentry kind=\"output\" path=\""+generatedir+"/WEB-INF/classes\"/>\n"); //must use relative path here

      var filedir = webcontentdir+"/WEB-INF/lib"; //must use absolute path here
      var appdir = new File(filedir);
      echo = project.createTask("echo");
      echo.setMessage(filedir);
      echo.perform();
      var libfiles = appdir.listFiles();
      for ( i = 0 ; i < libfiles.length ; i ++ ) {
      if ( libfiles[i].isFile ( ) ){
        classpathFile.append("\t<classpathentry kind=\"lib\" path=\""+generatedir+"/WEB-INF/lib/"+libfiles[i].getName()+"\"/>\n"); //must use relative path here
        }
        }

      classpathFile.append("</classpath>\n");

      try {
            //write result
            fw = new FileWriter(currentdir+"/.classpath");
            bw = new BufferedWriter(fw);
            bw.write(classpathFile.toString());
            bw.close();
            fw.close();
          } catch (e) {
            echo = project.createTask("echo");
            echo.setMessage(e);
            echo.perform();
          }
      ]]>
    </script>
 */
public class TaskFixClasspath  extends Task {
    public void execute() {
        Project project = Project.getProject(this);

        String currentdir = project.getProperty("currentdir");
        String generatedir = project.getProperty("generate-dir");
        String webcontentdir = project.getProperty("webcontentdir");

        StringBuffer classpathFile = new StringBuffer();
        classpathFile.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        classpathFile.append("<classpath>\n");
        classpathFile.append("\t<classpathentry kind=\"src\" path=\".servletapp/src-template\"/>\n");
        classpathFile.append("\t<classpathentry kind=\"src\" path=\".servletapp/src-generated\"/>\n");
        classpathFile.append("\t<classpathentry kind=\"src\" path=\"nativejava\"/>\n");
        classpathFile.append("\t<classpathentry kind=\"con\" path=\"org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.6\"/>\n");
        classpathFile.append("\t<classpathentry kind=\"con\" path=\"org.eclipse.jst.j2ee.internal.web.container\"/>\n");
        classpathFile.append("\t<classpathentry kind=\"con\" path=\"org.eclipse.jst.j2ee.internal.module.container\"/>\n");
        classpathFile.append("\t<classpathentry kind=\"output\" path=\""+generatedir+"/WEB-INF/classes\"/>\n"); //must use relative path here

        String filedir = webcontentdir+"/WEB-INF/lib"; //must use absolute path here
        File appdir = new File(filedir);
        Echo echo = (Echo) project.createTask("echo");
        echo.setMessage(filedir);
        echo.perform();
        File[] libfiles = appdir.listFiles();
        for (int i = 0 ; i < libfiles.length ; i ++ ) {
            if ( libfiles[i].isFile ( ) ){
                classpathFile.append("\t<classpathentry kind=\"lib\" path=\""+generatedir+"/WEB-INF/lib/"+libfiles[i].getName()+"\"/>\n"); //must use relative path here
            }
        }
        classpathFile.append("</classpath>\n");

        try {
            //write result
            FileWriter fw = new FileWriter(currentdir+"/.classpath");
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write(classpathFile.toString());
            bw.close();
            fw.close();
        } catch (Exception e) {
            Echo ec = (Echo) project.createTask("echo");
            ec.setMessage(e.getMessage());
            ec.perform();
        }
    }
}
