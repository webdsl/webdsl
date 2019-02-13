package utils;

import java.io.PrintWriter;

public final class RenderUtils {

	public static final void printPageString(Object toPrint, PrintWriter out, boolean rawoutput) {
		if (toPrint != null) {
			out.print(rawoutput ? String.valueOf(toPrint) : utils.HTMLFilter.filter(String.valueOf(toPrint)));
		}
	}

}