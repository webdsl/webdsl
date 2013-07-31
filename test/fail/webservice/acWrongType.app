//#3 expression should be of type Bool
application test

  entity User {
    name2 :: String
    complex :: WikiText
    unwanted :: Int
    password :: Secret
    
    synchronization configuration{
    	
    	toplevel name property : name2  
        access read: 1
        access write: "test"
        access create: password 
    }
  }

principal is User with credentials name2, password

  define page root(){}