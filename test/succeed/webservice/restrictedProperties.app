application test

  entity User {
    name2 :: String
    complex :: WikiText
    unwanted :: Int
    
    synchronization configuration {
    	
    	toplevel name property : name2  
    	restricted properties : complex, unwanted   
    }
  }
 

  define page root(){}