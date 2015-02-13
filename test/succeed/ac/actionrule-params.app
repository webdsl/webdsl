application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    
    rule action actWithoutParams() { true }
    rule action actWithParams(i : Int) { i==3 }
    
    rule template templ(i:Int) { true
      rule action templAct() { true }
      rule action templAct(i1 : Int) { i1 == 1 }
    }
    
    rule page root() { true
      rule action pageAct() { true }
      rule action pageAct(i : Int) { i == 1 }
    }
    
    rule page pageArgs(i : Int, j:Int) { i==5
      rule action pageAct() { i==3 }
      rule action pageAct(j1 : Int) { i==1 && j1 ==2 }
    }

section somesection  
  
  define page root() {
    action pageAct(i : Int) { }
  }
  
  define page pageArgs(i : Int, j : Int) {
    action pageAct(i1 : Int, j1 : Int) { }
  }
  
  define template templ(i : Int) {
    action templAct(i1 : Int, j : Int) { }
  }
   
  