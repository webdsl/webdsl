//#1 no property noname in entity User
application test


	
  entity User {
  	name :: String
    webservice mapping {
   		
    	toplevel with name property : noname 
    }  
  }
 

  define page root(){}