//There is no page with signature bla()
application test

  entity Entity0 {
    property :: String
  }

  define page root() {
    var e := Entity0{}
    navigate(bla()){""}
  }
  
  function bla(){}
