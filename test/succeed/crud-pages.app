application crudpages

  entity User {
    username    :: String (name)
  }
 
  var u_1 := User{username:= "test"}
 
  define page root(){
    navigate(createUser()){ "create" } " "
    navigate(user(u_1)){ "view" } " "
    navigate(editUser(u_1)){ "edit" } " "
    navigate(manageUser()){ "manage" }
  }
  
  derive crud User