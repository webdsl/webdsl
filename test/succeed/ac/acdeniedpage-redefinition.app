application test

section principal
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page home()
    {
      false
    }
  
section somesection  

   define page home(){
     "should not be able to see this"
   }
   
   define page accessDenied(){
     "custom access denied page"
   }   
   