//required by built-in output
application test

  entity Entity0 {
    property :: String
  }

  define page home() {
    var e := Entity0{}
    output(e)
  }
  
