application test

  entity Person{
  	name2 :: String
  }	
	
  entity User : Person {
  	
    synchronization configuration {
    	toplevel name property : name2 
    }  
  }
 

  define page root(){}