application test

  entity User {
    username    :: String
  }
  
  define main() {
    body()
  }
  
  define body() {
    "default body"
  }
  
  var u:User := User{username := "0"};
  
  define page root() {
    main()
    action save() {
      u.username := "rootbutton pressed" ;           
    }
    define body() {
      action save2() {
        u.username := "rootbutton2 pressed" ;           
      }
      form { 
        action("save", save())[class="rootbutton"]
        action("save", save2())[class="rootbutton2"]
      }
    }
    output(u.username)
  }

  define liftedelements(){
    elements()
  }

  define page test()
  {
    main()
    define body() {
      form { 
        liftedelements { 
          action("Save", save())[class="savebutton"]
          action("Cancel", cancel())[class="cancelbutton"]
        }
      }
      action save() { 
        u.username := "savebutton pressed";
        return root();
      }
    }
    action cancel() {
      u.username := "cancelbutton pressed";
      return root();
    }
  }
 
  test actionsubmits{
    var d : WebDriver := getFirefoxDriver();
    
    d.get(navigate(root()));
    var rootbutton := d.findElements(SelectBy.className("rootbutton"))[0];
    rootbutton.click();
    assert(d.getPageSource().contains("rootbutton pressed"));
    
    d.get(navigate(root()));
    var rootbutton2 := d.findElements(SelectBy.className("rootbutton2"))[0];
    rootbutton2.click();
    assert(d.getPageSource().contains("rootbutton2 pressed"));
    
    d.get(navigate(test()));
    var savebutton := d.findElements(SelectBy.className("savebutton"))[0];
    savebutton.click();
    assert(d.getPageSource().contains("savebutton pressed"));
    
    d.get(navigate(test()));
    var cancelbutton := d.findElements(SelectBy.className("cancelbutton"))[0];
    cancelbutton.click();
    assert(d.getPageSource().contains("cancelbutton pressed"));
  }