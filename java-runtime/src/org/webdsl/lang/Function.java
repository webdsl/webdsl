package org.webdsl.lang;

import org.apache.commons.lang.ArrayUtils;

public class Function<Returntype> implements IFunction {
    
    IFunction function;
    Object[] partialArgs;
    
    public Function(IFunction thefunction){
        this.function = thefunction;
    }
    
    @SuppressWarnings("unchecked")
    public Returntype apply(Object[] args){
       if(partialArgs != null){
         return (Returntype) function.apply(ArrayUtils.addAll(args, partialArgs)); 
       }
       else{
         return (Returntype) function.apply(args);
       }
    }
    
    public Function<Returntype> partial(Object[] args){
        partialArgs = args;
        return this;
    }
}
