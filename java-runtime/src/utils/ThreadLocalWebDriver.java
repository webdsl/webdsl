package utils;

import org.openqa.selenium.WebDriver;

public class ThreadLocalWebDriver {

    private static ThreadLocal driver = new ThreadLocal();

    public static WebDriver get() {
        return (WebDriver) driver.get();
    }
    
    public static void set(WebDriver d) {
        driver.set(d);
    }    
}

