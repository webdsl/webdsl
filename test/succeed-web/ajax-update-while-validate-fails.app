application test

page root(){
  submitlink action{ A{}.save(); replace(p, show("should not be visible")); }{ "go" }
  placeholder p{}
}

ajaxtemplate show(s:String){
  output(s)
}

entity A{
  name : String 
  validate(name != "", "name cannot be empty")
}

test{
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  d.getSubmit().click();
  assert( ! d.getPageSource().contains("should not be visible") );
  
  d.get( navigate( aftercommit() ) );
  d.getSubmits()[0].click();
  assert( ! d.getPageSource().contains("should not be visible") );

  d.get( navigate( aftercommit() ) );
  d.getSubmits()[1].click();
  assert( ! d.getPageSource().contains("should not be visible") );
}

entity B{
  b: B
}

init{
  var b1 := B{}.save();
  var b2 := B{}.save();
  b1.b := b2;
  b2.b := b1;
}
page aftercommit(){
  // if Hibernate does not have referencing entity loaded,
  // the flush fails with Referential integrity constraint violation
  submitlink action{ (from B limit 1)[0].delete(); replace(p, show("should not be visible")); }{ "one loaded" }
  
  // if Hibernate has referencing entity loaded, deleting a B will trigger 
  // org.hibernate.ObjectDeletedException: deleted object would be re-saved by cascade
  submitlink action{ (from B)[0].delete(); replace(p, show("should not be visible")); }{ "all loaded" }
  
  placeholder p{}
}



