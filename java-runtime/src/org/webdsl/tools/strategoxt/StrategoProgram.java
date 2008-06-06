package org.webdsl.tools.strategoxt;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import org.spoofax.interpreter.core.Interpreter;
import org.spoofax.interpreter.core.InterpreterException;
import org.spoofax.interpreter.terms.IStrategoTerm;

/**
 * @author Lennart Kats <lennart add lclnet.nl>
 */
public class StrategoProgram {
	private static final HashMap<String, StrategoProgram> allPrograms = new HashMap<String, StrategoProgram>();

	private final Interpreter interpreter;
	
	private StrategoProgram(Interpreter interpreter) {
		this.interpreter = interpreter;
	}
	
	/**
	 * Register a new Stratego program.
	 * 
	 * @param program
	 *            The stratego program to load (e.g., obtained using
	 *            StrategoProgram.class.getResourceAsStream("filename");
	 */
	public static StrategoProgram register(String programName, InputStream program) throws InterpreterException, IOException {
		Interpreter interpreter = Environment.createInterpreter();
		interpreter.load(program);

		StrategoProgram result = new StrategoProgram(interpreter);
		allPrograms.put(programName, result);
		
		return result;
	}
	
	public static StrategoProgram get(String programName) {
		return allPrograms.get(programName);
	}
	
	public IStrategoTerm apply(String strategy, IStrategoTerm term) throws InterpreterException {
		interpreter.setCurrent(term);
		
		// TODO: Properly rename strategy using underscores
		strategy = strategy.replace('-', '_') + "_0_0";
		
		boolean success = interpreter.invoke(strategy);
		
		// TODO: Better handling of failure
		if (!success) return Environment.getWrappedTermFactory().makeString("Evaluation failed");
		
		return interpreter.current();
	}
}
