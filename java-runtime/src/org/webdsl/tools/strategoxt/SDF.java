package org.webdsl.tools.strategoxt;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.WeakHashMap;

import org.spoofax.interpreter.core.Interpreter;
import org.spoofax.interpreter.core.InterpreterException;
import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.jsglr.InvalidParseTableException;
import org.spoofax.jsglr.ParseTable;
import org.spoofax.jsglr.SGLR;
import org.spoofax.jsglr.SGLRException;

import aterm.ATerm;

/**
 * @author Lennart Kats <lennart add lclnet.nl>
 */
public class SDF {
	private static final HashMap<String, SDF> allSDF = new HashMap<String, SDF>();
	private static final HashMap<String, String> SGLRErrors = new HashMap<String, String>();
	
	public static HashMap<String, String> getSGLRErrors() {
		return SGLRErrors;
	}

	private static Interpreter imploder;
	
	private final SGLR parser;
	
	private final WeakHashMap<String, IStrategoTerm> parseCache
		= new WeakHashMap<String, IStrategoTerm>();
	
	private SDF(ParseTable table) {
		parser = Environment.createSGLR(table);
	}
	
	public static synchronized SDF get(String language, Class<?> ownerClass) {
		try {
			SDF result = get(language);
			if (result == null)
				result = register(language, ownerClass.getResourceAsStream("/" + language + ".tbl"));
			return result;
		} catch (InterpreterException e) {
			throw new RuntimeException(e);
		} catch (IOException e) {
			throw new RuntimeException(e);
		} catch (InvalidParseTableException e) {
			throw new RuntimeException(e);
		}
	}
	
	private synchronized static SDF register(String language, InputStream parseTable) throws IOException, InvalidParseTableException, InterpreterException {
		ParseTable table = Environment.loadParseTable(parseTable);
		SDF result = new SDF(table);
		allSDF.put(language, result);		
		
		if (imploder == null) {
			imploder = Environment.createInterpreter();
		}

		return result;
	}
	
	private static synchronized SDF get(String language) {
		return allSDF.get(language);
	}
	
	// TODO: Finer grained synchronization (but probably register in a synchronized fashion)
	
	public synchronized boolean isValid(String input) {
		try {
			IStrategoTerm parsed = parse(input);
			parseCache.put(input, parsed);
			return true;
		} catch (RuntimeException e) {
			return false;
		}
	}
	
	public synchronized IStrategoTerm parse(String input) {
		try {
			IStrategoTerm result = parseCache.get(input);
			if (result != null) return result;

			InputStream stream = new ByteArrayInputStream(input.getBytes());
			ATerm asfix = parser.parse(stream);

			result = implode(asfix);
			parseCache.put(input, result);
			return result;
		} catch (IOException e) {
			SGLRErrors.put(input,e.getMessage());
			throw new RuntimeException(e); // unexpected; fatal
		} catch (SGLRException e) {
			SGLRErrors.put(input,e.getMessage());
			throw new RuntimeException(e); // TODO: Handle SGLRException
		}
	}

	private IStrategoTerm implode(ATerm asfix) {
		try {
			imploder.setCurrent(Environment.getWrappedTermFactory().wrapTerm(asfix));
			imploder.invoke("implode_asfix_0_0");
		
			return imploder.current();
		} catch (InterpreterException x) {
			throw new RuntimeException(x); // unexpected; fatal
		}
	}
}
