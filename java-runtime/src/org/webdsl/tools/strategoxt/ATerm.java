package org.webdsl.tools.strategoxt;

import java.util.Arrays;
import java.util.List;

import org.spoofax.interpreter.terms.IStrategoAppl;
import org.spoofax.interpreter.terms.IStrategoString;
import org.spoofax.interpreter.terms.IStrategoTerm;

public class ATerm {
    
    public static List<IStrategoTerm> subterms(IStrategoTerm t){
      return Arrays.asList(t.getAllSubterms());   
    }
  
    public static String constructor(IStrategoTerm t){
        return t instanceof IStrategoAppl ? ((IStrategoAppl) t).getConstructor().getName() : "";
    }
    
    public static String stringValue(IStrategoTerm t){
        return t instanceof IStrategoString ? ((IStrategoString) t).stringValue() : t.toString();
    }
    
    public static IStrategoTerm get(IStrategoTerm t, int index){
        return t.getSubterm(index);
    }
    
    public static int length(IStrategoTerm t){
        return t.getSubtermCount();
    }
    
    public static String toString(IStrategoTerm t){
        return t.toString();
    }
    
    public static int toInt(IStrategoTerm t){
        return Integer.parseInt(t instanceof IStrategoString ? ((IStrategoString) t).stringValue() : t.toString());
    }
    
    public static IStrategoTerm toATerm(String t){
        return org.webdsl.tools.strategoxt.Environment.getTermFactory().parseFromString(t);
    }

}
