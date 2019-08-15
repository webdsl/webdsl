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

test {
  log( rendertemplate( testone() ) );
  assert( rendertemplate( testone() ).contains( "testone23Varname4" ) );
  assert( rendertemplate( testtwo() ).contains( "testtwo56varname7" ) );
}
