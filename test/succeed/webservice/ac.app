application test

  entity User {
    name2 :: String
    complex :: WikiText
    unwanted :: Int
    
    synchronization configuration{
    	
    	toplevel name property : name2  
        access read: true
        access write: true
        access create: true  
    }
  }
 

  define page root(){}