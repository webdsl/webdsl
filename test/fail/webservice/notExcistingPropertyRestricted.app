//#1 no property noname in entity User
application test


	
  entity User {
  	name2 :: String
  	test :: Int
    
    synchronization configuration {
   		
    	toplevel  name property : name2
    	restricted properties : noname, test
    	  
    }  
  }
 

  define page root(){}