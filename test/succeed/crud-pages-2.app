application crudpages

  entity User {
    username    :: String (name)
    parent -> Parent
  }
  
  entity Parent{} // no view page
 
  var u_1 := User{username:= "test"}
  var p_1 := Parent{}
 
  define page root(){
    navigate(createUser()){ "create" } " "
    navigate(user(u_1)){ "view" } " "
    navigate(editUser(u_1)){ "edit" } " "
    navigate(manageUser()){ "manage" }
  }
  
  derive crud User