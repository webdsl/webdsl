application test

page root(){
  templ(Test{ s:= "1" t:=Test{s:="2"} })
}

entity Test {
  s : String
  t : Test
}

template templ( t: Test ){
  table{
    row{
      column{ output(t.s) }
      column{ output(t.t.s) }
      column{ output(t.t.t.s) }
  
      column{ input(t.s) }
      column{ input(t.t.s) }
      column{ input(t.t.t.s) }
  
      column{ calltemplate(t.s) }
      column{ calltemplate(t.t.s) }
      column{ calltemplate(t.t.t.s) }
      
      column{ calltemplate([ Test{} ][4].s) }
      column{ "foo123" }
    }
   }
}

template calltemplate( s: String ){
  output( s )
}

test {
  var d := getHtmlUnitDriver();
  d.get( navigate( root() ) );
  log( d.getPageSource() );
  assert( d.getPageSource().contains( "foo123" ) );
}
