//#1 it is not allowed to restrict the name property
application test


	
  entity User {
  	name2 :: String
  	test :: Int
    
    synchronization configuration {
   		
    	toplevel name property : name2
    	restricted properties : name2, test  
    	  
    }  
  }
 

  define page root(){}