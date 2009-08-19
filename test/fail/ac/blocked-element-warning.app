//access to element always denied

application test

entity User{name :: String}

principal is User with credentials name


  define page root(){
  
  }