application test

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
        case(field.constructor()) {
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