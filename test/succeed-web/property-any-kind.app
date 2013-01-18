application test

  entity User {
    name : String
    ref  : User
    derived : String := "789"
    list : [User]
    set : {Temp}
  }
  
  entity Temp{
    name : String
  }
  
  define page root(){
    var u := User{
      name := "123" 
      ref := User{ name := "456" } 
      list := [ User{ name :="10" } ]
      set := { Temp{ name := "11" } }
    }
    var x : [Temp] := [ Temp{ name := "12" } ]
    
    output(u.name)
    output(u.ref.name)
    output(u.derived)
    output(u.list[0].name)
    output(u.set.list()[0].name)
    output(x[0].name)
  }
  
  test{
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("123456789101112"));
  }
