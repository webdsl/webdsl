application expandtest

page root(){}

expandtemplate mult to First second third fourth {
  template first(){
    "first"
    "second"
    "third"
    var fourth := "fourth"
    output( fourth )
  }
}

expand Testone 2 3 Varname4 to mult
expand testtwo 5 6 varname7 to mult

expand 1 2 3 to bla
expand 4 5 6 7 8 9 foo bar baz to bla

expandtemplate bla to x y z {
  template showx {
    "xyz"
  }
}

test {
  log( rendertemplate( testone() ) );
  assert( rendertemplate( testone() ).contains( "testone23Varname4" ) );
  assert( rendertemplate( testtwo() ).contains( "testtwo56varname7" ) );
  assert( rendertemplate( show1 ).contains( "123" ) );
  assert( rendertemplate( show4 ).contains( "456" ) );
  assert( rendertemplate( show7 ).contains( "789" ) );
  assert( rendertemplate( showfoo ).contains( "foobarbaz" ) );
}
