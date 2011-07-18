package org.webdsl.tools.strategoxt;

import java.io.IOException;
import java.io.InputStream;

import org.spoofax.interpreter.core.InterpreterException;
import org.spoofax.jsglr.client.Asfix2TreeBuilder;
import org.spoofax.jsglr.client.InvalidParseTableException;
import org.spoofax.jsglr.client.ParseTable;
import org.spoofax.jsglr.io.ParseTableManager;
import org.spoofax.jsglr.client.SGLR;
import org.strategoxt.HybridInterpreter;
import org.spoofax.terms.TermFactory;

/**
 * Environment class that maintains shared objects.
 *
 * @author Lennart Kats <L.C.L.Kats add tudelft.nl>
 */
public final class Environment {	
	private final static TermFactory factory = new TermFactory();
		
	private final static ParseTableManager parseTableManager = new ParseTableManager(factory);
	
	public static TermFactory getTermFactory() {
		return factory;
	}
	
	public static SGLR createSGLR(ParseTable parseTable) {
		return new SGLR(new Asfix2TreeBuilder(factory), parseTable);
	}

	public static HybridInterpreter createInterpreter() throws IOException, InterpreterException {
		HybridInterpreter result = new HybridInterpreter(factory);
		return result;
	}
	
	public static ParseTable loadParseTable(InputStream parseTable)
		throws IOException, InvalidParseTableException {

		// SGLR.setWorkAroundMultipleLookahead(true);
		return parseTableManager.loadFromStream(parseTable);
	}
}
