//Not a valid navigate link, page does not exist
application test

  entity Entity {
    property :: String
  }

  define page home() {
    var e := Entity{}
    navigate(bla()){""}
  }
  
  function bla(){}