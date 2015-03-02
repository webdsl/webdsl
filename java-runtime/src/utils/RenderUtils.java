package utils;

import java.io.PrintWriter;

public final class RenderUtils {

	public static final void printPageString(Object toPrint, PrintWriter out, boolean rawoutput){
		String tmpstring;
		try {
			if(org.webdsl.tools.Utils.isNullAutoBox(toPrint)){
				tmpstring = "";
			}
			else{
				tmpstring = rawoutput ? String.valueOf(toPrint) : utils.HTMLFilter.filter(String.valueOf(toPrint));
			}
		}
		catch(NullPointerException npe) {
			tmpstring = "";
		}
		catch(IndexOutOfBoundsException ine){
			tmpstring = "";
		}
		out.print(tmpstring);
	}

}