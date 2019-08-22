application test

type String{
  org.webdsl.tools.strategoxt.ATerm.toATerm as parseATerm(): ATerm
}

native class org.spoofax.interpreter.terms.IStrategoTerm as ATerm{
  org.webdsl.tools.strategoxt.ATerm.subterms as subterms(): [ATerm]
  org.webdsl.tools.strategoxt.ATerm.constructor as cons(): String
  org.webdsl.tools.strategoxt.ATerm.stringValue as stringValue(): String
  org.webdsl.tools.strategoxt.ATerm.get as get( Int ): ATerm
  org.webdsl.tools.strategoxt.ATerm.length as length(): Int
  org.webdsl.tools.strategoxt.ATerm.toString as toString(): String
  org.webdsl.tools.strategoxt.ATerm.toInt as toInt(): Int
}

  define page root() {

  }

  entity LastingEffectType{
    name :: String
  }
  entity LastingEffect{
    interval :: Int
    type -> LastingEffectType
  }
  
  function addLastingEffectProperties(le : LastingEffect, fields : List<ATerm>, newtypes : List<LastingEffectType>) {    
      for(field : ATerm in fields) {
        case(field.cons()) {
          "Interval" { le.interval := field.get(0).toString().parseInt(); }
          "LastingEffectType" { 
            var t := findLastingEffectTypeByName(field.get(0).toString());
            if(t.length > 0){
              le.type := t.get(0); 
            }
            else{
              var results : List<LastingEffectType> := [let | let:LastingEffectType in newtypes where field.get(0).toString() == let.name ];
              if(results.length > 0){
                le.type := results.get(0);
              }
              else{
                validate(false,"lasting effect type "+field.get(0).toString()+" does not exist.");
              }
            }
          }
        }
      }
  }