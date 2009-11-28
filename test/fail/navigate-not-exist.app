//Page with name 'bla' does not exist, this call expects a page with signature bla
application test

  entity Entity0 {
    property :: String
  }

  define page root() {
    var e := Entity0{}
    navigate(bla()){""}
  }
  
  function bla(){}
