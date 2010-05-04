application test

  request var u1 : Unit
  request var u2 := Unit { name := "test" }
  request var u3 := "u3bla"
  request var u4 : String := "u4text"
  
  
  entity Unit {
    name :: String
  
  }
  
  define page root(){
    
    init {
      // Global vars are immutable, request vars are mutable
      u3 := "xxx";
    }
    
    output(u1.name)
    output(u2.name)
    output(u3)
    output(u4)
    
  }