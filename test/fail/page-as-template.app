//Cannot use page as template
//Template with signature

application test

  entity Entity0 {
    property :: String
  }

  define page root() {
    var e := Entity0{}
    root()
  }
