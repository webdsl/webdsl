application test

section principal
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page root()
    {
      false
    }
  
section somesection  

   define page root(){
     "should not be able to see this"
   }
   
   define page accessDenied(){
     "custom access denied page"
   }   
   
