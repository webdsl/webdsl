package org.webdsl.tools;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import org.spoofax.interpreter.terms.IStrategoAppl;
import org.spoofax.interpreter.terms.IStrategoConstructor;
import org.spoofax.interpreter.terms.IStrategoTerm;
import org.webdsl.tools.strategoxt.SDF;

import junit.framework.TestCase;

/**
 * @author Lennart Kats <lennart add lclnet.nl>
 */
public class TestStrategoXT extends TestCase {
	private final String WEBDSL_TABLE_PATH = "src/org/webdsl/dsl/syntax/WebDSL.tbl";
	
	private final String WEBDSL_EXAMPLE = "module foo section there is only an empty section";
	
	private InputStream getTableStream() throws Exception {
		// return TestStrategoXT.class.getResourceAsStream(WEBDSL_TABLE_PATH);
		return new FileInputStream(WEBDSL_TABLE_PATH);
	}
	
	public void testTableAvailable() {
		assertTrue("Parse table must exist", new File(WEBDSL_TABLE_PATH).exists());
		assertTrue("Parse table must have size > 0", new File(WEBDSL_TABLE_PATH).length() > 0);
	}
	
	public void testRegisterTable() throws Exception {
		SDF.register("WebDSL", getTableStream());
	}
	
	public void testParse() throws Exception {
		IStrategoTerm term = SDF.get("WebDSL").parseToTerm(WEBDSL_EXAMPLE);
		
		assertTrue(term.getTermType() == IStrategoTerm.APPL);
		
		IStrategoConstructor constructor = ((IStrategoAppl) term).getConstructor();
		
		assertTrue(constructor.getName().equals("Module"));
	}
	
	public void testParseToString() throws Exception {
		String term = SDF.get("WebDSL").parseToString(WEBDSL_EXAMPLE);
		
		assertTrue(term.startsWith("Module"));
	}
	
	/* TODO: Proper StrategoProgram unit test
	
	public void testRunStratego() throws Exception {
		StrategoProgram.register(programName, program);
		StrategoProgram.get(programName).apply(strategy, term);
	}
	*/
}
