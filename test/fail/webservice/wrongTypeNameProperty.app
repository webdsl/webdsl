//#1 nameProperty type: Int is not compatible with expected type: String
application test

  entity User {
  	name2 :: Int
    webservice mapping {
   		
    	toplevel with name property : name2 
    }  
  }
 

  define page root(){}