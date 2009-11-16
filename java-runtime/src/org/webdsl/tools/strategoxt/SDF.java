package org.webdsl.tools.strategoxt;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.WeakHashMap;

import org.spoofax.interpreter.core.InterpreterException;
import org.spoofax.interpreter.terms.IStrategoTerm;
import org.spoofax.interpreter.terms.TermConverter;
import org.spoofax.jsglr.InvalidParseTableException;
import org.spoofax.jsglr.ParseTable;
import org.spoofax.jsglr.SGLR;
import org.spoofax.jsglr.SGLRException;
import org.strategoxt.HybridInterpreter;
import org.strategoxt.stratego_sglr.implode_asfix_0_0;
import org.strategoxt.stratego_sglr.stratego_sglr;

import aterm.ATerm;

/**
 * @author Lennart Kats <lennart add lclnet.nl>
 */
public class SDF {
	private static final HashMap<String, SDF> allSDF = new HashMap<String, SDF>();
	private static final HashMap<String, String> sglrErrors = new HashMap<String, String>();
	
	public static HashMap<String, String> getSGLRErrors() {
		return sglrErrors;
	}

	private static HybridInterpreter imploder;
	
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
	
	protected synchronized static SDF register(String language, InputStream parseTable) throws IOException, InvalidParseTableException, InterpreterException {
		org.spoofax.jsglr.Tools.setOutput(java.io.File.createTempFile("jsglr", "log").getAbsolutePath());
		
		ParseTable table = Environment.loadParseTable(parseTable);
		SDF result = new SDF(table);
		allSDF.put(language, result);		
		
		if (imploder == null) {
			imploder = Environment.createInterpreter();
		}

		return result;
	}
	
	protected static synchronized SDF get(String language) {
		return allSDF.get(language);
	}
	
	// TODO: Finer grained synchronization (but probably register in a synchronized fashion)
	
	public synchronized boolean isValid(String input) {
		try {
			IStrategoTerm parsed = parse(input);
			parseCache.put(input, parsed);
			return true;
		} catch (RuntimeException e) {
			if(e.getCause() != null && !(e.getCause() instanceof SGLRException)){
				e.printStackTrace();
			}
			return false;
		}
	}
	
	public synchronized IStrategoTerm parse(String input) {
		try {
			IStrategoTerm result = parseCache.get(input);
			if (result != null) return result;

			ATerm asfix = parser.parse(input, null); // TODO: start symbol?!

			result = implode(asfix);
			parseCache.put(input, result);
			return result;
		} catch (IOException e) {
			throw new RuntimeException(e); // unexpected; fatal
		} catch (SGLRException e) {
			sglrErrors.put(input,e.getMessage()); //store error message
			throw new RuntimeException(e);
		}
	}

	private IStrategoTerm implode(ATerm asfix) {
		IStrategoTerm wrappedTerm = Environment.getWrappedTermFactory().wrapTerm(asfix);
		IStrategoTerm term = TermConverter.convert(Environment.getTermFactory(), wrappedTerm);
		stratego_sglr.init(imploder.getCompiledContext());
		return implode_asfix_0_0.instance.invoke(imploder.getCompiledContext(), term);
	}
}
