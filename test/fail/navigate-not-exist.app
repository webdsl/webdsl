//There is no page with signature bla()
//Invalid url call
application test

  entity Entity0 {
    property :: String
  }

  define page root() {
    var e := Entity0{}
    navigate(bla()){""}
    navigate(url("x","y")){""}
    navigate(url(33)){""}
  }
  
  function bla(){}
