//required by built-in output
application test

  entity Entity0 {
    property :: String
  }

  define page root() {
    var e := Entity0{}
    output(e)
  }
  
