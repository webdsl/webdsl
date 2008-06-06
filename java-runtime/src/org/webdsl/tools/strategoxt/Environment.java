package org.webdsl.tools.strategoxt;

import java.io.IOException;
import java.io.InputStream;

import org.spoofax.interpreter.core.Interpreter;
import org.spoofax.interpreter.core.InterpreterException;
import org.spoofax.interpreter.adapter.aterm.WrappedATermFactory;
import org.spoofax.jsglr.InvalidParseTableException;
import org.spoofax.jsglr.ParseTable;
import org.spoofax.jsglr.ParseTableManager;
import org.spoofax.jsglr.SGLR;

import aterm.ATermFactory;

/**
 * Environment class that maintains shared objects.
 *
 * @author Lennart Kats <L.C.L.Kats add tudelft.nl>
 */
final class Environment {	
	private final static WrappedATermFactory wrappedFactory
		= new WrappedATermFactory();
		
	private final static ATermFactory factory = wrappedFactory.getFactory();
	
	private final static ParseTableManager parseTableManager
		= new ParseTableManager(factory);
	
	public static WrappedATermFactory getWrappedTermFactory() {
		return wrappedFactory;
	}
	
	public static SGLR createSGLR(ParseTable parseTable) {
		SGLR.setWorkAroundMultipleLookahead(true);
		return new SGLR(factory, parseTable);
	}

	public static Interpreter createInterpreter() throws IOException, InterpreterException {
		Interpreter result = new Interpreter(wrappedFactory);
		result.load("/lib/libstratego-lib.ctree");
		result.load("/lib/libstratego-sglr.ctree");
		return result;
	}
	
	public static ParseTable loadParseTable(InputStream parseTable)
		throws IOException, InvalidParseTableException {
		
		return parseTableManager.loadFromStream(parseTable);
	}
}