//#3 access control requires a principal
application test

  entity User {
    name2 :: String
    complex :: WikiText
    unwanted :: Int
    password :: Secret
    
    synchronization configuration{
    	
    	toplevel name property : name2  
        access read: true
        access write: true
        access create: true 
    }
  }
  



  define page root(){}