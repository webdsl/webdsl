application test

page root(){
  typecasetest( testa )
  typecasetest( testb )
  typecasetest( testc ) 
  typecasetest( null as Ent )
}

entity Ent {
  i : String
}

entity Sub1 : Ent {
  sub1 : String
}

entity Sub2 : Sub1 {
  sub2 : String
}

var testa := Ent{ i := "a" }
var testb := Sub1{ sub1 := "b" }
var testc := Sub2{ sub2 := "c" }

htmlwrapper {
  testwrap div[class="test-wrap"]
}

template typecasetest( arg: Ent ) {
  var marker := "TEST123"
  var testin := 0
  testwrap{span{div{block{  // nesting should not interfere

  typecase( arg as x ){
    Sub2 { output( marker ) output( x.sub2 ) }
    Sub1 { output( marker ) output( x.sub1 ) }
    Ent { 
      output( marker ) output( x.i ) 
      form{
        input( testin )[class="testinput1"]
        submit action{ validate(false, "submitted:"+testin ); }{ "save" }
      }
    }
    default { output( marker ) "*"
      form{
        input( testin )[class="testinput2"]
        submit action{ validate(false, "submitted:"+testin ); }{ "save" }
      }
    }
  }

  }}}}
}

test {
  var marker := "TEST123";
  assert( rendertemplate( typecasetest( testa ) ).contains( marker + "a" ) );
  assert( rendertemplate( typecasetest( testb ) ).contains( marker + "b" ) );
  assert( rendertemplate( typecasetest( testc ) ).contains( marker + "c" ) );
  assert( rendertemplate( typecasetest( null as Ent ) ).contains( marker + "*" ) );
  
  var d : WebDriver := getHtmlUnitDriver();
  d.get(navigate(root()));
  var i1 := d.findElement( SelectBy.className( "testinput1" ) );
  i1.sendKeys( "1" );
  var i2 := d.findElement( SelectBy.className( "testinput2" ) );
  i2.sendKeys( "2" );
  d.getSubmits()[0].click();
  assert(d.getPageSource().contains("submitted:1"));
  
  i1 := d.findElement( SelectBy.className( "testinput1" ) );
  i2 := d.findElement( SelectBy.className( "testinput2" ) );
  i1.sendKeys( "1" );
  i2.sendKeys( "2" );
  d.getSubmits()[1].click();
  assert(d.getPageSource().contains("submitted:2"));
}
