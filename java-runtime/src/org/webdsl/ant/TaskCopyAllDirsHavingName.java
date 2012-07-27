package org.webdsl.ant;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.FileChannel;
import java.util.ArrayList;

import utils.Warning;
import org.apache.tools.ant.Task;

import com.ibm.icu.impl.CalendarAstronomer.Ecliptic;

/**
 *  copies all sub folders(recursively) of Basedir that equals to parameter name and are not in the folder of Exclude
 */
public class TaskCopyAllDirsHavingName  extends Task {
	private String Basedir;
    private String Name;
    private ArrayList<String> Exclude;
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
		String[] elements = exclude.split(",");
		Exclude = new ArrayList<String>();
		for (String elem : elements){
			Exclude.add(elem.trim());
		}
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
        	Warning.printSmallStackTrace(e);
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
				if(Exclude.contains(file)) {
					continue;
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
        	copyFile(src, dest);
        	numberOfFiles ++;
       }
    }
	
    private static void copyFile(File source, File dest) throws IOException {
        if(!dest.exists()) {
            dest.createNewFile();
        }
        FileChannel in = null;
        FileChannel out = null;
        try {
            in = new FileInputStream(source).getChannel();
            out = new FileOutputStream(dest).getChannel();
            out.transferFrom(in, 0, in.size());
        }
        finally {
            if(in != null) {
                in.close();
            }
            if(out != null) {
                out.close();
            }
        }
    }

    
}


