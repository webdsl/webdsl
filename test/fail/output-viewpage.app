//required by built-in output
application test

  entity Entity {
    property :: String
  }

  define page home() {
    var e := Entity{}
    output(e)
  }
  
