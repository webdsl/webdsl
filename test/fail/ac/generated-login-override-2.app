//Template with signature
//not defined
application test

  define login(){} //overrides default generated login and blocks generation of authentication template
  entity User{
    username :: String
  }
  principal is User with credentials username
  
  access control rules
    rule page root() { true }
    
  section pages
  
  define page root(){
    authentication()
    logout()
  }
  