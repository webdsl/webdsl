//Object creation syntax is not allowed for generic types
//Entity object instantiation syntax is only supported for entity types

application test

  define page root(){}
  
  test one {
    var a := Set<String>{};
    var b := Facet{};
  }
