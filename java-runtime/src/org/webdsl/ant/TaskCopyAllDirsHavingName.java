package org.webdsl.ant;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import utils.Warning;
import org.apache.tools.ant.Task;

/**
 *  copies all sub folders(recursively) of Basedir that equals to parameter name and are not in the folder of Exclude
 */
public class TaskCopyAllDirsHavingName  extends Task {
	private String Basedir;
    private String Name;
    private String Exclude;
    private String To;
    private String nameWindows;
    private String nameUNIX;
    private int numberOfFiles;
    
    public void setBasedir(String basedir) {
		Basedir = basedir;
	}

	public void setName(String name) {
		Name = name;
		nameWindows = name.replace('/', '\\');
		nameUNIX = name.replace('\\', '/');		
	}

	public void setExclude(String exclude) {
		Exclude = exclude;
	}

	public void setTo(String to) {
		To = to;
	}

    public void execute() {
    	numberOfFiles = 0;
        System.out.println(this.toString());
        try {
        	findDirectoryAndCopy(new File(Basedir));
        } catch (Exception e) {
        	printSmallStackTrace(e);
		}
        System.out.println("copied " + numberOfFiles + " from: " + Basedir + " to: " + To + " with dirname: " + Name );
    }

	@Override
	public String toString() {
		return "TaskCopyAllDirsHavingName [Basedir=" + Basedir + ", Name="
				+ Name + ", Exclude=" + Exclude + ", To=" + To + "]";
	}
	
	private void findDirectoryAndCopy(File basedir) throws IOException {
		if(basedir.isDirectory()) {
			for(String file : basedir.list()) {
				File newFile = new File(basedir, file);
				if(newFile.compareTo(new File(Exclude)) == 0) {
					return;
				} 
				else if(newFile.getAbsolutePath().endsWith(nameUNIX) || newFile.getAbsolutePath().endsWith(nameWindows)) {
					copyDirectory(newFile, new File (To));
				} else {
					findDirectoryAndCopy(newFile);
				}
	    	}
		}
	}
    
	private void copyDirectory(File src, File dest) throws IOException {
    	if(src.isDirectory()) {
            if(!dest.exists()) {
        		 dest.mkdir();
        	}
        	
            for(String file : src.list()) {
        		File from = new File(src, file);
        		File to = new File(dest, file);
        		copyDirectory(from, to);
        	}
        } else {
           InputStream filefrom = new FileInputStream(src);
           OutputStream fileto = new FileOutputStream(dest); 
           
           byte[] buffer = new byte[2048];
           int length;
        	        
           while ((length = filefrom.read(buffer)) > 0){
        	   fileto.write(buffer, 0, length);
           }
           numberOfFiles ++;
           filefrom.close();
           fileto.close();
           System.out.println("copied file from: " + src.getAbsolutePath() + " to: " + dest.getAbsolutePath());
        }
    }
    
}
