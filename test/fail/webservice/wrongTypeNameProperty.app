//#1 no property noname in entity User
application test

  entity User {
  	name2 :: Int
    webservice mapping {
   		
    	toplevel with name property : name2 
    }  
  }
 

  define page root(){}