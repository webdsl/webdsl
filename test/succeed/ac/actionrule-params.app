application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    
    rule action actWithoutParams() { true }
    rule action actWithParams(i : Int) { i==3 }
    
    rule template templ() { true
    	rule action templAct() { true }
    	rule action templAct(i : Int) { i == 1 }
    }
    
    rule page root() { true
    	rule action pageAct() { true }
    	rule action pageAct(i : Int) { i == 1 }
    }
    
    rule page pageArgs(i : Int) { i==5
    	rule action pageAct() { i==3 }
    	rule action pageAct(j : Int) { i==1 && j ==2 }
    }

section somesection  
  
	define page root() {
		action pageAct(i : Int) { }
	}
	
	define page pageArgs(i : Int, j : Int) {
		action pageAct(i : Int, j : Int) { }
	}
	
	define template templ(i : Int) {
		action templAct(i : Int, j : Int) { }
	}
	 
	