//#1 it is recommended to define read, write, create access control settings in the synchronization configuration for entity: User
//#1 it is recommended to define read, write, create access control settings in the synchronization configuration for entity: Test
//#1 it is recommended to define write, create access control settings in the synchronization configuration for entity: Test2
//#1 it is recommended to define read access control settings in the synchronization configuration for entity: Test3
application test

  entity User {
    name2 :: String
    complex :: WikiText
    unwanted :: Int
    password :: Secret
    
    synchronization configuration{
    	 
    	toplevel name property : name2  
        
    }
  }
  
  entity Test{
  	
  }
  
  entity Test2{
  	synchronization configuration{
  		access read : true
  	}
  }
  
  entity Test3{
  	synchronization configuration{
  		access create : true
  		access write : true
  	}
  }

  principal is User with credentials name2, password

