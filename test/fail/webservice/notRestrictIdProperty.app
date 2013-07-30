//#1 it is not allowed to restrict property id
application test


	
  entity User {
  	name2 :: String
  	test :: Int
    
    synchronization configuration {  
   		
    	toplevel name property : name2
    	restricted properties : id, test
    	  
    }  
  }
 

  define page root(){}