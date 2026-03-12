import org.spoofax.interpreter.terms.IStrategoTerm;
import org.strategoxt.lang.Context;
import org.strategoxt.lang.StrategoErrorExit;
import org.strategoxt.lang.StrategoExit;

import org.webdsl.webdslc.Main;

public class TestLSP {

	public static void runTests() {
		checkerrors("testapp.app","Template with signature tcallnotdefined() not defined");
		resolve(6, 3, "testapp.app", "At(\"testapp.app\",10,1,10,24)");
		resolve(4, 3, "./imported.app", "At(\"testapp.app\",10,1,10,24)");
		resolve(7, 3, "testapp.app", "At(\"./imported.app\",3,1,5,2)");
		complete(6, 3, "testapp.app", "(\"example(key)\",\"example(key : String)\"),(\"example(num)\",\"example(num : Int)\")");
	}

	public static void resolve(int line, int column, String file, String expected) {
		String[] args = {
			"-i", "testapp.app",
			"--dir", System.getProperty("user.dir"),
			"-line", Integer.toString(line),
			"-column", Integer.toString(column),
			"-file", file
		};
		IStrategoTerm result = context.invokeStrategyCLI(org.webdsl.webdslc.lsp_resolve_cached_0_0.instance, "Main", args);
		if (result != null && result.toString().equals(expected)) {
			System.out.println("resolve successful: " + result);
		} else {
			testsFailed++;
			System.out.println("resolve failed - received: " + result);
			System.out.println("               - expected: " + expected);
		}
	}

	public static void complete(int line, int column, String file, String expected) {
		String[] args = {
			"-i", "testapp.app",
			"--dir", System.getProperty("user.dir"),
			"-line", Integer.toString(line),
			"-column", Integer.toString(column),
			"-file", file
		};
		IStrategoTerm result = context.invokeStrategyCLI(org.webdsl.webdslc.lsp_complete_cached_0_0.instance, "Main", args);
		if (result != null && result.toString().contains(expected)) {
			System.out.println("completion successful: " + expected);
		} else {
			testsFailed++;
			System.out.println("completion failed - received: " + result);
			System.out.println("                  - expected to contain: " + expected);
		}
	}

	public static void checkerrors(String file, String expected) {
		String[] webdslArgs = {
			"-i", "testapp.app",
			"--dir", System.getProperty("user.dir")
		};
		IStrategoTerm result = context.invokeStrategyCLI(org.webdsl.webdslc.lsp_main_0_0.instance, "Main", webdslArgs);
		if (result != null && result.toString().contains(expected)) {
			System.out.println("check errors successful: " + expected);
		} else {
			testsFailed++;
			System.out.println("check errors failed - received: " + result);
			System.out.println("                    - expected to contain: " + expected);
		}
	}

	public static Context context;
	public static int testsFailed = 0;

	public static void main(String[] args) {
		context = Main.init();
		context.setStandAlone(true);
		try {
			try {
				runTests();
			} finally {
				context.getIOAgent().closeAllFiles();
			}
		} catch (StrategoErrorExit exit) {
			System.out.println("StrategoErrorExit");
			System.exit(1);
		} catch (StrategoExit exit) {
			System.out.println("StrategoExit");
			System.exit(1);
		}
		if (testsFailed > 0) {
			System.exit(1);
		}
	}
}
