//#1 no property specialName in entity User
application test

  entity Admin : User{
  	specialName :: String
  }

	
  entity User {
  	name2 :: String
    
    synchronization configuration {
   		
    	toplevel name property : specialName 
    }  
  }
 

  define page root(){}