//#1 no property noname in entity User
application test


	
  entity User {
  	name2 :: String
  	
    synchronization configuration {
   		
    	toplevel name property : noname 
    }  
  }
 

  define page root(){}