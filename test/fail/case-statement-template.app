//#2 case alternative with type 'Bool' should be compatible with type in case expression 'String'
//#2 case alternative with type 'Int' should be compatible with type in case expression 'String'
//#2 case alternative with type 'Tmp' should be compatible with type in case expression 'String'
//case alternative with type 'String, String, Float, Tmp' should be compatible with type in case expression 'String, Int, Float, Tmp'
//case alternative with type 'String, String, String' should be compatible with type in case expression 'String, Int, Tmp'

application test

define page root(){}

entity Tmp{}

function casetest1( option: String ) {
  case( option ){
    "1"     {}
    true    {}
    5       {}
    Tmp{}   {}
    default {}
  }
  case( "1", 2, 2.0, Tmp{} ){
    "1", "2", 2.0, Tmp{} {  }
    default {  }
  }
}

template casetest1( option: String ) {
  case( option ){
    "1"     {""}
    true    {""}
    5       {""}
    Tmp{}   {""}
    default {""}
  }
  case( "1", 2, Tmp{} ){
    "1", "2", "3" {  }
    default {  }
  }
}