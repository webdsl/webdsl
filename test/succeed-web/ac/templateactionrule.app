application test

section principal

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page root() {
      true
    }
    rule template main(first:Int) {
      true
      rule action test(second:Int) {
        first==second
      }
      rule action anothertest(second:Int) {
        first!=second
      }
    }
  
section somesection  
  
  define main(templatearg : Int) 
  {
    body()
    form{
      submit test(6) [class="button-elem"] { "test" }
      submit anothertest(6) [class="button-elem-2"] { "anothertest" }
    }
    
    action test(actionarg : Int){
      actionarg==6;
      globalu.name := "foobar123";
      return root();
    }
    action anothertest(actionarg : Int){
      actionarg==6;
      return root();
    }
  }
  
  define page root(){
    main(6)
    define body(){
      "test"
      output(globalu.name)
    }
  }
  
  var globalu := User{}
    
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    assert(!d.getPageSource().contains("foobar123"));
    assert(!d.getPageSource().contains("button-elem-2"));
    
    var button := d.findElements(SelectBy.className("button-elem"))[0];
    button.click();
        
    assert(d.getPageSource().contains("foobar123"));
  }
  
   