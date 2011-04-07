//#2 Multiple page/template definitions with name 
application test

  define login(){} //overrides default generated login 
  entity User{
    username :: String
  }
  principal is User with credentials username
  
  access control rules
    rule page root() { true }
    
  section pages
  
  define page root(){
    login()
    logout()
  }
  