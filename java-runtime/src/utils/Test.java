package utils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.Alert;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
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
    public <T extends Number, Y extends Number> void assertEquals(T o1, Y o2, String message, String loc){
      assertTrue(org.webdsl.tools.Utils.equal(o1,o2), message+"\nassert equals\nfirst value was:  "+o1+"\nsecond value was: "+o2, loc);
    }
    public <T extends Number, Y extends Number> void assertEquals(T o1, Y o2, String loc){
      assertEquals(o1, o2,"",loc);
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
            org.webdsl.logging.Logger.error("EXCEPTION",e);
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
                  org.webdsl.logging.Logger.info(js.executeScript("return __requestcount;"));
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
        //allow some time to load page by webdriver (driver.getPageSource() sometimes returned outdated source)
        sleep(500);
    }
    
    public static Alert getAlert(org.openqa.selenium.WebDriver w){
    	return w.switchTo().alert();
    }

    public static org.openqa.selenium.WebElement getSubmit(org.openqa.selenium.WebDriver d){
    	return d.findElement(org.openqa.selenium.By.cssSelector("*[webdsl-submit-select=\"1\"]"));
    }

    public static List<org.openqa.selenium.WebElement> getSubmits(org.openqa.selenium.WebDriver d){
    	return d.findElements(org.openqa.selenium.By.cssSelector("*[webdsl-submit-select=\"1\"]"));
    }

    //setSelected and toggle are deprecated, now using click: http://code.google.com/p/selenium/issues/detail?id=2391
    public static void click(org.openqa.selenium.WebElement e){
        e.click();
    }

    //getValue is deprecated: http://code.google.com/p/selenium/issues/detail?id=2391
    public static String getValue(org.openqa.selenium.WebElement e){
        return e.getAttribute("value");
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
            htmlunitdriver = new HtmlUnitDriver(com.gargoylesoftware.htmlunit.BrowserVersion.CHROME);
//            htmlunitdriver.setJavascriptEnabled(true);  // TODO: if enabled, clickAndWait() method fails, it cannot look up __requestcount for some reason.
            ThreadLocalWebDriver.set(htmlunitdriver);
        }
        return htmlunitdriver;
    }
    
    public static ChromeDriver chromedriver = null;
    public static ChromeDriver getChromeDriver(){
        if(chromedriver==null){
        	chromedriver = new ChromeDriver();
            ThreadLocalWebDriver.set(chromedriver);
        }
        return chromedriver;
    }
    

    public static void closeDrivers(){
        ThreadLocalWebDriver.set(null);
        if(firefoxdriver!=null){
            firefoxdriver.quit();
        }
        if(htmlunitdriver!=null){
            htmlunitdriver.quit();
        }
        if(chromedriver!=null){
            chromedriver.quit();            
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
          org.webdsl.logging.Logger.error("EXCEPTION",e);
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
    
    private static int screenshotCounter = 1; 
    public static void takeScreenshot(WebDriver driver){
    	File scrFile = ((TakesScreenshot)driver).getScreenshotAs(OutputType.FILE);
    	try {
    		File f = new File("screenshot-"+(screenshotCounter++)+"-"+new Date()+".png");
			FileUtils.copyFile(scrFile, f);
			org.webdsl.logging.Logger.info("screenshot saved "+f.getAbsolutePath());
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
}
