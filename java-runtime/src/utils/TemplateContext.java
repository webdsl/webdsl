package utils;

public class TemplateContext {

    protected java.util.Deque<String> templateContext = new java.util.ArrayDeque<String>();
    
    public String getTemplateContextString() {
        java.lang.StringBuilder sb = new java.lang.StringBuilder();
        for(String s : templateContext){
            sb.append(s);
        }
        return sb.toString();
    }
    
    public void enterTemplateContext(String s) {
        templateContext.push(s);
    }
    
    public void leaveTemplateContext() {
        templateContext.pop();
    }
    
    //verifies that the correct context was popped
    public void leaveTemplateContextChecked(String s) { 
        String s1 = templateContext.pop();
        if(!s.equals(s1)){
          utils.Warning.warn("wrong templateContext popped, found: "+s1+" expected: "+s);
        }
    }

    public void clearTemplateContext(){
        templateContext.clear();
    }
    
    public TemplateContext clone(){
       TemplateContext tc = new TemplateContext();
       tc.templateContext.addAll(templateContext);
       return tc;
    }
    
}
