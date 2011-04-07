//#2 Multiple page/template definitions with name 

application test

  entity User{
    username :: String
  }
  principal is User with credentials username
  define page login(){} 
  
  access control rules
    rule page root() { true }
    
  section pages
  
  define page root(){
    logout()
  }
  