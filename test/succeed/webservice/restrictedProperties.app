application test

  entity User {
    name2 :: String
    complex :: WikiText
    unwanted :: Int
    
    webservice mapping {
    	
    	toplevel with name property : name2  
    	restricted properties : compex, unwanted   
    }
  }
 

  define page root(){}