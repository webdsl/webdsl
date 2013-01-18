application test

  entity User {
    name : String
    ref  : User
    derived : String := "789"
  }
  
  define page root(){
    var u := User{name := "123" ref := User{ name := "456" } }
    output(u.name)
    output(u.ref.name)
    output(u.derived)
  }
  
  test{
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("123456789"));
  }
