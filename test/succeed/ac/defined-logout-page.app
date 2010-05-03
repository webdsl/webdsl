//conflict with generated logout template

application test
  
  entity User{
    name :: String
  }

  principal is User with credentials name

section somesection  

  define page root(){
    navigate logout() {}
  }

  define page logout(){}