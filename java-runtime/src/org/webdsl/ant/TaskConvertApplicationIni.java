package org.webdsl.ant;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Echo;

/**
 *  Convert old style application.ini to new style application.ini
 * 
 *  Previous inline Javascript implementation:
    <!-- convert old style application.ini to new style application.ini -->
    <script language="javascript"> <![CDATA[
      importClass(java.io.File);
      importClass(java.io.BufferedReader);
      importClass(java.io.FileReader);
      importClass(java.io.BufferedWriter);
      importClass(java.io.FileWriter);
      importClass(java.lang.StringBuilder);
      importClass(java.util.regex.Pattern);
      importClass(java.util.regex.Matcher);

      // Access to Ant-Properties by their names
      currentdir = project.getProperty("currentdir");

      newcontents = new StringBuilder();
      p = Pattern.compile("export (.*)=(.*)");
      ptrailingspaces = Pattern.compile("\\s+$");

      try {
        fr = new FileReader(currentdir+"/application.ini");
        br = new BufferedReader(fr);
        while (( line = br.readLine()) != null && line.startsWith("export")){
          echo = project.createTask("echo");
          echo.setMessage("- "+line);
          echo.perform();

          m = p.matcher(line);
          m.find();
          transformedline=m.group(1).toLowerCase()+"="+m.group(2);
          //remove trailing spaces
          mspaces = ptrailingspaces.matcher(transformedline);
          transformedline = mspaces.replaceAll("");
          newcontents.append(transformedline+"\n");

          echo = project.createTask("echo");
          echo.setMessage("+ "+transformedline);
          echo.perform();
        }
        br.close();
        fr.close();

        //write result
        fw = new FileWriter(currentdir+"/application.ini");
        bw = new BufferedWriter(fw);
        bw.write(newcontents.toString());
        bw.close();
        fw.close();
      } catch (e) {
        echo = project.createTask("echo");
        echo.setMessage(e);
        echo.perform();
      }
    ]]></script> 
 */
public class TaskConvertApplicationIni  extends Task {
    
    public void execute() {
        Project project = getProject();

        String currentdir = project.getProperty("currentdir");

        StringBuilder newcontents = new StringBuilder();
        Pattern p = Pattern.compile("export (.*)=(.*)");
        Pattern ptrailingspaces = Pattern.compile("\\s+$");

        try {
          FileReader fr = new FileReader(currentdir+"/application.ini");
          BufferedReader br = new BufferedReader(fr);
          String line;
          while ((line = br.readLine()) != null && line.startsWith("export")){
            Echo echo = (Echo) project.createTask("echo");
            echo.setMessage("- "+line);
            echo.perform();

            Matcher m = p.matcher(line);
            m.find();
            String transformedline=m.group(1).toLowerCase()+"="+m.group(2);
            //remove trailing spaces
            Matcher mspaces = ptrailingspaces.matcher(transformedline);
            transformedline = mspaces.replaceAll("");
            newcontents.append(transformedline+"\n");

            echo.setMessage("+ "+transformedline);
            echo.perform();
          }
          br.close();
          fr.close();

          //write result
          FileWriter fw = new FileWriter(currentdir+"/application.ini");
          BufferedWriter bw = new BufferedWriter(fw);
          bw.write(newcontents.toString());
          bw.close();
          fw.close();
        } catch (Exception e) {
          Echo echo = (Echo) project.createTask("echo");
          echo.setMessage(e.getMessage());
          echo.perform();
        }
    }
    
}
