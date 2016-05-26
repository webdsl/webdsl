package utils;

public class TemplateContext {

	protected java.util.Deque<String> templateContext = new java.util.ArrayDeque<String>();
	protected java.lang.StringBuilder sb = new java.lang.StringBuilder(512);

	public String getTemplateContextString() {
		return sb.toString();
	}

	public void enterTemplateContext(String s) {
		templateContext.push(s);
		sb.append(s);
	}

	public void leaveTemplateContext() {
		String s1 = templateContext.pop();
		sb.delete(sb.length()-s1.length(), sb.length());
	}

	public void leaveTemplateContextChecked(String s) {
		String s1 = templateContext.pop();
		sb.delete(sb.length() - s1.length(), sb.length());
		if (!s.equals(s1)) {
			leaveTemplateContextChecked(s);
		}
	}

	public void clearTemplateContext(){
		templateContext.clear();
		sb = new java.lang.StringBuilder(512);
	}

	public TemplateContext clone(){
		TemplateContext tc = new TemplateContext();
		tc.templateContext.addAll(templateContext);
		tc.sb = new java.lang.StringBuilder(sb.toString());
		return tc;
	}

}
