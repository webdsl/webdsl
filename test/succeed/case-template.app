application test

  define page root() {
    navigate profile("embed") { "go" }
  }

  define page profile(option : String) {

      case(option) {
        "embed" { bla() }
        default {  }
      }
  
  }
  
  define bla(){
    "ok"
  }