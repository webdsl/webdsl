//#2 typecase alternative type 'String' is incompatible with type in typecase expression 'Ent'
//#2 typecase alternative type 'Int' is incompatible with type in typecase expression 'Ent'
//#2 typecase alternative type 'Tmp' is incompatible with type in typecase expression 'Ent'
//#2 typecase alternative should check subclass type 'Sub1' before super type 'Ent'
//#2 typecase alternative should check subclass type 'Sub2' before super type 'Sub1'

application test

page root(){}

entity Ent {
  i : String
}

entity Sub1 : Ent {
  sub1 : String
}

entity Sub2 : Sub1 {
  sub2 : String
}

entity Tmp{}


function typecasetest1( arg: Ent ) {
  typecase( arg as x ){
    Ent     { }  
    Sub1    { ""; }
    String  { }
    Int     { }
    Tmp     { }
    Sub2    { ""; }
    default { ""; }   
  }
}

function typecasetest2( arg: Ent ) {
  typecase( arg as x ){
    Sub1    { ""; }
    Sub2    { ""; }
    Ent     { ""; }
    default { ""; }   
  }
}


template typecasetest1( arg: Ent ) {
  typecase( arg as x ){
    Ent     { }  
    Sub1    { "" }
    String  { }
    Int     { }
    Tmp     { }
    Sub2    { "" }
    default { "" }   
  }
}

template typecasetest2( arg: Ent ) {
  typecase( arg as x ){
    Sub1    { "" }
    Sub2    { "" }
    Ent     { "" }
    default { "" }   
  }
}
