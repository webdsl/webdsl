application test

  entity User {
    name2 :: String
    complex :: WikiText
    unwanted :: Int
    
    webservice mapping {
    	
    	toplevel with name property : name2  
        access read: true
        access write: true
        access create: true  
    }
  }
 

  define page root(){}