package utils;

import java.util.*;

public class Test {
    
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
       assertTrue(o1.equals(o2),message+"\nfirst value was:  "+o1.toString()+"\nsecond value was: "+o2.toString(), loc);
    }
    
    public void assertEquals(Object o1, Object o2, String loc){
    	assertEquals(o1, o2,"",loc);
    }
    
    public void assertNotSame(Object o1, Object o2, String message, String loc){
    	assertTrue(!o1.equals(o2),message+"\nfirst value was:  "+o1.toString()+"\nsecond value was: "+o2.toString(), loc);
    }
    
    public void assertNotSame(Object o1, Object o2, String loc){
    	assertNotSame(o1, o2,"",loc);
    }
    
}
