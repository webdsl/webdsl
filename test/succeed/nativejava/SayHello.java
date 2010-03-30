package nativejava;

import utils.AbstractPageServlet;

    public class SayHello {
      public static String sayHello(AbstractPageServlet p, String to) {
        return "Hello " + to;
      }
      
      public static String sayHello(AbstractPageServlet p, String from, String to) {
        return "Hello from " + from + " to " + to;
      }
    }
