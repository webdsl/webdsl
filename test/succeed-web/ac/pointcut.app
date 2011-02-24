application test

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
  
    rule pointcut bar(i:Int){
      i >5 
      rule action save(j:Int){
        i > j
      }
    }
    
    pointcut bar(i:Int){
      template one(i),
      template two(i *),
      ajaxtemplate three(i *),
      page four(i)
    }

  rule page root(){true}      
  
section somesection  
  
  define one(i:Int){
    output(i)
    action save(k:Int){}
  }
  define two(i:Int,s:String){
    output(i) output(s)
  }
  define ajax three(i:Int,s:String){
    output(i) output(s)
  }
  define page four(i:Int){
    "foobar" output(i)
  }
  
  define page root(){
    one(6)
    two(7,"8")
    three(9,"10")
    navigate four(11)[class="navpage1"]{ "go" }
  }
  
  test messages {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");

    assert(d.getPageSource().contains("678910"));

    var nav := d.findElement(SelectBy.className("navpage1"));
    nav.click();
    
    assert(d.getPageSource().contains("foobar11"));
    
    d.close();

  }