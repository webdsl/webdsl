package nativejava;

import utils.PageServlet;

    public class SayHello {
      public static String sayHello(PageServlet p, String to) {
        return "Hello " + to;
      }
      
      public static String sayHello(PageServlet p, String from, String to) {
        return "Hello from " + from + " to " + to;
      }
    }
