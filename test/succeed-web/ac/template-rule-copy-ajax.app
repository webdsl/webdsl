// need something to declare that one template has to use the checks of another template, so the ac rules can
// easily be copied when lifting local template definitions

application test

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
  
    rule ajaxtemplate bar(i:Int){
      i >5 
      rule action save(*){
        i >5
      }
    }

  rule page root(){true}      
  
section somesection  
  
  define foo(u:User, i : Int){

    apply ac rules bar(i)

    submit save("dfgdfg",User{}){"save"}
    action save(s:String, u2:User){
      var test := "" + (s.length() + i) + (u == u2);
      User{name := test}.save();
      return root();
    }
  } 

  define ajax bar(i:Int){
    foo(User{},i)
  }
  
  define page root(){
    bar(6)
    
    for(u:User){
      output(u.name)
    }
  }
  
  test messages {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");

    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 1, "expected 1 <input> elements did not match");
    elist[0].click();
    
    assert(!d.getPageSource().contains("12false"), "action not completed");
    
    d.close();

  }