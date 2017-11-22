package utils;

import org.webdsl.logging.Logger;

public class IncludePaths {
	
	
	private static final String JQUERY_JS_LOCAL = "jquery-1.11.0.min.js";
	private static final String JQUERY_JS_CDN = "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js";
	
	private static final String JQUERYUI_JS_LOCAL = "jquery-ui-1.10.4.min.js";
	private static final String JQUERYUI_JS_CDN = "//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js";
	private static final String JQUERYUI_TOUCH_PUNCH_JS_LOCAL = "jquery.ui.touch-punch-0.2.3.min.js";
	private static final String JQUERYUI_TOUCH_PUNCH_JS_CDN = "https://cdnjs.cloudflare.com/ajax/libs/jqueryui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js";	
	private static final String JQUERYUI_CSS_LOCAL = "jquery-ui-1.10.4.min.css";
	private static final String JQUERYUI_CSS_CDN = "//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css";
	
	private static final String MOMENT_JS_LOCAL = "moment.min.js";
	private static final String FLATPICKR_JS_LOCAL = "flatpickr.min.js";
	private static final String FLATPICKR_CSS_LOCAL = "flatpickr.min.css";
	
	private static String jQueryJSPath = JQUERY_JS_LOCAL;
	
	private static String jQueryUIJSPath = JQUERYUI_JS_LOCAL;
	private static String jQueryUITouchPunchJSPath = JQUERYUI_TOUCH_PUNCH_JS_LOCAL;
	private static String jQueryUICSSPath = JQUERYUI_CSS_LOCAL;
	
	private static String momentJSPath = MOMENT_JS_LOCAL;
	private static String timepickerJSPath = FLATPICKR_JS_LOCAL;
	private static String timepickerCSSPath = FLATPICKR_CSS_LOCAL;
	
	static{
		initialize();
	}
	
	public static String jQueryJS(){
		return jQueryJSPath;
	}
	public static String jQueryUIJS(){
		return jQueryUIJSPath;
	}
  public static String jQueryUITouchPunchJS(){
    return jQueryUITouchPunchJSPath;
  }
	public static String jQueryUICSS(){
		return jQueryUICSSPath;
	}
	public static String momentJS(){
		return momentJSPath;
	}
	public static String timepickerJS(){
		return timepickerJSPath;
	}
	public static String timepickerCSS(){
		return timepickerCSSPath;
	}
	
	public static void initialize(){
		try{
			String url = ThreadLocalServlet.get().getRequest().getRequestURL().toString();
			if( !( url.contains("localhost") || url.contains("127.0.0.1") || url.contains("::1") ) ){
				jQueryJSPath = JQUERY_JS_CDN;
				jQueryUIJSPath = JQUERYUI_JS_CDN;
				jQueryUICSSPath = JQUERYUI_CSS_CDN;
				jQueryUITouchPunchJSPath = JQUERYUI_TOUCH_PUNCH_JS_CDN;
			}
		} catch ( Throwable t){
			Logger.error("Something went wrong setting the include paths for css/js resources, paths will point to web application server, not cdn.", t );
		}
	}
	
}
