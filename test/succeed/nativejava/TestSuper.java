package nativejava;
import java.util.*;
public abstract class TestSuper{

  public abstract String getProp();

  public static String getStatic(){
    return "static";
  }

  public List<TestSub> returnList(){
    List<TestSub> a = new LinkedList<TestSub>();
    a.add(new TestSub());
    a.add(new TestSub());
    for(TestSub elem : a){
        elem.prop = "esfsfsf";
    }
    return a;
  }
  
  public List<TestSub> returnList2(){
    List<TestSub> a = new LinkedList<TestSub>();
    return a;
  }
  
  public Set<TestSub> returnSet(){
    Set<TestSub> a = new HashSet<TestSub>();
    return a;
  }
  
  public Set<TestSub> returnSet2(){
    Set<TestSub> a = new HashSet<TestSub>();
    return a;
  }
  
}