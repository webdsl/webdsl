application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule template bla(i:Int){
      i==1
      rule action save(s:String){
        s=="text" && i==1
      }
    }
    rule page root(){true}

section somesection  
  
  var globaluser := User{}
  
  define ignore-access-control mydivelem(){
    <div>
      elements()
    </div>
  }
  
  define bla(i:Int){
    mydivelem{  //content will be lifted (elements() call) and needs to inherit the access control rules
      "content is visible"
      form{
        submit save("text")[class="savebutton"]{"Save"}
      }
    }
    action save(s:String){
      globaluser.name := globaluser.name + s + i; 
    }
  }
 
  define page root(){
    bla(1)
    output(globaluser.name)
  }

  test messages {
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    
    assert(d.getPageSource().contains("content is visible"));
    
    var button := d.findElements(SelectBy.className("savebutton"))[0];
    button.click();
  
    assert(d.getPageSource().contains("content is visible"));
    assert(d.getPageSource().contains("text1"));
    
    d.close();
  }