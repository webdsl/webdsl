package org.webdsl.tools.strategoxt;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

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
	
	private static Interpreter imploder;
	
	private final SGLR parser;
	
	private final IdentityWeakHashMap<String, IStrategoTerm> parseCache
		= new IdentityWeakHashMap<String, IStrategoTerm>();
	
	private SDF(ParseTable table) {
		parser = Environment.createSGLR(table);
	}
	
	public static synchronized SDF get(String language, Class<?> tableOwner) throws IOException, InvalidParseTableException, InterpreterException {
		SDF result = get(language);
		if (result == null)
			result = register(language, tableOwner.getResourceAsStream("/" + language + ".tbl"));
		return result;
	}
	
	public synchronized static SDF register(String language, InputStream parseTable) throws IOException, InvalidParseTableException, InterpreterException {
		ParseTable table = Environment.loadParseTable(parseTable);
		SDF result = new SDF(table);
		allSDF.put(language, result);		
		
		if (imploder == null) {
			imploder = Environment.createInterpreter();
		}

		return result;
	}
	
	public static synchronized SDF get(String language) {
		return allSDF.get(language);
	}
	
	// TODO: Finer grained synchronization (but probably register in a synchronized fashion)
	
	public synchronized String parseToString(String input) throws SGLRException {
		IStrategoTerm parsed = parseToTerm(input);
		String result = new String(parsed.toString()); // ensure string is not interned
		
		parseCache.put(result, parsed);
		
		return result;
	}
	
	public synchronized IStrategoTerm parseToTerm(String input) throws SGLRException {
		try {
			IStrategoTerm result = parseCache.get(input);
			if (result != null) return result;
		
			InputStream stream = new ByteArrayInputStream(input.getBytes());
			ATerm asfix = parser.parse(stream);

			return implode(asfix);
		} catch (IOException x) {
			throw new RuntimeException(x); // unexpected; fatal
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
