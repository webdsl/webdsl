import org.spoofax.interpreter.terms.IStrategoTerm;
import org.strategoxt.lang.Context;
import org.strategoxt.lang.StrategoErrorExit;
import org.strategoxt.lang.StrategoExit;

import org.webdsl.webdslc.Main;

public class TestLSP {

	public static void runTests() {
		checkerrors("testapp.app","Template with signature tcallnotdefined() not defined");
		// TemplateCall - resolve
		resolve(6, 3, "testapp.app", "At(\"testapp.app\",10,1,10,24)");
		resolve(6, 8, "testapp.app", "At(\"testapp.app\",10,1,10,24)");
		resolve(4, 3, "./imported.app", "At(\"testapp.app\",10,1,10,24)");
		resolve(7, 3, "testapp.app", "At(\"./imported.app\",3,1,5,2)");
		// ThisCall - global function resolve
		resolve(16, 4, "testapp.app", "At(\"testapp.app\",15,1,20,2)");
		resolve(17, 3, "testapp.app", "At(\"testapp.app\",21,1,21,36)");
		resolve(17, 14, "testapp.app", "At(\"testapp.app\",22,1,22,50)");
		resolve(17, 32, "testapp.app", "At(\"testapp.app\",15,1,20,2)");
		resolve(18, 5, "testapp.app", "At(\"testapp.app\",22,1,22,50)");
		resolve(19, 5, "testapp.app", null);
		// ThisCall - entity function resolve
		resolve(35, 6, "testapp.app", "At(\"testapp.app\",25,3,25,30)");
		resolve(36, 7, "testapp.app", "At(\"testapp.app\",33,3,33,38)");
		resolve(37, 11, "testapp.app", "At(\"testapp.app\",26,3,26,59)");
		resolve(38, 9, "testapp.app", "At(\"testapp.app\",42,3,45,4)");
		resolve(43, 7, "testapp.app", "At(\"testapp.app\",25,3,25,30)");
		resolve(44, 11, "testapp.app", "At(\"testapp.app\",42,3,45,4)");
		// Call - entity function resolve
		resolve(30, 8, "testapp.app", "At(\"testapp.app\",25,3,25,30)");
		resolve(30, 16, "testapp.app", "At(\"testapp.app\",26,3,26,59)");
		resolve(30, 34, "testapp.app", "At(\"testapp.app\",27,3,27,49)");
		resolve(31, 9, "testapp.app", "At(\"testapp.app\",26,3,26,59)");
		// Var - resolve
		resolve(50, 9, "testapp.app", "At(\"testapp.app\",49,3,49,17)");
		resolve(50, 16, "testapp.app", "At(\"testapp.app\",48,16,48,27)");
		resolve(57, 8, "testapp.app", "At(\"testapp.app\",53,1,53,25)");
		resolve(58, 10, "testapp.app", "At(\"testapp.app\",54,9,54,32)");
		resolve(59, 10, "testapp.app", "At(\"testapp.app\",62,1,62,35)");
		
		// TemplateCall - completion
		complete(6, 3, "testapp.app", "(\"example(key)\",\"example(key: String) - template call\"),(\"example(num)\",\"example(num: Int) - template call\")");		
		// Var - completion
		complete(50, 9, "testapp.app", "(\"abc\",\"abc: String - local variable\"),(\"arg\",\"arg: String - local variable\"),(\"globaluser\",\"globaluser: User - global variable\"),(\"usersession\",\"usersession: Usersession - session variable\"),(\"requestscoped\",\"requestscoped: String - request variable\")");
		complete(57, 12, "testapp.app", "(\"globaluser\",\"globaluser: User - global variable\"),(\"usersession\",\"usersession: Usersession - session variable\"),(\"requestscoped\",\"requestscoped: String - request variable\")");
		complete(58, 12, "testapp.app", "(\"globaluser\",\"globaluser: User - global variable\"),(\"usersession\",\"usersession: Usersession - session variable\"),(\"requestscoped\",\"requestscoped: String - request variable\")");
		complete(59, 12, "testapp.app", "(\"globaluser\",\"globaluser: User - global variable\"),(\"usersession\",\"usersession: Usersession - session variable\"),(\"requestscoped\",\"requestscoped: String - request variable\")");
		complete(65, 4, "testapp.app", "(\"arg1\",\"arg1: Int - local variable\"),(\"globaluser\",\"globaluser: User - global variable\"),(\"usersession\",\"usersession: Usersession - session variable\"),(\"requestscoped\",\"requestscoped: String - request variable\")");
		complete(70, 7, "testapp.app", "\"two(i: Int, s: String): String - function call\"),(\"two(s)\",\"two(s: String) - function call\")");
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
		if (result != null && result.toString().equals(expected) || expected == null && result == null) {
			System.out.println("resolve successful: " + result);
		} else {
			testsFailed++;
			System.out.println("resolve (" + line + "," + column + "," + file + ") failed");
			System.out.println("  - received: " + result);
			System.out.println("  - expected: " + expected);
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
			System.out.println("completion (" + line + "," + column + "," + file + ") failed");
			System.out.println("  - received: " + result);
			System.out.println("  - expected to contain: " + expected);
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
