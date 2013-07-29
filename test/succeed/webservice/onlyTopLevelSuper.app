application test

  entity Person{
  	name2 :: String
  }	
	
  entity User : Person {
    webservice mapping {
    	toplevel with name property : name2 
    }  
  }
 

  define page root(){}