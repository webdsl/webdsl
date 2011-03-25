//define is nested too deeply

application test

  entity Task {
    description    :: String
  }
  
  define page root()
  {
    define one(){
      define two(){}
    }
  }

  define one(){}
  define two(){}
 