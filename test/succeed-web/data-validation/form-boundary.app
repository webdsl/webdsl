application formboundary

  entity User {
    name : String
  }
  
  page root() {
    for(us:User){
      output(us.name)
    }
    
    var s :String := ""
    var s1 :String := ""
    var u := User{
      name := "test"
    }
    
    request var tmp := ""
    request var tmp2 := ""
    
    form{
      databind{
        tmp := "ERROR";
      }
      validate(false,"ERROR")
    }
    form {
      label("Username"){ input(u.name) }
      label("Repeat Username"){ input(s1) {validate(s1 == u.name,"Not the same name.")} }
      submit save() {"save"}
    }
    form{
      databind{
        tmp2 := "ERROR";
      }
      validate(false,"ERROR")
    }
    output(tmp)
    output(tmp2)
    
    action save(){
      u.save();
    }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    d.getSubmit().click();
    assert(!d.getPageSource().contains("ERROR"));
  }
