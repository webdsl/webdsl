package utils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.util.LinkedList;
import java.util.List;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;

public abstract class Test {

    public abstract boolean run();

    public int assertsChecked = 0;
    public int assertsSucceeded = 0;
    public int assertsFailed = 0;
    public List<String> messages = new LinkedList<String>();

    public void assertTrue(boolean b, String s, String loc){
      assertsChecked++;
      if(b){
          assertsSucceeded++;
      }
      else{
          assertsFailed++;
          if(s.length() > 0) {
              messages.add(loc +" assertion failed: "+s);
          }
          else {
              messages.add(loc +" assertion failed.");
          }
      }
    }

    public void assertTrue(boolean b, String loc){
        assertTrue(b,"", loc);
    }

    public void assertEquals(Object o1, Object o2, String message, String loc){
       assertTrue(org.webdsl.tools.Utils.equal(o1,o2),message+"\nassert equals\nfirst value was:  "+o1+"\nsecond value was: "+o2, loc);
    }

    public void assertEquals(Object o1, Object o2, String loc){
        assertEquals(o1, o2,"",loc);
    }

    public void assertNotSame(Object o1, Object o2, String message, String loc){
        assertTrue(!org.webdsl.tools.Utils.equal(o1,o2),message+"\nassert not same\nfirst value was:  "+o1+"\nsecond value was: "+o2, loc);
    }

    public void assertNotSame(Object o1, Object o2, String loc){
        assertNotSame(o1, o2,"",loc);
    }

    public static void sleep(int i){
        try {
            Thread.sleep(i);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void clickAndWait(org.openqa.selenium.WebElement e){
        e.click();
        WebDriver d = ThreadLocalWebDriver.get();
        int tries = 0;
        if(d != null){  //null when webdriver is not initialized with get...Driver() functions below
            try{
                JavascriptExecutor js = (JavascriptExecutor) d;
                while((Long)js.executeScript("return __requestcount;") > 0l){
                  System.out.println(js.executeScript("return __requestcount;"));
                  sleep(100);
                  if(tries++ > 50){ //don't try forever
                    return;
                  }
                }
            }
            catch(java.lang.UnsupportedOperationException u){
              //not every WebDriver can execute Javascript
            }
        }
    }

    public static String runJavaScript(org.openqa.selenium.WebDriver d, String script){
        String result = null;
        if(d != null){  //null when webdriver is not initialized with get...Driver() functions below
            try{
                JavascriptExecutor js = (JavascriptExecutor) d;
                result = (String)js.executeScript(script);
            }
            catch(java.lang.UnsupportedOperationException u){
                //not every WebDriver can execute Javascript
            }
        }
        return result;
    }

    //manage webdrivers

    public static FirefoxDriver firefoxdriver = null;
    public static FirefoxDriver getFirefoxDriver(){
        if(firefoxdriver==null){
            firefoxdriver = new FirefoxDriver();
            ThreadLocalWebDriver.set(firefoxdriver);
        }
        return firefoxdriver;
    }

    public static HtmlUnitDriver htmlunitdriver = null;
    public static HtmlUnitDriver getHtmlUnitDriver(){
        if(htmlunitdriver==null){
            htmlunitdriver = new HtmlUnitDriver(com.gargoylesoftware.htmlunit.BrowserVersion.FIREFOX_3_6);
            //htmlunitdriver.setJavascriptEnabled(true);  // TODO: if enabled, clickAndWait() method fails, it cannot look up __requestcount for some reason.
            ThreadLocalWebDriver.set(htmlunitdriver);
        }
        return htmlunitdriver;
    }

    public static void closeDrivers(){
        ThreadLocalWebDriver.set(null);
        if(firefoxdriver!=null){
            firefoxdriver.close();
        }
        if(htmlunitdriver!=null){
            htmlunitdriver.close();
        }
    }

    // file creation for testing upload

    public static String createTempFile(String s){
        try{
          File f = File.createTempFile("webdsl","tempfile");
          writeStringToFile(s,f);
          return f.getAbsolutePath();
        }
        catch(Exception e){
          e.printStackTrace();
          return "";
        }
    }

    public static void writeStringToFile(String s, File file) throws IOException{
        FileOutputStream in = null;
        try{
            in = new FileOutputStream(file);
            FileChannel fchan = in.getChannel();
            BufferedWriter bf = new BufferedWriter(Channels.newWriter(fchan,"UTF-8"));
            bf.write(s);
            bf.close();
        }
        finally{
            if(in != null){
                in.close();
            }
        }
    }
}
