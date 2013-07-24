application test

  entity User {
    name :: String
    webservice mapping {
    	toplevel with name property : name 
    }
  }
 

  define page root(){}