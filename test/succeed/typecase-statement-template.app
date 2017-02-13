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

entity Sub3 : Ent {
  sub3 : String
}


function typecasetest( arg: Ent ): String {
  typecase( arg as x ){
    Sub2    { return x.sub2; }
    Sub3    { return x.sub3; }
    Sub1    { return x.sub1; }
    Ent     { return x.i; }    // x can not be null
    default { return "*"; }    // x can be null
  }
}

var testa := Ent{ i := "a" }
var testb := Sub1{ sub1 := "b" }
var testc := Sub2{ sub2 := "c" }
var testd := Sub3{ sub3 := "d" }

test {
  assert( typecasetest( testa ) == "a" );
  assert( typecasetest( testb ) == "b" );
  assert( typecasetest( testc ) == "c" );
  assert( typecasetest( testd ) == "d" );
  assert( typecasetest( null as Ent ) == "*" );
}


template typecasetest( arg: Ent ) {
  typecase( arg as x ){
    Sub2    { output( x.sub2 ) }
    Sub1    { output( x.sub1 ) }
    Sub3    { output( x.sub3 ) }
    Ent     { output( x.i ) }
    default { "*" }
  }
}

test {
  assert( rendertemplate( typecasetest( testa ) ) == "a" );
  assert( rendertemplate( typecasetest( testb ) ) == "b" );
  assert( rendertemplate( typecasetest( testc ) ) == "c" );
  assert( rendertemplate( typecasetest( testd ) ) == "d" );
  assert( rendertemplate( typecasetest( null as Ent ) ) == "*" );
}


function assigntest( arg: Ent ): String {
  var res := "";
  typecase( arg as x ){
    Sub2    { res := x.sub2; }
    Sub3    { res := x.sub3; }
    Sub1    { res := x.sub1; }
    Ent     { res := x.i; }
    default { res := "*"; }
  }
  return res;
}
test {
  assert( assigntest( testa ) == "a" );
  assert( assigntest( testb ) == "b" );
  assert( assigntest( testc ) == "c" );
  assert( assigntest( testd ) == "d" );
  assert( assigntest( null as Ent ) == "*" );
}
