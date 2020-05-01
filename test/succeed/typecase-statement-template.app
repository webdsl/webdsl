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

function typecasenoalias( arg: Ent ): String {
  typecase( arg ){
    Sub2    { return arg.i + "3"; }
    Sub3    { return arg.i + "4"; }
    Sub1    { return arg.i + "2"; }
    Ent     { return arg.i + "1"; }
    default { return "5"; }
  }
}

var testa := Ent{ i := "a" }
var testb := Sub1{ i := "b" sub1 := "b" }
var testc := Sub2{ i := "c" sub2 := "c" }
var testd := Sub3{ i := "d" sub3 := "d" }

test {
  assert( typecasetest( testa ) == "a" );
  assert( typecasetest( testb ) == "b" );
  assert( typecasetest( testc ) == "c" );
  assert( typecasetest( testd ) == "d" );
  assert( typecasetest( null as Ent ) == "*" );

  assert( typecasenoalias( testa ) == "a1" );
  assert( typecasenoalias( testb ) == "b2" );
  assert( typecasenoalias( testc ) == "c3" );
  assert( typecasenoalias( testd ) == "d4" );
  assert( typecasenoalias( null as Ent ) == "5" );
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

template typecasetestnoalias( arg: Ent ) {
  typecase( arg ){
    Sub2    { output( arg.i + "3" ) }
    Sub1    { output( arg.i + "4" ) }
    Sub3    { output( arg.i + "2" ) }
    Ent     { output( arg.i + "1" ) }
    default { "5" }
  }
}

test {
  assert( rendertemplate( typecasetest( testa ) ) == "a" );
  assert( rendertemplate( typecasetest( testb ) ) == "b" );
  assert( rendertemplate( typecasetest( testc ) ) == "c" );
  assert( rendertemplate( typecasetest( testd ) ) == "d" );
  assert( rendertemplate( typecasetest( null as Ent ) ) == "*" );

  assert( rendertemplate( typecasetestnoalias( testa ) ) == "a1" );
  assert( rendertemplate( typecasetestnoalias( testb ) ) == "b4" );
  assert( rendertemplate( typecasetestnoalias( testc ) ) == "c3" );
  assert( rendertemplate( typecasetestnoalias( testd ) ) == "d2" );
  assert( rendertemplate( typecasetestnoalias( null as Ent ) ) == "5" );
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
