package utils;

import org.openqa.selenium.WebDriver;

public class ThreadLocalWebDriver {

    private static ThreadLocal<WebDriver> driver = new ThreadLocal<WebDriver>();

    public static WebDriver get() {
        return driver.get();
    }
    
    public static void set(WebDriver d) {
        driver.set(d);
    }    
}

