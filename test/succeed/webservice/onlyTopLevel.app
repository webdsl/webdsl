application test

  entity User {
    name2 :: String
    
    synchronization configuration{
    	
    	toplevel name property : name2   
    }
  }
 

  define page root(){}