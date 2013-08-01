//#1 name Property type: Int is not compatible with expected type: String
application test

  entity User {
  	name2 :: Int
   
   synchronization configuration {
   		
    	toplevel name property: name2 
    }  
  }
 

  define page root(){}