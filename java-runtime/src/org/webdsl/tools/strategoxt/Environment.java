package org.webdsl.tools.strategoxt;

import java.io.IOException;
import java.io.InputStream;

import org.spoofax.interpreter.adapter.aterm.WrappedATermFactory;
import org.spoofax.interpreter.core.InterpreterException;
import org.spoofax.jsglr.InvalidParseTableException;
import org.spoofax.jsglr.ParseTable;
import org.spoofax.jsglr.ParseTableManager;
import org.spoofax.jsglr.SGLR;
import org.strategoxt.HybridInterpreter;
import org.strategoxt.lang.terms.TermFactory;

/**
 * Environment class that maintains shared objects.
 *
 * @author Lennart Kats <L.C.L.Kats add tudelft.nl>
 */
final class Environment {	
	private final static TermFactory factory = new TermFactory();
	
	private final static WrappedATermFactory wrappedFactory = new WrappedATermFactory();
	
	private final static ParseTableManager parseTableManager = new ParseTableManager(wrappedFactory.getFactory());
	
	public static TermFactory getTermFactory() {
		return factory;
	}
	
	public static WrappedATermFactory getWrappedTermFactory() {
		return wrappedFactory;
	}
	
	public static SGLR createSGLR(ParseTable parseTable) {
		return new SGLR(wrappedFactory.getFactory(), parseTable);
	}

	public static HybridInterpreter createInterpreter() throws IOException, InterpreterException {
		HybridInterpreter result = new HybridInterpreter(factory);
		return result;
	}
	
	public static ParseTable loadParseTable(InputStream parseTable)
		throws IOException, InvalidParseTableException {

		SGLR.setWorkAroundMultipleLookahead(true);
		return parseTableManager.loadFromStream(parseTable);
	}
}