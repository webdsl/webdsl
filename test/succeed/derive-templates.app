application derivetest

page root(){}

derivetemplate mult First second third fourth {
  template first(){
    "first"
    "second"
    "third"
    var fourth := "fourth"
    output( fourth )
  }
}

derive mult Testone 2 3 Varname4
derive mult testtwo 5 6 varname7

test {
  log( rendertemplate( testone() ) );
  assert( rendertemplate( testone() ).contains( "testone23Varname4" ) );
  assert( rendertemplate( testtwo() ).contains( "testtwo56varname7" ) );
}
