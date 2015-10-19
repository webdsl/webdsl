application controlflowcaching

page root(){
  // should not skip validation, when invalid number is entered
  form{
    if(tmp1.i == 0){
      input(tmp1.i)[ class="input1" ]
    }
    submit action{}{"save"}    
  }
}
page test2(){
  // should find action, when i != 0 is entered
  form{
    if(tmp2.i == 0){
      input(tmp2.i)[ class="input1" ]
      submit action{}{"save"}     
    }
  }
}
page test3(){
  // should find action, when i != 0 is entered
  form{
    for(t:Tmp2 where t.i == 0){
      input(t.i)[ class="input1" ]
      submit action{}{"save"}  
    }
  }  
}

var tmp1 := Tmp{}
var tmp2 := Tmp{}
entity Tmp{
  i: Int
}

var tmp21 := Tmp2{}
var tmp22 := Tmp2{}
entity Tmp2{
  i: Int
}


test{
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  var i1 := d.findElement( SelectBy.className( "input1" ) );
  i1.sendKeys( "abc" );
  d.getSubmit().click();
  log( d.getPageSource() );
  assert( d.getPageSource().contains( "Not a valid number" ) );
  
  d.get( navigate( test2() ) );
  var i2 := d.findElement( SelectBy.className( "input1" ) );
  i2.sendKeys( "42" );
  d.getSubmit().click();
  log( d.getPageSource() );
  assert( ! d.getPageSource().contains( "404" ) );
 
  d.get( navigate( test3() ) );
  var i3 := d.findElement( SelectBy.className( "input1" ) );
  i3.sendKeys( "42" );
  d.getSubmit().click();
  log( d.getPageSource() );
  assert( ! d.getPageSource().contains( "404" ) ); 
}



