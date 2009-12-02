application test

  define page root() {
    navigate profile("embed") { "go" }
  }

  define page profile(option : String) {
    init{
      case(option) {
        "embed" { return bla(); }
        default { return root(); }
      }
    }
  }
  
  define page bla(){
    "ok"
  }